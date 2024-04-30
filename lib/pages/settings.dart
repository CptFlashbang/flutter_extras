import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      );
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Settings"),
            ElevatedButton(
              onPressed: requestCameraPermission,
              child: const Text(
                "Request Camera Permission",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: requestMultiplePermissions,
              child: const Text(
                "Request Multiple Permissions",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: requestPermissionWithOpenSettings,
              child: const Text(
                "Open Permission Settings",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void requestCameraPermission() async {
    /// status can either be: granted, denied, restricted or permanentlyDenied
    var status = await Permission.camera.status;
    if (status.isGranted) {
      print("Camera Permission is already there");
    }
    else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.camera.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        print("Camera Permission is granted");
      }
    }

    // You can also directly ask the permission about its status.
    // if (await Permission.location.isRestricted) {
    //   // The OS restricts access, for example because of parental controls.
    // }
  }

  /// Request multiple permissions at once.
  /// In this case location & storage
  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,Permission.contacts
    ].request();
    print("location permission is requested: ${statuses[Permission.location]}, "
        "storage permission is requested: ${statuses[Permission.storage]}, "
        "contacts permission is requested: ${statuses[Permission.contacts]}");
  }

  /// The user opted to never again see the permission request dialog for this
  /// app. The only way to change the permission's status now is to let the
  /// user manually enable it in the system settings.
  void requestPermissionWithOpenSettings() async {
    //if (await Permission.speech.isPermanentlyDenied) {
      openAppSettings();
    //}
  }
}

