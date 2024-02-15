
import 'package:permission_handler/permission_handler.dart';

bool permissionsAccepted =false;

checkPermission() async {
 Map<Permission, PermissionStatus> statuses = await [
  Permission.storage,
  Permission.ignoreBatteryOptimizations,
 ].request();
 if (statuses[Permission.storage]!.isGranted &&
     statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
   //Accepted Permission
  permissionsAccepted =true;
 }
 if(statuses[Permission.storage]!.isDenied &&
     statuses[Permission.ignoreBatteryOptimizations]!.isDenied){
  permissionsAccepted = false;
  await checkPermission();
 }
 else
 {
  permissionsAccepted = false;
    await checkPermission();
 }
 
} 