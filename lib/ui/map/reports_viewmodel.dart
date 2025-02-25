import 'dart:io';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:native_exif/native_exif.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';

class ReportsViewModel extends ChangeNotifier {
  final ReportRepository _reportRepository;
  final AuthProvider _authProvider;

  List<Report> _reports = [];
  List<Marker> _markers = [];
  List<MarkerCluster> _clusters = [];
  List<WeightedLatLng> _heatmapData = [];
  bool _showHeatmap = false;
  bool _isLoading = true;
  bool _isSubmissionSuccessful = false;
  String _errorMessage = '';

  // Form-related state
  String? _description;
  String? _selectedCategory;
  File? _image;
  final List<String> _categories = [
    'Abandoned vehicle',
    'Crash barrier and guard-rail',
    'Dangerous structure or vacant building',
    'Ironworks',
    'Missed bin collection',
    'Obstructions',
    'Pavement issue',
    'Potholes',
    'Signs or road markings',
    'Spillages',
    'Street cleaning issue',
    'Street lighting fault',
    'Traffic lights'
  ];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController descriptionController = TextEditingController();

  List<Report> get reports => _reports;
  List<Marker> get markers => _markers;
  List<MarkerCluster> get clusters => _clusters;
  List<WeightedLatLng> get heatmapData => _heatmapData;
  bool get showHeatmap => _showHeatmap;
  bool get isLoading => _isLoading;
  bool get isSubmissionSuccessful => _isSubmissionSuccessful;
  String get errorMessage => _errorMessage;
  String? get description => _description;
  String? get selectedCategory => _selectedCategory;
  File? get image => _image;
  List<String> get categories => _categories;

  ReportsViewModel(this._reportRepository, this._authProvider);

  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _reports = await _reportRepository.fetchReports();

      _markers = _reports.map((report) {
        final lat = report.geolocation.geometry.coordinates[0];
        final lon = report.geolocation.geometry.coordinates[1];
        return Marker(
          width: 10.0,
          height: 10.0,
          point: LatLng(lat, lon),
          child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
        );
      }).toList();

      _heatmapData = _reports.map((report) {
        final lat = report.geolocation.geometry.coordinates[0];
        final lon = report.geolocation.geometry.coordinates[1];
        return WeightedLatLng(LatLng(lat, lon), 1);
      }).toList();

      calculateClusters(8.0);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void calculateClusters(double zoomLevel) {
    const zoomThresholds = [7, 8.5, 10.0, 11.0];
    double clusterSize = 0.1;

    // determining cluster size based on zoom level thresholds
    if (zoomLevel < zoomThresholds[0]) {
      final totalLat =
          _markers.fold(0.0, (sum, marker) => sum + marker.point.latitude);
      final totalLon =
          _markers.fold(0.0, (sum, marker) => sum + marker.point.longitude);
      final center =
          LatLng(totalLat / _markers.length, totalLon / _markers.length);
      _clusters = [MarkerCluster(center, _markers.length)];
    } else if (zoomLevel < zoomThresholds[1]) {
      clusterSize = 0.5;
    } else if (zoomLevel < zoomThresholds[2]) {
      clusterSize = 0.25;
    } else if (zoomLevel < zoomThresholds[3]) {
      clusterSize = 0.125;
    } else {
      clusterSize = 0.0625;
    }

    // if zoom level is higher than any of the thresholds, then clusters disappear and the markers are displayed
    if (zoomLevel >= zoomThresholds[0]) {
      final clusters = <MarkerCluster>[];
      final clusterMap = <String, List<LatLng>>{};

      for (final marker in _markers) {
        final lat = (marker.point.latitude / clusterSize).floor() * clusterSize;
        final lon =
            (marker.point.longitude / clusterSize).floor() * clusterSize;
        final key = '$lat-$lon';

        if (clusterMap.containsKey(key)) {
          clusterMap[key]!.add(marker.point);
        } else {
          clusterMap[key] = [marker.point];
        }
      }

      clusterMap.forEach((key, points) {
        // use the first point as the cluster centerfor consistency across zoom thresholds
        final center = points.first;
        clusters.add(MarkerCluster(center, points.length));
      });

      _clusters = clusters;
    }

    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setImage(File value) {
    _image = value;
    notifyListeners();
  }

  Future<void> pickImageWithLocation(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      if (source == ImageSource.camera) {
        final location = await _getCurrentLocation();
        if (location != null) {
          try {
            final exif = await Exif.fromPath(pickedFile.path);
            await exif.writeAttributes({
              'GPSLatitude': location.latitude.toString(),
              'GPSLongitude': location.longitude.toString(),
            });
            await exif.close();
          } catch (e) {
            _errorMessage = "Failed to write location to image.";
            LoggerService.logger.e('Failed to write location to image: $e');
          }
        } else {
          _errorMessage = "Location access denied or unavailable.";
          LoggerService.logger.e('Location access denied or unavailable.');
        }
      }

      notifyListeners();
    }
  }

  Future<LocationData?> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  bool isFormValid() {
    return _description != null &&
        _description!.isNotEmpty &&
        _selectedCategory != null &&
        _image != null;
  }

  Future<void> submitReport() async {
    if (!isFormValid()) return;

    final userId = _authProvider.userId;

    try {
      await _reportRepository.submitReport(
        _description!,
        _selectedCategory!,
        _image!,
        userId!,
      );
      _description = '';
      _selectedCategory = null;
      _image = null;
      _errorMessage = '';
      descriptionController.clear();
      _isSubmissionSuccessful = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void toggleHeatmap() {
    _showHeatmap = !_showHeatmap;
    LoggerService.logger.i('Heatmap toggled. Show Heatmap: $_showHeatmap');
    notifyListeners();
  }
}

class MarkerCluster {
  final LatLng center;
  final int count;

  MarkerCluster(this.center, this.count);
}
