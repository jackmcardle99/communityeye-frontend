import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';


class MyReportsViewModel with ChangeNotifier {
  final ReportRepository _reportRepository;
  final AuthProvider _authProvider;
  List<Report> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  MyReportsViewModel(this._reportRepository, this._authProvider);

  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.userId;
      _reports = await _reportRepository.fetchReportsByUserId(userId!);
    } catch (e) {
      _errorMessage = 'Failed to load reports. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  Future<void> deleteReport(String reportId) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     await _reportRepository.deleteReport(reportId);
  //     _reports.removeWhere((report) => report.id == reportId);
  //   } catch (e) {
  //     _errorMessage = 'Failed to delete report. Please try again later.';
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

   Future<bool> deleteReport(String reportId) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      // Assuming you have a repository or service to handle the deletion
      await _reportRepository.deleteReport(reportId);
      // If successful, remove the report from the local list and notify listeners
      reports.removeWhere((report) => report.id == reportId);
      notifyListeners();
      _isLoading = false;
      return true; // Indicate success
    } catch (e) {
      _isLoading = false;
      // Handle errors (e.g., show an error message)
      _errorMessage = 'Failed to delete the report';
      notifyListeners();
      return false; // Indicate failure
    }
  }
}
