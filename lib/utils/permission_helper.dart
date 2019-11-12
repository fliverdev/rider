import 'package:permission_handler/permission_handler.dart';
import 'package:rider/utils/variables.dart';

Future<Map<PermissionGroup, PermissionStatus>>
    requestLocationPermission() async {
  Map<PermissionGroup, PermissionStatus> locationPermission =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
  return locationPermission;
} // return is needed for await (future stuff)

Future<bool> checkLocationPermission() async {
  PermissionStatus permissionStatus =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

  permissionStatus == PermissionStatus.granted
      ? isPermissionGranted = true
      : isPermissionGranted = false;

  print('Location permission status: $isPermissionGranted');
  return isPermissionGranted;
} // tells whether location access is granted or denied
