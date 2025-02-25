import 'dart:io';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';

class ReportRepository with ChangeNotifier {
  final ReportService _reportService;
  final AuthProvider _authProvider;

  ReportRepository(this._reportService, this._authProvider);
  
  Future<List<Report>> fetchReports() async {
    try {
      String? token = await _authProvider.getToken();
      List<Report> reports = await _reportService.fetchReports(token!);
      LoggerService.logger.i('Fetched all reports successfully.');
      return reports;
    } catch (e) {
      LoggerService.logger.e('Error fetching reports: $e');
      rethrow;
    }
  }

  Future<List<Report>> fetchReportsByUserId(int userId) async {
    try {
      String? token = await _authProvider.getToken();
      List<Report> reports = await _reportService.fetchReportsByUserId(userId, token!);
      LoggerService.logger
          .i('Fetched reports for User ID: $userId successfully.');
      return reports;
    } catch (e) {
      LoggerService.logger
          .e('Error fetching reports for User ID: $userId - Error: $e');
      rethrow;
    }
  }

  Future<void> submitReport(
      String description, String category, File image, int userId) async {
    try {
      String? token = await _authProvider.getToken();
      await _reportService.createReport(description, category, image,
          token!, userId: userId);
      LoggerService.logger
          .i('Report submitted successfully by User ID: $userId.');
    } catch (e) {
      LoggerService.logger
          .e('Error submitting report for User ID: $userId - Error: $e');
      rethrow;
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      String? token = await _authProvider.getToken();
      await _reportService.deleteReport(reportId, token!);
      LoggerService.logger.i('Report ID: $reportId deleted successfully.');
    } catch (e) {
      LoggerService.logger.e('Error deleting report ID: $reportId - Error: $e');
      rethrow;
    }
  }
}
