// import 'package:communityeye_frontend/data/providers/auth_provider.dart';
// import 'package:communityeye_frontend/data/repositories/report_repository.dart';
// import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});

//   void _onMarkerTapped(BuildContext context, Marker marker) {
//     final viewModel = context.read<ReportsViewModel>();
//     final report = viewModel.reports.firstWhere((report) {
//       final lat = report.geolocation.geometry.coordinates[0];
//       final lon = report.geolocation.geometry.coordinates[1];
//       return marker.point.latitude == lat && marker.point.longitude == lon;
//     });

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           height: 200,
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(report.image.url, height: 150, width: double.infinity, fit: BoxFit.cover),
//               Text('Description: ${report.description}'),
//               Text('Category: ${report.category}'),
//               Text('Authority: ${report.authority}'),
//               Text(
//                  'Created at: ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(report.createdAt * 1000))}'
//               ),
//               Text('Resolved: ${report.resolved}')
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ChangeNotifierProvider(
//         create: (context) => ReportsViewModel(
//           Provider.of<ReportRepository>(context, listen: false),
//           Provider.of<AuthProvider>(context, listen: false),
//         )..fetchReports(),
//         child: Consumer<ReportsViewModel>(
//           builder: (context, viewModel, child) {
//             if (viewModel.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (viewModel.errorMessage.isNotEmpty) {
//               return Center(child: Text('Error: ${viewModel.errorMessage}'));
//             } else {
//               return FlutterMap(
//                 options: const MapOptions(
//                   initialCenter: LatLng(54.637, -6.671),
//                   initialZoom: 8,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     userAgentPackageName: 'com.example.app',
//                   ),
//                   MarkerLayer(
//                     markers: viewModel.markers.map((marker) {
//                       return Marker(
//                         width: 40.0,
//                         height: 40.0,
//                         point: marker.point,
//                         child: GestureDetector(
//                           onTap: () => _onMarkerTapped(context, marker),
//                           child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             builder: (context) {
//               return ChangeNotifierProvider.value(
//                 value: context.read<ReportsViewModel>(),
//                 child: const AddReportForm(),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddReportForm extends StatelessWidget {
//   const AddReportForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<ReportsViewModel>();

//     return Padding(
//       padding: MediaQuery.of(context).viewInsets,
//       child: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 controller: viewModel.descriptionController,
//                 onChanged: viewModel.setDescription,
//                 maxLength: 300,
//                 decoration: const InputDecoration(labelText: 'Description'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: viewModel.selectedCategory,
//                 decoration: const InputDecoration(labelText: 'Category'),
//                 items: viewModel.categories.map((category) {
//                   return DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: viewModel.setCategory,
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: () => viewModel.pickImageWithLocation(ImageSource.camera),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: () => viewModel.pickImageWithLocation(ImageSource.gallery),
//                   ),
//                 ],
//               ),
//               if (viewModel.image != null)
//                 Image.file(viewModel.image!, height: 200.0, width: 200.0),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: viewModel.isFormValid()
//                     ? () async {
//                         await viewModel.submitReport();
//                         if (viewModel.isSubmissionSuccessful) {
//                           Navigator.of(context).pop();
//                         }
//                       }
//                     : null,
//                 child: const Text('Submit'),
//               ),
//               if (viewModel.errorMessage.isNotEmpty)
//                 Text(
//                   viewModel.errorMessage,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _onMarkerTapped(BuildContext context, Marker marker) {
    final viewModel = context.read<ReportsViewModel>();
    final report = viewModel.reports.firstWhere((report) {
      final lat = report.geolocation.geometry.coordinates[0];
      final lon = report.geolocation.geometry.coordinates[1];
      return marker.point.latitude == lat && marker.point.longitude == lon;
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(report.image.url, height: 150, width: double.infinity, fit: BoxFit.cover),
              Text('Description: ${report.description}'),
              Text('Category: ${report.category}'),
              Text('Authority: ${report.authority}'),
              Text(
                 'Created at: ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(report.createdAt * 1000))}'
              ),
              Text('Resolved: ${report.resolved}')
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ReportsViewModel(
          Provider.of<ReportRepository>(context, listen: false),
          Provider.of<AuthProvider>(context, listen: false),
        )..fetchReports(),
        child: Consumer<ReportsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            } else {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(54.637, -6.671),
                  initialZoom: 8,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: viewModel.markers.map((marker) {
                      return Marker(
                        width: 40.0,
                        height: 40.0,
                        point: marker.point,
                        child: GestureDetector(
                          onTap: () => _onMarkerTapped(context, marker),
                          child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return ChangeNotifierProvider.value(
                value: context.read<ReportsViewModel>(),
                child: const AddReportForm(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddReportForm extends StatelessWidget {
  const AddReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ReportsViewModel>();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: viewModel.descriptionController,
                onChanged: viewModel.setDescription,
                maxLength: 300,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: viewModel.selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: viewModel.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: viewModel.setCategory,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => viewModel.pickImageWithLocation(ImageSource.camera),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => viewModel.pickImageWithLocation(ImageSource.gallery),
                  ),
                ],
              ),
              if (viewModel.image != null)
                Image.file(viewModel.image!, height: 200.0, width: 200.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: viewModel.isFormValid()
                    ? () async {
                        await viewModel.submitReport();
                        if (viewModel.isSubmissionSuccessful) {
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                child: const Text('Submit'),
              ),
              if (viewModel.errorMessage.isNotEmpty)
                Text(
                  viewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
