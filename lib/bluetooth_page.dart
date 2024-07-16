import 'package:flutter_esc_pos_bluetooth/flutter_esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

class BluetoothPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const BluetoothPage({super.key,required this.data});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {


  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

  List<PrinterBluetooth> _device = [];
  String  _deviceMsg='';

  // BluetoothManager bluetoothManager = BluetoothManager.instance;


  @override
  void initState() {
    // TODO: implement initState
    initPrinter();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _device.isEmpty ? Center(child: Text(_deviceMsg ?? ''),)
          :
          ListView.builder(
            itemCount: _device.length,
              itemBuilder:(context, index) {
                return ListTile(
                    title: Text(_device[index].name ?? ''),
                  subtitle: Text(_device[index].address ?? ''),
                  onTap: (){
                    _startPrint(_device[index]);
                  },
                );
              },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          initPrinter();
        },
      ),
    );
  }



  ///Function  Printer
  void initPrinter (){
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((result) {
      print(result);
      if(!mounted) return;
      setState(()=>_device= result);
      print(_device);
      if(_deviceMsg == '')
      setState(()=>_deviceMsg= 'NO DEVICE ');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket());
    // print(result);
  }

  // Future<Ticket> _ticket(PaperSize paper) async {
  //   final ticket  = Ticket(paper);
  //
  //   ticket.text('Hello quanghn');
  //
  //   ticket.cut();
  //   return ticket;
  // }

  Future<List<int>> _ticket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }



}
