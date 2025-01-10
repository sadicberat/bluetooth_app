import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import 'controllers/bluetooth_controller.dart';



class Baglinti extends StatelessWidget {
  const Baglinti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIBE Con.', style: TextStyle(color: Colors.green[900])),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'TR') {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
              } else if (result == 'EN') {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'TR',
                child: Text('Türkçe'),
              ),
              const PopupMenuItem<String>(
                value: 'EN',
                child: Text('English'),
              ),
            ],
            icon: Icon(Icons.language, color: Colors.green[900]),
          ),
        ],
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final ScanResult data = snapshot.data![index];

                            //print(data);

                            return Card(

                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black, width: 0.3),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              surfaceTintColor: Colors.green[200],
                              color: Colors.grey[200],
                              elevation: 2,
                              child: InkWell(
                                onTap: () async {

                                  await data.device.connect();
                                  //print(data.device.remoteId.toString());
                                },
                                child: ListTile(
                                  title: Text(data.device.platformName),
                                  subtitle: Text(data.device.remoteId.toString()),
                                  trailing: Text(data.rssi.toString()),
                                ),
                              ),
                            );

                          },
                        );
                      } else {
                        return const Center(child: Text("cihaz bulunamadı"));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    foregroundColor: Colors.white, backgroundColor: Colors.green,
                  ),
                  onPressed: () => controller.scanDevices(),
                  child: const Text("Cihazları Bul", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          );
        },
      ),
    );
  }
}