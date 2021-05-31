
import 'package:flutter_bluetooth_printer/controller/printer_controller.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future openDialog(BuildContext _context, PrinterBluetoothManager printerManager, List<PrinterBluetooth> _devices) async {
  return showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_) => CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Text("Select the printing device"),
          SizedBox(height: 15.0,),
        ],
      ),
      content: _setupDialogContainer(_context, _devices),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(_context).pop();
          },
        )
      ],
    )
  );
}

Widget _setupDialogContainer(BuildContext _context, List<PrinterBluetooth> _devices){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 200.0,
        width: 300.0,
        child: ListView.builder(

          shrinkWrap: true,
          itemCount: _devices.length,
          itemBuilder: (BuildContext _context, int index) {
            return GestureDetector(
              onTap: () {
                PrinterController().runPrint(_devices[index]);
                // This snackBar is optional, you can use a toast or some progress indicator widget.
                
                //Este snackBar es opcional, se puede usar un toast o algún widget indicador de progreso.
                _printSnackBar(_context);
                Navigator.of(_context).pop();
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.print),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_devices[index].name ?? ''),
                              Text(_devices[index].address),
                              Text(
                                'Click to print a test receipt',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      )
    ]
  );
}

_printSnackBar(BuildContext _context){
  final snackBar = SnackBar(
    content: Text('Printing on process...'),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        
      },
    ),
  );
  ScaffoldMessenger.of(_context).showSnackBar(snackBar);
}