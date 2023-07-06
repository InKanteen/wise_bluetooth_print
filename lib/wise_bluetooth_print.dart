import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wise_bluetooth_print/classes/paired_device.dart';

class WiseBluetoothPrint {
  static const MethodChannel _channel = MethodChannel('wise_bluetooth_print');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<PairedDevice>> getPairedDevices() async {
    var ret = await _channel.invokeMethod('getPairedDevices');
    List<PairedDevice> devices = <PairedDevice>[];
    for (int i = 0; i < ret.length; i = i + 3) {
      devices.add(PairedDevice(
          index: i,
          name: ret[i] as String,
          hardwareAddress: ret[i + 1] as String,
          socketId: ret[i + 2] as String,
          food: false,
          drink: false,
          receipt: false));
    }
    return devices;
  }

  static Future<bool> print(String deviceUUID, String printText, int index,
      {Map? options, String? image}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'printText': printText,
      'image': image,
      'deviceUUID': deviceUUID,
      'timeout': options?['timeout'] ?? 100,
      'printIndex': index,
    };
    var ret = await _channel.invokeMethod('print', params);
    return ret;
  }
}
