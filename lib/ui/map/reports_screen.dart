import 'dart:async';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:communityeye_frontend/ui/widgets/error_message.dart';
import 'package:communityeye_frontend/ui/widgets/success_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  final StreamController<void> _rebuildStream = StreamController.broadcast();
  double _currentZoom = 8.0;

  void _onMarkerTapped(BuildContext context, Marker marker) {
    final viewModel = context.read<ReportsViewModel>();
    final report = viewModel.reports.firstWhere((report) {
      final lat = report.geolocation.geometry.coordinates[0];
      final lon = report.geolocation.geometry.coordinates[1];
      return marker.point.latitude == lat && marker.point.longitude == lon;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.25,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          report.image.url,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description: ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report.description,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Category: ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report.category,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Authority: ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report.authority,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Created At: ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  report.createdAt * 1000)),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Status: ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report.resolved ? 'Resolved' : 'In progress',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              onPressed: () async {
                                await viewModel.upvoteReport(report.id);
                                if (viewModel.isUpvoteSuccessful) {
                                  TopSnackBarSuccess.show(context, "Upvote successful!");
                                  setState(() {});
                                } else {
                                  TopSnackBarError.show(context, 'Already upvoted!');
                                }
                              },
                            ),
                            Text(
                              '${report.upvoteCount ?? 0}', 
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _rebuildStream.close();
    super.dispose();
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
            } else if (viewModel.errorMessage.isNotEmpty && viewModel.reports.isEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            } else {
              return Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(54.637, -6.671),
                      initialZoom: _currentZoom,
                      onPositionChanged: (position, hasGesture) {
                        setState(() {
                          _currentZoom = position.zoom;
                        });
                        viewModel.calculateClusters(_currentZoom);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (viewModel.showHeatmap &&
                          viewModel.heatmapData.isNotEmpty)
                        HeatMapLayer(
                          heatMapDataSource: InMemoryHeatMapDataSource(
                              data: viewModel.heatmapData),
                          heatMapOptions: HeatMapOptions(
                            gradient: HeatMapOptions.defaultGradient,
                            minOpacity: 0.1,
                          ),
                          reset: _rebuildStream.stream,
                        ),
                      if (_currentZoom < 12)
                        MarkerLayer(
                          markers: viewModel.clusters.map((cluster) {
                            return Marker(
                              width: 40.0,
                              height: 40.0,
                              point: cluster.center,
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${cluster.count}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        MarkerLayer(
                          markers: viewModel.markers.map((marker) {
                            return Marker(
                              width: 40.0,
                              height: 40.0,
                              point: marker.point,
                              child: GestureDetector(
                                onTap: () => _onMarkerTapped(context, marker),
                                child: const Icon(Icons.location_on,
                                    color: Colors.red, size: 40.0),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "filterButton",
                          onPressed: () {
                            viewModel.toggleHeatmap();
                          },
                          child: Icon(viewModel.showHeatmap
                              ? Icons.layers_clear
                              : Icons.layers),
                        ),
                        const SizedBox(height: 8.0),
                        FloatingActionButton(
                          heroTag: "addButton",
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
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class AddReportForm extends StatelessWidget {
  const AddReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
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
                        onPressed: () =>
                            viewModel.pickImageWithLocation(ImageSource.camera),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () =>
                            viewModel.pickImageWithLocation(ImageSource.gallery),
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
                              TopSnackBarSuccess.show(context, "Report submitted!");
                            } else {
                              TopSnackBarError.show(context, viewModel.errorMessage);
                            }
                          }
                        : null,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
