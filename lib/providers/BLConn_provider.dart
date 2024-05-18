import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BLConnProvider with ChangeNotifier {
  BluetoothConnection? connection;

  BluetoothDevice? device;
  bool get isConn =>
      connection != null &&
      connection!
          .isConnected; // isConnected is a property of the object BluetoothConnection

  set setConnection(BluetoothConnection c) {
    connection = c;
  }

  Future<void> saveDeviceInfo(BluetoothDevice device) async {
    // save device adress localy on device to use when reconnecting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_address', device.address);
    await prefs.setString(
        'device_name', device.name!); // Optional: depends on your use case
  }

  Future<void> clearDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('device_address');
    await prefs.remove('device_name');
  }

  Future<void> reconnectToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final String? deviceAddress = prefs.getString('device_address');
    final String? deviceName = prefs.getString('device_name'); // Optional: depends on your use case

    if (deviceAddress != null && !isConn) {
      int maxTries = 10;
      int currentTry = 0;

      while (currentTry < maxTries) {
        try {
          var connect = await BluetoothConnection.toAddress(deviceAddress);
          print('Reconnected to the device');

          connection = connect;

        // Optionally, you can create a BluetoothDevice object if needed for your UI or logic
        BluetoothDevice d = BluetoothDevice(address: deviceAddress, name: deviceName);

        device = d;
          break; // Exit the loop on successful connection
        } catch (e) {
          currentTry++;
          print('Attempt $currentTry failed: $e');
          if (currentTry >= maxTries) {
            print('Max connection attempts reached, failing...');
            break;
          }
        }
      }

      // try {
      //   var connection = await BluetoothConnection.toAddress(deviceAddress);
      //   print('Reconnected to the device');

      //   // Assuming you have a provider or similar state management in place
      //   this.connection = connection;

      //   // Optionally, you can create a BluetoothDevice object if needed for your UI or logic
      //   BluetoothDevice device = BluetoothDevice(address: deviceAddress, name: deviceName);

      //   this.device = device;

      // } catch (error) {
      //   print('Cannot reconnect, exception occurred: $error');
      // }
    }
  }

  Future<void> reconnectToDevice2() async {
    final prefs = await SharedPreferences.getInstance();
    final String? deviceAddress = prefs.getString('device_address');
    final String? deviceName = prefs.getString('device_name');

    if (deviceAddress != null) {
      try {
        // Attempt to connect to the saved device address
        await BluetoothConnection.toAddress(deviceAddress).then((connection) {
          print('Reconnected to the device');
          this.connection = connection;

          BluetoothDevice device =
              BluetoothDevice(address: deviceAddress, name: deviceName);

          this.device = device;
        }).catchError((error) {
          print('Cannot reconnect, exception occurred');
          print(error);
        });
      } catch (error) {
        print('Failed to reconnect: $error');
      }
    }
    return;
  }

// Future<void> reconnectToDevice() async {
//   final prefs = await SharedPreferences.getInstance();
//   final String? deviceAddress = prefs.getString('device_address');

//   if (deviceAddress != null) {
//     try {
//       // Attempt to connect to the saved device address
//       await BluetoothConnection.toAddress(deviceAddress).then((connection) {
//         print('Reconnected to the device');
//         Provider.of<BLConnProvider>(context, listen: false).connection = connection;
//         Provider.of<BLConnProvider>(context, listen: false).device = device; // Make sure you also save and retrieve the device object if needed
//         setState(() {});
//       }).catchError((error) {
//         print('Cannot reconnect, exception occurred');
//         print(error);
//       });
//     } catch (error) {
//       print('Failed to reconnect: $error');
//     }
//   }
// }
}

// set setIsConnecting(bool c){
//   isConnecting = c;
// }

// set setIsConnected(bool c) {
//   if (connection != null && connection!.isConnected) {
//     isConnected = true;
//   }

//isConnected = c;
//}
