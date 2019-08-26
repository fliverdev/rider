import 'package:permission_handler/permission_handler.dart';

void requestPermissionsLocation() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
  print(permissions);
}

void requestPermissionsPhone() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.phone]);
  print(permissions);
}

void checkPermissions() async {
  PermissionStatus locationPermission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

  PermissionStatus phonePermission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);

  ServiceStatus serviceStatus =
      await PermissionHandler().checkServiceStatus(PermissionGroup.location);

  print(locationPermission);
  print(phonePermission);
  print(serviceStatus);
}
