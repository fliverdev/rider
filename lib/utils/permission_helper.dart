import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
}

//void checkLocationPermission() async {
//  PermissionStatus locationPermission =
//      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
//  ServiceStatus locationService =
//      await PermissionHandler().checkServiceStatus(PermissionGroup.location);
//
//  if (locationPermission == PermissionStatus.granted) {
//    print('Permission granted');
//  } else {
//    print('Permission denied');
//  }
//}
