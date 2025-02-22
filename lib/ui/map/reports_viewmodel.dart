import 'dart:io';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:native_exif/native_exif.dart';

class ReportsViewModel extends ChangeNotifier {
  final ReportsProvider _reportProvider;
  final AuthProvider _authProvider;

  List<Report> _reports = [];
  List<Marker> _markers = [];
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
  bool get isLoading => _isLoading;
  bool get isSubmissionSuccessful => _isSubmissionSuccessful;
  String get errorMessage => _errorMessage;
  String? get description => _description;
  String? get selectedCategory => _selectedCategory;
  File? get image => _image;
  List<String> get categories => _categories;

  ReportsViewModel(this._reportProvider, this._authProvider);

  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _reports = await _reportProvider.fetchReports();
      print(_reports);
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
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
          }
        } else {
          _errorMessage = "Location access denied or unavailable.";
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
      await _reportProvider.submitReport(
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
}
