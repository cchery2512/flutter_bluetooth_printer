import 'package:flutter_bluetooth_printer/view/dialogs.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();
    // This function initializes listening for changes when scanning nearby devices.

    // Esta función inicializa la escucha de cambios al escanear los dispositivos cercanos.
    _printerManager.scanResults.listen((devices) async {
      setState(() {
        _devices = devices;
      });
    });
    _startScanDevices();
  }

  // This function starts the scanning of nearby devices when it is executed intentionally, the duration of this process can also be defined.

  // Esta función inicia el escaneo de dispositivos cercanos al ser ejecutada intencionalmente, también se puede definir el tiempo de duración de este proceso.
  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    _printerManager.startScan(Duration(seconds: 4));
  }

  // This function stops the device scanning process previously triggered by the _startScanDevices function regardless of the fact that the scanning process is not finished yet.

  // Esta función detiene el proceso de escaneo de dispositivos previamente activado por la función _startScanDevices sin importar que el proceso de escaneo aún no hay terminado.
  void _stopScanDevices() {
    _printerManager.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            // In this widget it is detected if devices are being scanned, if so, it shows a STOP icon which when pressed executes the '_stopScanDevices' function, otherwise a search icon is displayed that if pressed will execute the function' _startScanDevices '

            // En este widget se detecta si se están escaneando dispositivos, de ser así muestra un ícono de STOP el cual al ser presionado ejecuta la función '_stopScanDevices' de lo contrario se mostrará un ícono de búsqueda que de ser presionado ejecutará la función '_startScanDevices'
            child: StreamBuilder<bool>(
              stream: _printerManager.isScanningStream,
              initialData: false,
              builder: (c, snapshot) {
                if (snapshot.data) {
                  return GestureDetector(
                    child: Icon(Icons.stop, color:  Colors.red,),
                    onTap: _stopScanDevices,
                  );
                }else{
                  return GestureDetector(
                    child: Icon(Icons.search),
                    onTap: _startScanDevices,
                  );
                }
              },
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<bool>(
          stream: _printerManager.isScanningStream,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(  
                    animating: true, radius: 15
                  ),
                  SizedBox(height: 5.0,),
                  Text('Escaneando dispositivos cercanos')
                ],
              );
            } else {
              return Center(
                child: Container(
                  child: ClipOval(
                    child: Material(
                      color: Colors.lightBlue,
                      child: InkWell(
                        child: SizedBox(width: 60, height: 60, child: Icon(Icons.print, color: Colors.white, size: 40,)),
                        onTap: () {
                          openDialog(context, _printerManager, _devices);
                        },
                      ),
                    ),
                  )
                ),
              );
            }
          },
        ),
      ),
    );
  }

}
