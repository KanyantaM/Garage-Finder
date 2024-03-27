import 'package:flutter/material.dart';

class ErrorHandlingWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final void Function() onOK;

  const ErrorHandlingWidget({super.key, required this.snapshot, required this.onOK});

  @override
  Widget build(BuildContext context) {
    return snapshot.hasError
        ? _buildErrorWidget(context)
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(BuildContext context) {
    String errorMessage = snapshot.error.toString();

    if (errorMessage == 'Location services are disabled.') {
      return _buildLocationServicesDisabledDialog(context);
    } else if (errorMessage == 'Location permissions are denied') {
      return _buildLocationPermissionsDeniedDialog(context);
    } else if (errorMessage ==
        'Location permissions are permanently denied, we cannot request permissions.') {
      return _buildPermanentlyDeniedDialog(context);
    } else {
      return Center(child: Text('Error: $errorMessage'));
    }
  }

  Widget _buildLocationServicesDisabledDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Services Disabled'),
      content: const Text('Please enable location services to use this feature.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Navigator.pop(context);
            onOK();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildLocationPermissionsDeniedDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Permissions Denied'),
      content: const Text('Please grant location permissions to use this feature.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Navigator.pop(context);
            onOK();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildPermanentlyDeniedDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Permissions Permanently Denied'),
      content: const Text(
          'Location permissions are permanently denied. You need to go to app settings and enable permissions manually.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Navigator.pop(context);
            onOK();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// Example usage:
// ErrorHandlingWidget(snapshot: snapshot),
