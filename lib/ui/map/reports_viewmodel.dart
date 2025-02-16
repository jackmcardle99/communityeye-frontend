import 'dart:io';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';

class ReportsViewModel extends ChangeNotifier {
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

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  bool isFormValid() {
    return _description != null &&
        _description!.isNotEmpty &&
        _selectedCategory != null &&
        _image != null;
  }

  Future<void> submitReport() async {
    if (!isFormValid()) return;

    try {
      String reportUrl = await ReportService().createReport(
        _description!,
        _selectedCategory!,
        _image!,
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
