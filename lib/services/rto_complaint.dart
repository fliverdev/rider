import 'package:call_number/call_number.dart';
import 'package:rider/utils/permission_helper.dart';

void callRto() {
  final String rtoNumber = "1800220110";
  requestPermissionsPhone();
  CallNumber().callNumber(rtoNumber);
}
