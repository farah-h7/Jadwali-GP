
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class BLConnect{

  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  BluetoothDevice? device;
}
