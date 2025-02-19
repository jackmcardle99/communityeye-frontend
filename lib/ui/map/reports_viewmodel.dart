import 'dart:io';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:native_exif/native_exif.dart';


class ReportsViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  List<Report> _reports = [];
  List<Marker> _markers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Form-related state
  String? _description;
  String? _selectedCategory;
  File? _image;
  final List<String> _categories = ['Category 1', 'Category 2', 'Category 3'];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController descriptionController = TextEditingController();

  List<Report> get reports => _reports;
  List<Marker> get markers => _markers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get description => _description;
  String? get selectedCategory => _selectedCategory;
  File? get image => _image;
  List<String> get categories => _categories;

  ReportsViewModel(this.authViewModel);

  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _reports = await ReportService().fetchReports();
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
      _image = File(pickedFile.path); // Set image immediately

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

      notifyListeners(); // Ensure UI updates regardless
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

  // Await the result of getTokenData()
  final tokenData = await authViewModel.getTokenData();
  if (tokenData == null || tokenData['id'] == null) {
    _errorMessage = "User ID not found in token.";
    notifyListeners();
    return;
  }

  final userId = tokenData['id'];

  try {
    String reportUrl = await ReportService().createReport(
      _description!,
      _selectedCategory!,
      _image!,
      userId: userId, // Pass the user ID to the report service
    );
    // Clear form fields after successful submission
    _description = '';
    _selectedCategory = null;
    _image = null;
    descriptionController.clear();
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    notifyListeners();
  }
}

}
