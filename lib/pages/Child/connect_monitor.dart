import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jadwali_test_1/providers/BLConn_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectMonitor extends StatefulWidget {
  const ConnectMonitor({super.key});

  @override
  State<ConnectMonitor> createState() => _ConnectMonitorState();
}

class _ConnectMonitorState extends State<ConnectMonitor> {
  List<BluetoothDiscoveryResult> devicesList = [];

  String msg = "searching for devices";

  @override
  void initState() {
    super.initState();
    if( !Provider.of<BLConnProvider>(context, listen: false).isConn){
    handlePermissions();}
  }

/////phone permission handelling methods
  void handlePermissions() async {
    if (Platform.isAndroid) {
      var deviceInfo = DeviceInfoPlugin();
      var androidInfo = await deviceInfo.androidInfo;
      var version = androidInfo.version;
      var sdkInt = version.sdkInt; // SDK number as an integer
      if (sdkInt != null && sdkInt >= 31) {
        // Request Android 12 specific permissions
        await requestBluetoothPermissions();
      } else {
        // Request permissions for older Android versions
        await requestLegacyPermissions();
      }
      startDiscovery();
    }
  }

  Future<void> requestBluetoothPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  Future<void> requestLegacyPermissions() async {
    await [
      Permission.location,
    ].request();
  }

//////bluetooth connection methods
  void startDiscovery() {
    setState(() {
      msg = "searching for devices";
    });
    FlutterBluetoothSerial.instance.requestEnable().then((_) {
      FlutterBluetoothSerial.instance.startDiscovery().listen(
        (r) {
          setState(() {
            // if (r.device.name!.contains("pulse monitor")){}
            devicesList.add(r);
          });
        },
        onError: (error) {
          print('Error occurred during discovery: $error');
        },
        onDone: () {
          print('Discovery completed');
        },
      );
    }).catchError((error) {
      print('Error enabling Bluetooth: $error');
    });

    if (devicesList.isEmpty) {
      setState(() {
        msg = "no devices found";
      });
    }
  }

  Future<void> refreshDevices() async {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    setState(() {
      devicesList.clear();
    });
    handlePermissions();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    FlutterBluetoothSerial.instance.cancelDiscovery();

    EasyLoading.show(status: "connecting watchالرجاء الإنتظار");

    if (!Provider.of<BLConnProvider>(context, listen: false).isConn) {
      await BluetoothConnection.toAddress(device.address).then((connection) {
        print('Connected to the device');
        //save connection
        Provider.of<BLConnProvider>(context, listen: false).connection =
            connection;
        Provider.of<BLConnProvider>(context, listen: false).device = device;
        Provider.of<BLConnProvider>(context, listen: false).saveDeviceInfo(device);
        setState(() {});

        EasyLoading.dismiss();
        showMSG(context, "bracelet connected");
      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
        EasyLoading.dismiss();
        showMSG(context, "connection failed");
      });
    } else {
      EasyLoading.dismiss();
      showMSG(context, "device already connected");
    }
  }

 Future<void> disconnectDevice() async {
  // Get the current Bluetooth connection from the provider
  var provider = Provider.of<BLConnProvider>(context, listen: false);

    provider.clearDeviceInfo();

  if (provider.isConn && provider.connection != null) {
    try { 
      
       provider.connection!.close();

      // Close the Bluetooth connection
      
      print('Device disconnected');

      // Clear the connection and device information in the provider
      provider.connection = null;
      provider.device = null;

      // Update the UI if necessary
      setState(() {});

      EasyLoading.showSuccess('Device disconnected successfully');
    } catch (error) {
      print('Error disconnecting device: $error');
      EasyLoading.showError('Failed to disconnect');
    }
  } else {
    print('No device connected');
    EasyLoading.showInfo('No device to disconnect');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
        actions: [
          IconButton(
            onPressed: refreshDevices,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Provider.of<BLConnProvider>(context, listen: false).isConn
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("device is connected"),
                  const SizedBox(height: 5),
                  Text(
                      "device name: ${Provider.of<BLConnProvider>(context, listen: false).device?.name}"),
                      const SizedBox(height: 5),
                      TextButton(onPressed:(){setState(() {
                      disconnectDevice();  
                      }); }, child: const Text("disconnect device"))
                ],
              ),
            )
          : Center(
              child: devicesList.isEmpty
                  ? Center(child: Text(msg))
                  : ListView.builder(
                      itemCount: devicesList.length,
                      itemBuilder: (context, index) {
                        BluetoothDiscoveryResult result = devicesList[index];
                        return ListTile(
                          leading: const Icon(Icons.bluetooth),
                          title: Text(result.device.name ?? "Unknown Device"),
                          subtitle: Text(result.device.address),
                          onTap: () {
                            connectToDevice(result.device);
                          },
                        );
                      },
                    ),
            ),
    );
  }
}

/*children: [
          Row(children: [
            const Text("Device List:"),
            IconButton(onPressed: ()=> startDiscovery(), icon: const Icon(Icons.refresh_rounded))

          ],), */

showMSG(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
