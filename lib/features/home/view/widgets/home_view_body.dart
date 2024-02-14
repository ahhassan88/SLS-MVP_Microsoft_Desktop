import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_container.dart';

import 'package:sls_mvp_microsoft/features/home/view/widgets/Map/mapLeaflet_view.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/neumorphic_expenses/totalVehicles_view.dart';
import 'package:sls_mvp_microsoft/features/home/view_model/signout_cubit/signout_cubit.dart';
// import 'package:sls_mvp_microsoft/features/home/widgets/Map/mapbox_view.dart';
// import 'package:sls_mvp_microsoft/features/monitoring/monitoring_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: CustomContainer(
            width: 500,
            height: 350,
            child: TotalVehiclesPieChart(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: CustomContainer(
            width: 500,
            height: 380,
            child: MapLeafletView(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: CustomContainer(
            width: 500,
            height: 380,
            child: tableV(context: context),
          ),
        ),
      ],
    ));
  }
}

class tableV extends StatelessWidget {
  const tableV({
    super.key,
    required this.context,
  });

  final BuildContext context;
  void _navigateToDetailsPage(String name, String ignite, String temp) {
    context.goNamed('DetailsPage',
        pathParameters: {'name': name, 'ignite': ignite, 'temp': temp});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'VEHICLE',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'IGNITION',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'CABINET1',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'DOOR',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'KMS TODAY',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'ALERTS',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'LOCATION',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'SPEED',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'TRIPS',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'TOTAL KMS',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'LAST UPDATE',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'GROUP',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'DRIVER',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'FIRST ACTIVE',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'LAST ACTIVE',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'TIMESTAMP',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'VIDEO',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'BATTERY',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(
                const Row(
                  children: [
                    Icon(Icons.local_shipping),
                    SizedBox(
                      width: 10,
                    ),
                    Text('M854269'),
                  ],
                ),
                onTap: () {
                  _navigateToDetailsPage('M854269', '0xFF008000', '10°c');
                },
              ),
              const DataCell(
                  Icon(Icons.power_settings_new, color: Color(0xFF008000))),
              const DataCell(Text('10°c')),
              const DataCell(Icon(Icons.door_front_door, color: Colors.green)),
              const DataCell(Text('191 KMs')),
              const DataCell(Text('104', style: TextStyle(color: Colors.red))),
              const DataCell(Text('28,AI turath street',
                  style: TextStyle(color: Colors.blue))),
              const DataCell(Text('12 Kmph')),
              DataCell(Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      const Text('0', style: TextStyle(color: Colors.white)))),
              DataCell(Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: const Text('0 0 0 2 8 2 7 4',
                      style: TextStyle(color: Colors.black)))),
              const DataCell(Text('50 sec ago')),
              const DataCell(Text('Merchandiser')),
              const DataCell(Text('Najeeb Mohammed')),
              const DataCell(Text('08:07 AM')),
              const DataCell(Text('04:00 PM')),
              const DataCell(Text('02/01/2024 16:21')),
              const DataCell(Icon(Icons.videocam, color: Colors.red)),
              const DataCell(Text('0.00 volts')),
            ],
          ),
          // DataRow(
          //   cells: <DataCell>[
          //     DataCell(
          //       Text('Ahmed'),
          //       onTap: () {
          //         _navigateToDetailsPage('Ahmed', '19', 'Student');
          //       },
          //     ),
          //     DataCell(Text('19')),
          //     DataCell(Text('Student')),
          //     DataCell(Text('Student')),
          //     DataCell(Text('Student')),
          //     DataCell(Text('Student')),
          //     DataCell(Text('Student')),
          //     DataCell(Text('Student')),
          //   ],
          // ),
        ],
      ),
    );
  }
}

DataRow createDataRow({
  required String trackingId,
  required String powerColor,
  required String temperature,
  required String doorColor,
  required String distance,
  required String batteryLevel,
  required String address,
  required String speed,
  required String statusText,
  // required String statusColor,
  required String imei,
  required String timeAgo,
  required String role,
  required String name,
  required String startTime,
  required String endTime,
  required String lastUpdated,
  required String voltage,
  // required Function onTap,
}) {
  int powercolori = int.parse(powerColor);
  int doorcolori = int.parse(doorColor);

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Icon(Icons.local_shipping),
            SizedBox(width: 10),
            Text(trackingId),
          ],
        ),
        onTap: () {
          (BuildContext context) {
            context.goNamed('DetailsPage', pathParameters: {
              'name': trackingId,
              'ignite': powerColor,
              'temp': temperature
            });
          };
        },
      ),
      DataCell(
        Icon(Icons.power_settings_new, color: Color(powercolori)),
      ),
      DataCell(Text(temperature)),
      DataCell(Icon(Icons.door_front_door, color: Color(doorcolori))),
      DataCell(Text(distance)),
      DataCell(Text(batteryLevel, style: TextStyle(color: Colors.red))),
      DataCell(Text(address, style: TextStyle(color: Colors.blue))),
      DataCell(Text(speed)),
      DataCell(
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(statusText, style: TextStyle(color: Colors.white)),
        ),
      ),
      DataCell(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey),
          child: Text(imei, style: TextStyle(color: Colors.black)),
        ),
      ),
      DataCell(Text(timeAgo)),
      DataCell(Text(role)),
      DataCell(Text(name)),
      DataCell(Text(startTime)),
      DataCell(Text(endTime)),
      DataCell(Text(lastUpdated)),
      DataCell(Icon(Icons.videocam, color: Colors.red)),
      DataCell(Text(voltage)),
    ],
  );
}
