import 'package:country_code_picker/country_code_picker.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/garage_owner/edit_garage/create_garage_bloc/edit_garage_bloc.dart';
import 'package:fixtex/screens/garage_owner/garage_bottom_nav.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/location_widget.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/profile_image.dart';
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

  Map<String, double> _services = <String, double>{};
  double latitude = 51.5;
  double longitude = 0.1;
  String _countryCode = '';
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = false;
    canEdit = widget.isSignUp ? true : false;
    if (widget.garage.phone.length >=4) {
  _contactController.text = widget.garage.phone.substring(
    4,
  );
  _countryCode = widget.garage.phone.substring(0, 4);
}
    _nameController.text = widget.garage.name;
    _addressController.text = widget.garage.address;
    _bioController.text = widget.garage.bio;
    latitude = widget.garage.lat;
    longitude = widget.garage.lng;
    _services = widget.garage.services;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditGarageBloc, EditGarageState>(
      listener: (BuildContext context, EditGarageState state) {
        if (state is UpdatingState) {
          // Display a loading indicator or progress bar
          setState(() {
            
          _isLoading = true;
          });
          if (_isLoading) {
            showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Updating...'),
                content: Center(child: CircularProgressIndicator()),
              );
            },
          );
          }
          
        }
        if (state is UpdatedState) {
          // Show a success message
          setState(() {
            
          _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            canEdit = false;
          });
        }
        if (state is ErrorState) {
          // Display an error message
          setState(() {
            
          _isLoading = false;
          });
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
                    RectangleTopRight(
                      text: canEdit ? 'Revert' : 'Edit',
                      onTap: () {
                        setState(() {
                          canEdit = !canEdit;
                        });
                      },
                    ),
                  ],
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
              height: 30,
            ),
            
            const TextFieldText(textFieldType: 'Photo'),
            const SizedBox(
              height: 20,
            ),
            ProfileImage(isGarage: false,
            networkImage: widget.garage.imageUrl),
            const SizedBox(
              height: 20,
            ),
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
                const SizedBox(
                  height: 5,
                ),
                _buildRacetrackButtonImages(null, Icons.location_on, () {
                  // Handle the 'Next' button press
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: LocationWidget(
                            onTap: ((lat, long, address) {
                              widget.garage.copyWith(
                                  lat: lat, lng: long, address: address);
                              setState(() {
                                latitude = lat;
                                longitude = long;
                                _addressController.text =
                                    address ?? _addressController.text;
                              });
                            }),
                            garage: widget.garage,
                          ),
                        );
                      });
                }, Colors.blue),
                // _selectLocationWidget(),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'contact'),
                CustomTextField(
                  prefixIcon: CountryCodePicker(
                    onChanged: (value) =>
                        _countryCode = value.dialCode ?? _countryCode,
                    initialSelection: _countryCode,
                  ),
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  enabled: canEdit,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'Bio'),
                CustomTextField(
                  controller: _bioController,
                  keyboardType: TextInputType.multiline,
                  enabled: canEdit,
                  maxLines: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'Services'),
                _buildServicesWithPrices(),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Sign up button
        if (canEdit || widget.isSignUp)
          RectangleMain(
            type: widget.isSignUp ? 'Sign up' : 'Save',
            onTap: () {
              if (widget.isSignUp) {
                Garage newGarage = widget.garage.copyWith(
                    name: _nameController.text,
                    address: _addressController.text,
                    services: _services,
                    phone: _countryCode + _contactController.text);
                context
                    .read<EditGarageBloc>()
                    .add(SaveGarage(garage: newGarage));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GarageBottomNav(garage: newGarage)),
                );
              } else {
                context.read<EditGarageBloc>().add(SaveGarage(
                    garage: widget.garage.copyWith(
                        name: _nameController.text,
                        address: _addressController.text,
                        services: _services,
                        phone: _countryCode + _contactController.text)));
              }
            },
          ),
        // if (!widget.isSignUp)
        //   RectangleMain(
        //     type: 'Delete',
        //     onTap: () {
        //       context
        //           .read<EditGarageBloc>()
        //           .add(DeleteGarage(garageID: widget.garage.id));
        //     },
        //   ),
      ],
    );
  }

  Widget _buildServicesWithPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canEdit) _buildServiceInput(),
        const SizedBox(height: 8),
        _buildAddedServices(),
      ],
    );
  }

  Widget _buildServiceInput() {
    String serviceName = '';
    double servicePrice = 0.0;

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          const Divider(),
          Expanded(
            child: CustomTextField(
              enabled: canEdit,
              controller: TextEditingController(text: serviceName),
              hintText: canEdit ? "Service Name" : null,
              onChanged: (value) {
                serviceName = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomTextField(
              enabled: canEdit,
              controller: TextEditingController(),
              hintText: canEdit ? "Duration (mins)" : null,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                servicePrice = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (serviceName.isNotEmpty && servicePrice != 0) {
                    _services[serviceName] =
                        servicePrice + 0.0009; //ensures a double is stored.
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kmainBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddedServices() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: _services.entries.map((entry) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 22.5),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${entry.value.toStringAsFixed(1)} mins',
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
            const SizedBox(
              height: 10,
            ),
            if (canEdit)
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _services.remove(entry.key);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRacetrackButtonImages(
      String? label, IconData? icon, VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: icon != null
            ? Icon(
                icon,
                color: kmainBlue,
              )
            : Text(label!),
      ),
    );
  }
}
