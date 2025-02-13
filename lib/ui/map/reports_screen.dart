import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ReportsViewModel()..fetchReports(),
        child: Consumer<ReportsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            } else {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(54.637, -6.671),
                  initialZoom: 8
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: viewModel.markers
                  )
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define the action for the "Add" button here
          print('Add button pressed');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
