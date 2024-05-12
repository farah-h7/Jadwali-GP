import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BLConnProvider with ChangeNotifier {
  BluetoothConnection? connection;

  BluetoothDevice? device;
  bool get isConn => connection != null && connection!.isConnected;// isConnected is a property of the object BluetoothConnection

  set setConnection(BluetoothConnection c) {
    connection = c;
  }

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