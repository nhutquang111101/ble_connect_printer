import 'package:ble_connect/bluetooth_page.dart';
import 'package:flutter/material.dart';
class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {

  final List<Map<String, dynamic>> data  = [
    {
      'name': 'Sản phẩm 1',
      'price': '10.000',
      'Qty': '10',
    },
    {
      'name': 'Sản phẩm 2',
      'price': '30.000',
      'Qty': '2',
    },
    {
      'name': 'Sản phẩm 3',
      'price': '40.000',
      'Qty': '4',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child:
            ListView.builder(
              itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${data[index]['name']}'),
                    subtitle: Text('${data[index]['Qty']} cai'),
                    trailing: Text('${data[index]['price']} VND'),
                  );
                },
            ),
          ),
          Container(
            child: Row(
              children: [
                Column(
                  children: [
                    Text('Tong: 200 ngan'),
                  ],
                ),
                SizedBox(width: 16,),
                Expanded(
                    child: ElevatedButton(
                      child: Text('In'),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>BluetoothPage(data: data,)));
                      },
                    ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
