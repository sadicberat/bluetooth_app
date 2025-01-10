import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBluePlus ble = FlutterBluePlus();

  @override
  void onInit() {
    super.onInit();
    requestMultiplePermissions();
  }

  Future<void> requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted) {
      print("Bluetooth verildi.");
    }
    if (statuses[Permission.bluetoothConnect]!.isGranted) {
      print("Bluetooth Connect verildi.");
    }
    if (statuses[Permission.location]!.isGranted) {
      print("Location verildi.");
    }

  }



  Future<void> scanDevices() async {
    if (await _isBluetoothOn()) {
      if (await Permission.bluetoothScan.isGranted &&
          await Permission.bluetoothConnect.isGranted &&
          await Permission.location.isGranted) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 20));
        await Future.delayed(const Duration(seconds: 20));
        //FlutterBluePlus.stopScan();
      } else {
        print("Gerekli izinler verilmedi.3");
      }
    } else {
      print("Bluetooth kapalı. Lütfen Bluetooth'u açın.");
      createPoopUp("Bluetooth kapalı. Lütfen Bluetooth'u açın.");
    }
  }

  Future<bool> _isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  void createPoopUp(String s) {
    Get.defaultDialog(
      title: "Uyarı",
      middleText: s,
      textConfirm: "Tamam",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      },
    );
  }
}