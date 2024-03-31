import 'package:fixtex/features/garage_owner/booking_settings/bloc/booking_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class BookingSettingsView extends StatefulWidget {
  const BookingSettingsView({super.key});

  @override
  State<BookingSettingsView> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<BookingSettingsView> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  List<int> _workingDays = [];
  List<DateTime> _offDays = [];
  List<WorkingHour> _workingHours = [];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(FetchSchedules());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: kMainColor,
        title: const Text(
          "Schedule",
          style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,),
          
        ),
        // shadowColor: kGreyDarkColor,
        elevation: 2,
        centerTitle: true,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {

          if (state is BookingInitial) {
            BlocProvider.of<BookingBloc>(context).add(FetchSchedules());
            return const Center(child: CircularProgressIndicator(),);
          }

          if (state is FetchedSchedules) {
            // Update UI with the fetched schedules

            // Retrieve working days and hours from the fetched state
            Map<int, List<TimeOfDay>> workingDaysAndHours =
                state.workingDaysAndHours;

            // Retrieve disabled dates from the fetched state
            List<DateTime> disabledDates = state.disabledDates;

            // Update local state with the fetched data
            _workingDays = workingDaysAndHours.keys.toList();
            _offDays = disabledDates;

            // Update working hours list
            _workingHours = _workingDays.map((day) {
              return WorkingHour(
                day: _days[day - 1],
                startTime: workingDaysAndHours[day]?[0] ?? const TimeOfDay(hour: 08, minute: 00),
                endTime: workingDaysAndHours[day]?[1] ?? const TimeOfDay(hour: 18, minute: 00),
              );
            }).toList();

            BlocProvider.of<BookingBloc>(context).add(StartEditing());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Working Days'),
                  _buildWorkingDays(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Working Hours'),
                  _buildWorkingHours(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Off Days'),
                  _buildOffDayDropdown(),                
                  const SizedBox(height: 25),
                  _buildRacetrackButton('Save', onPressed: () async{
                    Map<int, List<TimeOfDay>> workingDaysAndHours = {};
                    for (int day in _workingDays) {
                      workingDaysAndHours[day] = [
                        _workingHours[day - 1].startTime,
                        _workingHours[day - 1].endTime
                      ];
                    }
                    BlocProvider.of<BookingBloc>(context).add(
                      AddSchedules(
                        workingDaysAndHours: workingDaysAndHours,
                        disabledDates: _offDays,
                        disabledDays: _workingDays.length,
                      ),
                    );
                    showDialog(context: context, builder: (context){
                      return const AlertDialog(content: Icon(Icons.check, color: Colors.white,),);
                    });
                    BlocProvider.of<BookingBloc>(context).add(FetchSchedules());
                  }),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkingDays() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: _days.map((day) {
          return ChoiceChip(
            label: Text(
              day,
              style: const TextStyle(fontSize: 14),
            ),
            selected: _workingDays.contains(_days.indexOf(day) + 1),
            selectedColor: Colors.green[300],
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _workingDays.add(_days.indexOf(day) + 1);
                } else {
                  _workingDays.remove(_days.indexOf(day) + 1);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOffDayDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ListView.builder(
            shrinkWrap: true,
            itemCount: _offDays.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_offDays[index].toIso8601String()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _offDays.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              );
    
              if (pickedDate != null) {
                _showOffHoursPicker(pickedDate);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text( 'Add Off Day'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOffHoursPicker(DateTime selectedDate) async {
    setState(() {
      // Use a custom date format for off days without a time range
      _offDays.add(selectedDate);
    });
  }

Widget _buildWorkingHours() {
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _workingDays.length,
          itemBuilder: (context, index) {
            if(index<_workingHours.length) {
              return Padding(
              padding: const EdgeInsets.all(8.0),
              child: WorkingHourWidget(
                day: _days[_workingDays[index] - 1],
                onTimeChanged: (newStartTime, newEndTime) {
                  setState(() {
                    if (_workingHours.any(
                        (hour) => hour.day == _days[_workingDays[index] - 1])) {
                      _workingHours[index] = WorkingHour(
                        day: _days[_workingDays[index] - 1],
                        startTime: newStartTime,
                        endTime: newEndTime,
                      );
                    } else {
                      _workingHours.add(WorkingHour(
                        day: _days[_workingDays[index] - 1],
                        startTime: newStartTime,
                        endTime: newEndTime,
                      ));
                    }
                  });
                },
                startTime: _workingHours[index].startTime,
                endTime: _workingHours[index].endTime,
              ),
            );
            }
            else{
              return Padding(
              padding: const EdgeInsets.all(8.0),
              child: WorkingHourWidget(
                day: _days[_workingDays[index] - 1],
                onTimeChanged: (newStartTime, newEndTime) {
                  setState(() {
                    if (_workingHours.any(
                        (hour) => hour.day == _days[_workingDays[index] - 1])) {
                      _workingHours[index] = WorkingHour(
                        day: _days[_workingDays[index] - 1],
                        startTime: newStartTime,
                        endTime: newEndTime,
                      );
                    } else {
                      _workingHours.add(WorkingHour(
                        day: _days[_workingDays[index] - 1],
                        startTime: newStartTime,
                        endTime: newEndTime,
                      ));
                    }
                  });
                },
                startTime: const TimeOfDay(hour: 00, minute: 00),
                endTime: const TimeOfDay(hour: 00, minute: 00),
              ),
            );
            
            }
          },
        ),
      ],
    ),
  );
}

  Widget _buildRacetrackButton(String label,
      {required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
         title,
         style: const TextStyle(fontWeight: FontWeight.w600,
        fontSize: 22,),
        
      ),
    );
  }
}

// Define a class for working hours
class WorkingHour {
  final String day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  WorkingHour({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

// Widget for setting working hours for each day
class WorkingHourWidget extends StatefulWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String day;
  final Function(TimeOfDay, TimeOfDay) onTimeChanged;

  const WorkingHourWidget({
    Key? key,
    required this.day,
    required this.onTimeChanged, required this.startTime, required this.endTime,
  }) : super(key: key);

  @override
  State<WorkingHourWidget> createState() => _WorkingHourWidgetState();
}

class _WorkingHourWidgetState extends State<WorkingHourWidget> {
  
  TimeOfDay _startTime = TimeOfDay.now();
    TimeOfDay _endTime = TimeOfDay.now();

  _WorkingHourWidgetState();

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime ?? TimeOfDay.now();
    _endTime = widget.endTime ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.day,style: const TextStyle(fontWeight: FontWeight.w500), ),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker("Start Time", _startTime, (pickedTime) {
                setState(() {
                  _startTime = pickedTime;
                });
                widget.onTimeChanged(_startTime, _endTime);
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimePicker("End Time", _endTime, (pickedTime) {
                setState(() {
                  _endTime = pickedTime;
                });
                widget.onTimeChanged(_startTime, _endTime);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePicker(
      String label, TimeOfDay selectedTime, Function(TimeOfDay) onTimeChanged) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );

        if (pickedTime != null) {
          onTimeChanged(pickedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
           "$label: ${selectedTime.format(context)}",
           style: const TextStyle(fontSize: 16,),
          
        ),
      ),
    );
  }
}
