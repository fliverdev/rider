import 'package:permission_handler/permission_handler.dart';

Future<Map<PermissionGroup, PermissionStatus>>
    requestLocationPermission() async {
  Map<PermissionGroup, PermissionStatus> locationPermission =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
  return locationPermission;
} // return is needed for await (future stuff)

Future<bool> checkLocationPermission() async {
  bool isPermissionGranted = false;
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

  permissionStatus == PermissionStatus.granted
      ? isPermissionGranted = true
      : isPermissionGranted = false;

  print('Location permission status: $isPermissionGranted');
  return isPermissionGranted;
} // tells whether location access is granted or denied
