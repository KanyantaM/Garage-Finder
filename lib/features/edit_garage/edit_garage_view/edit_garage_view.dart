import 'package:fixtex/features/edit_garage/create_garage_bloc/edit_garage_bloc.dart';
import 'package:fixtex/screens/main_scaffold.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/location_widget.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

class EditGarageView extends StatefulWidget {
  final bool isSignUp;
  final Garage garage;

  const EditGarageView(
      {super.key, required this.isSignUp, required this.garage});

  @override
  State<EditGarageView> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<EditGarageView> {
  bool canEdit = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDurationController =
      TextEditingController();

  Map<String, double> _services = <String, double>{};
  double latitude = 51.5;
  double longitude = 0.1;

  int? _serviceToEdit;

  @override
  void initState() {
    canEdit = widget.isSignUp ? true : false;
    _nameController.text = widget.garage.name;
    _addressController.text = widget.garage.address;
    _bioController.text = widget.garage.bio;
    latitude = widget.garage.lat;
    longitude = widget.garage.lng;
    _services = widget.garage.services;
    super.initState();
  }

  void _selectServiceToEdit(int selection) {
    setState(() {
      _serviceToEdit = selection;
    });
  }

  @override
Widget build(BuildContext context) {
  return BlocListener<EditGarageBloc, EditGarageState>(
    listener: (BuildContext context, EditGarageState state) {
      if (state is UpdatingState) {
        // Display a loading indicator or progress bar
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Updating...'),
              content: CircularProgressIndicator(),
            );
          },
        );
      }
      if (state is UpdatedState) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (state is ErrorState) {
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _viewBody(context),
      ),
    ),
  );
}


  ListView _viewBody(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            if (!widget.isSignUp)
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            canEdit = !canEdit;
                          });
                        },
                        child: RectangleTopRight(
                            text: canEdit ? 'Revert' : 'Edit')),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const ProfileImage(),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldText(textFieldType: 'Name'),
                CustomTextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  enabled: canEdit,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'Address'),
                CustomTextField(
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  enabled: canEdit,
                ),
                _selectLocationWidget(),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'contact'),
                CustomTextField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  enabled: canEdit,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'Bio'),
                CustomTextField(
                  controller: _nameController,
                  keyboardType: TextInputType.multiline,
                  enabled: canEdit,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildServicesList(_services),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Sign up button
        if (canEdit || widget.isSignUp)
          InkWell(
              onTap: () {
                if (widget.isSignUp) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
                  );
                } else {
                  context.read<EditGarageBloc>().add(SaveGarage(
                          garage: widget.garage.copyWith(
                        name: _nameController.text,
                        address: _addressController.text,
                        services: _services,
                      )));
                }
              },
              child: RectangleMain(
                type: widget.isSignUp ? 'Sign up' : 'Delete',
              )),
        if (!widget.isSignUp)
          InkWell(
              onTap: () {
                context
                    .read<EditGarageBloc>()
                    .add(DeleteGarage(garageID: widget.garage.id));
              },
              child: const RectangleMain(
                type: 'Delete',
              )),
      ],
    );
  }

  Column _buildServicesList(Map<String, double> servicesList) {
    return Column(children: [
      const TextFieldText(textFieldType: 'Services'),
      for (int i = 0; i < servicesList.length; i++)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const TextFieldText(textFieldType: 'Name:'),
                CustomTextField(
                  controller:
                      (_serviceToEdit == i) ? _serviceNameController : null,
                  keyboardType: TextInputType.name,
                  enabled: canEdit,
                ),
              ],
            ),
            Column(
              children: [
                const TextFieldText(textFieldType: 'Duration (min):'),
                CustomTextField(
                  controller: _serviceDurationController,
                  keyboardType: TextInputType.number,
                  enabled: canEdit,
                ),
              ],
            ),
            if (_serviceToEdit != i)
              IconButton(
                  onPressed: () {
                    _selectServiceToEdit(i);
                  },
                  icon: const Icon(Icons.edit)),
            if (_serviceToEdit == i)
              IconButton(
                  onPressed: () {
                    setState(() {
                      _services.remove(servicesList.keys.toList()[i]);
                    });
                  },
                  icon: const Icon(Icons.delete)),
          ],
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const TextFieldText(textFieldType: 'Name:'),
              CustomTextField(
                controller: _serviceNameController,
                keyboardType: TextInputType.name,
                enabled: canEdit,
              ),
            ],
          ),
          Column(
            children: [
              const TextFieldText(textFieldType: 'Duration (min):'),
              CustomTextField(
                controller: _serviceDurationController,
                keyboardType: TextInputType.number,
                enabled: canEdit,
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  Map<String, double> newEntrie = <String, double>{
                    _serviceNameController.text:
                        _serviceDurationController as double
                  };
                  _services.addEntries(newEntrie.entries);
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
    ]);
  }

  Column _selectLocationWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const TextFieldText(textFieldType: 'Location'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
              child: LocationWidget(
            onTap: ((lat, long, address) {
              widget.garage.copyWith(lat: lat, lng: long, address: address);
              setState(() {
                latitude = lat;
                longitude = long;
                _addressController.text = address ?? _addressController.text;
              });
            }),
            garage: widget.garage,
          )),
        ),
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 344,
          height: 82,
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: NetworkImage("https://via.placeholder.com/344x82"),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
