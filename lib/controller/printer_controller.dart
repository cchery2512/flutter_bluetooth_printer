import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

class PrinterController {
    PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

    Future<Ticket> _demoPrint(PaperSize paper) async {
    final Ticket ticket = Ticket(paper);
    // Example of print of an image
    // Ejemplo de impresión de una imagen
    final ByteData data = await rootBundle.load('assets/logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);

    // Print QR Code using native function
    ticket.qrcode(
      'https://www.linkedin.com/in/cchery2512/',
      size: QRSize.Size7,
    );
    ticket.text(
      'CCHERY MARKET',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1
    );
    ticket.text('889  Watson Lane', styles: PosStyles(align: PosAlign.center));
    ticket.text('New Braunfels, TX', styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: +507 ####-####', styles: PosStyles(align: PosAlign.center));
    ticket.text('Web: https://www.linkedin.com/in/cchery2512/',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    ticket.hr();
    ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: '2', width: 1),
      PosColumn(text: 'ONION RINGS', width: 7),
      PosColumn(
          text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(
          text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.hr();

    ticket.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: '\$10.97',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    ticket.hr(ch: '=', linesAfter: 1);

    ticket.row([
      PosColumn(
          text: 'Cash',
          width: 7,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: '\$15.00',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    ticket.row([
      PosColumn(
          text: 'Change',
          width: 7,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: '\$4.03',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    ticket.feed(2);
    ticket.text('Thanks, come back soon!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    ticket.text(timestamp,
      styles: PosStyles(align: PosAlign.center), linesAfter: 0
    );

    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  void runPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);

    // Then we define the size of the paper to be printed on (58mm or 80mm), this step is mandatory, otherwise it could generate printing errors.
    // Definimos el tamaño del papel en el que se va a imprimir (58mm o 80mm), este paso es obligatorio, de lo contrario podría generar errores de impresión.
    const PaperSize paper = PaperSize.mm58;

    // DEMO PRINT
    final PosPrintResult res = await _printerManager.printTicket(await _demoPrint(paper));
    if(res.msg != 'Success'){
      showToast(res.msg);
    }
  }

}