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
      appBar: AppBar(
        title: Text('Reports'),
      ),
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
    );
  }
}

// class ReportCard extends StatelessWidget {
//   final Report report;

//   ReportCard({required this.report});
  
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
            
//             // Text('Description: ${report.description}'),
//             // Text('Category: ${report.category}'),
//             // Text('Authority: ${report.authority}'),
//             // Text('Resolved: ${report.resolved ? 'Yes' : 'No'}'),
//             // Text('Created At: ${DateTime.fromMillisecondsSinceEpoch(report.createdAt * 1000)}'),
//             // SizedBox(height: 16.0),
//             // Text('Image:'),
//             // SizedBox(height: 8.0),
//             // Image.network(report.image.url), // Display the image using the URL
//           ],
//         ),
//       ),
//     );
//   }
// }
