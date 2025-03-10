import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sls_mvp_microsoft/constants.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_container.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_loading_indicator.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_statistics.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/Map/mapLeaflet_view.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/Map/mapleaftlet_vehicle_view.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/Thermometer/thermo_view.dart';
import 'package:sls_mvp_microsoft/features/home/view_model/vehicles/vehicles_cubit.dart';

import 'package:sls_mvp_microsoft/features/monitoring/widgets/fuel_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MonitorViewBody extends StatelessWidget {
  final String name;
  final String vehicleID;
  final String temp;

  const MonitorViewBody({
    Key? key,
    required this.name,
    required this.vehicleID,
    required this.temp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // int col = int.parse(ignite);
    Future<String?>? cachedFileFuture;
    final cache = DefaultCacheManager();
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
            child: BlocBuilder<VehiclesCubit, VehiclesState>(
              builder: (context, state) {
                if (state is VehichlesGetLoading) {
                  return const CustomLoadingIndicator();
                } else if (state is VehiclesGetSuccess) {
                  Color scolor = Colors.grey;
                  Color mcolor = Colors.grey;

                  Map<String, dynamic> carFireStore =
                      BlocProvider.of<VehiclesCubit>(context)
                          .carParsed[int.parse(vehicleID)];
                  Map<String, dynamic> carFirebaseRealtime =
                      BlocProvider.of<VehiclesCubit>(context)
                          .carParsedrealtime[int.parse(vehicleID)];

                  Future<String> addFileProtocol(String path) async {
                    try {
                      if (path.isEmpty || path == null) {
                        throw ArgumentError(
                            'Invalid path provided: path cannot be empty or null.');
                      }

                      if (!path.startsWith('file://')) {
                        final updatedPath = 'file://' + path;
                        print('File protocol added: $updatedPath');

                        return updatedPath;
                      } else {
                        print('File protocol already present: $path');
                      }
                    } catch (error) {
                      print('Error adding file protocol: $error');
                    }
                    return 'didnt return from if conditions';
                  }

                  Future<String> cachingFilePath() async {
                    print('iam in ');
                    // final String downloadUrl = 'https://modelviewer.dev/shared-assets/models/Astronaut.glb';
                    final String downloadUrl =
                        carFireStore['vehicle_3d_model_url'];

                    final String key = Uri.parse(downloadUrl).pathSegments.last;

                    final cachedFile =
                        await cache.getSingleFile(downloadUrl, key: key);
                    if (cachedFile != null && cachedFile.existsSync()) {
                      print('iam in twice');
                      print('File already cached: ${cachedFile.path}');
                    }
                    // await changeFileExtension(cachedFile, 'glb');
                    final String updatedpath =
                        await addFileProtocol(cachedFile.path);

                    print('File path there : ${cachedFile.path}');
                    print('File path there : ${updatedpath}');

                    return updatedpath;
                    // return cachedFile.path;
                  }
// Future<String> downloadGLB(String url) async {
//   final dio = Dio();
//   final response = await dio.get(url);

//   if (response.statusCode == 200) {
//         print('thsidfffffffffffffffffffffffffffffffffwe4terterre');

//     final data = response.data is String ? response.data : utf8.decode(response.data);
//     print('thsidfffffffffffffffffffffffffffffffffwe4terterre');
//     print(data);
//     return data;
//   } else {
//     throw Exception('Failed to download GLB file: ${response.statusCode}');
//   }
// }

// Future<File> downloadFile(String url, String customName) async {
//   final file = await DefaultCacheManager().getSingleFile(url, key: customName);
//   return file;
// }

// Future<Stream<FileResponse>?> getCachedFile(String customName) async {
//   try {
//     final file =  DefaultCacheManager().getFileStream(customName);
//     return file;
//   }  catch (e) {
//     print('this is the error of caching $e');
//     // if (CacheExceptionType.fileNotFound == e.type) {
//     //   // Handle the case where the file is not cached
//     //   return null;
//     // } else {
//     //   // Re-throw other exceptions
//     //   rethrow;
//     // }
//       return null;

//   }
// }
                  Future<String> downloadFile(
                      String url, String customName) async {
                    String filePath = '';

                    File file = await DefaultCacheManager().getSingleFile(url);

                    filePath = file.path;

                    print('this is file path incase of not cached $filePath');

                    return filePath;
                  }

                  if (carFirebaseRealtime['sleep'] != null) {
                    scolor = carFirebaseRealtime['sleep']
                        ? Colors.red
                        : Colors.green;
                  } else {
                    // Set a default color or handle the null case here
                    Color scolor = Colors.grey; // Example default color
                  }
                  if (carFirebaseRealtime['ignition'] != null) {
                    mcolor = carFirebaseRealtime['ignition']
                        ? Colors.green
                        : Colors.red;
                  } else {
                    // Set a default color or handle the null case here
                    Color mcolor = Colors.grey; // Example default color
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('Name: $name'),
                      // Icon(
                      //   Icons.power_settings_new,
                      //   color: Color(col),
                      // ),

                      const SizedBox(
                        height: 20,
                      ),
                      //~3D Model Viewer
                      // todo: This code for the cache in future update
                      // CustomContainer(
                      //   width: 500,
                      //   height: 380,
                      //   child: FutureBuilder<String>(
                      //     future: downloadFile(vehicle['vehicle_3d_model_url'],
                      //         vehicle['id']), // Pass the URL and custom name
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return Center(child: CircularProgressIndicator());
                      //       } else if (snapshot.hasError) {
                      //         return Center(
                      //             child: Text('Error: ${snapshot.error}'));
                      //       } else {
                      //         final String? filePath = snapshot.data;
                      //         print(
                      //             'this is the file path at the widget $filePath');
                      //         return ModelViewer(
                      //           backgroundColor: Colors.white,
                      //           src: filePath!, // Use the file path here
                      //           alt: '3d car model',
                      //           ar: true,
                      //           autoRotate: true,
                      //           disableZoom: true,
                      //         );
                      //       }
                      //     },
                      //   ),
                      // ),
                      // CustomContainer(
                      //   width: 500,
                      //   height: 380,
                      //   child: ModelViewer(
                      //     backgroundColor: Colors.white,
                      //     src: carFireStore['vehicle_3d_model_url'],
                      //     alt: '3d car model',
                      //     ar: true,
                      //     autoRotate: true,
                      //     disableZoom: true,
                      //   ),
                      // ),

                      CustomContainer(
                        width: 500,
                        height: 380,
                        child: FutureBuilder<String?>(
                          future: cachingFilePath(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final file = snapshot.data!;
                              String model = snapshot.data!;
                              // return Image.file(file);
                              return SizedBox(
                                width: 200,
                                height: 100,
                                child: ModelViewer(
                                  backgroundColor: Colors.white,
                                  src: model,
                                  alt: '3d car model',
                                  ar: true,
                                  autoRotate: true,
                                  disableZoom: true,
                                ),
                              );
                              // return Text('sdfds');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const CustomLoadingIndicator();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //~Unity View
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Align(
                          // alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor),
                              onPressed: () {
                                context.pushNamed('ar', pathParameters: {
                                  'vehicleId': vehicleID,
                                });
                              },
                              child: const Text('View in AR',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //~Show data
                      //~Statistics
                      CustomContainer(
                        width: 500,
                        height: 380,
                        child: Statistics(
                          title: 'Speed',
                          varcache: carFirebaseRealtime['speed'],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomContainer(
                              width: 400,
                              height: 250,
                              child: SpeedGauge(
                                speed: carFirebaseRealtime['speed'],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: CustomContainer(
                              width: 400,
                              height: 250,
                              child: RpmGauge(
                                rpm: carFirebaseRealtime['rpm'],
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomContainer(
                        width: 500,
                        height: 380,
                        child:
                            MapLeafletViewVehicle(index: int.parse(vehicleID)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomContainer(
                          width: 200,
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                color: scolor,
                                size: 100,
                              ),
                              Icon(
                                carFirebaseRealtime['sleep']
                                    ? Icons.warning
                                    : Icons.energy_savings_leaf,
                                color: Colors.black,
                                size: 40,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomContainer(
                          width: 340,
                          height: 380,
                          child: FuelGauge(
                            title: 'fuel gauge',
                            fuel: carFirebaseRealtime['fuel'],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ThermoView(
                        val: carFirebaseRealtime['temp'],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomContainer(
                          width: 350,
                          height: 380,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.power_settings_new,
                                          color: mcolor,
                                          size: 120,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 229, 229, 229),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            'Ignition',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 20,
                                  // ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Image.asset(
                                          'assets/images/steering.png',
                                          width: 120,
                                          height: 120,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 229, 229, 229),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            carFirebaseRealtime['steering']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 60, 60, 60)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/brake1.png',
                                            width: 120,
                                            height: 120,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              carFirebaseRealtime['manualbrake']
                                                  ? 'on'
                                                  : 'off',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/fet.png',
                                            width: 120,
                                            height: 120,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: Text(
                                              carFirebaseRealtime['fatis'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  );
                } else {
                  return const Text('very big error');
                }
                // return const Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RpmGauge extends StatelessWidget {
  final num rpm;
  const RpmGauge({
    super.key,
    required this.rpm,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 8, ranges: <GaugeRange>[
        GaugeRange(startValue: 0, endValue: 6, color: Colors.green),
        GaugeRange(startValue: 6, endValue: 8, color: Colors.red),
      ], pointers: <GaugePointer>[
        NeedlePointer(value: rpm.toDouble())
      ], annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Text(rpm.toString(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            angle: 90,
            positionFactor: 0.5)
      ])
    ]);
  }
}

class SpeedGauge extends StatelessWidget {
  final num speed;
  const SpeedGauge({
    super.key,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
        GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
        GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
        GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
      ], pointers: <GaugePointer>[
        NeedlePointer(value: speed.toDouble())
      ], annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Text(speed.toString(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            angle: 90,
            positionFactor: 0.5)
      ])
    ]);
  }
}
