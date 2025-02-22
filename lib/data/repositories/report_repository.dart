import 'dart:io';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';

class ReportRepository with ChangeNotifier {
  final ReportService _reportService;

  ReportRepository(this._reportService);

  Future<List<Report>> fetchReports() async {
    return await _reportService.fetchReports();
  }

  Future<void> submitReport(String description, String category, File image, int userId) async {
    await _reportService.createReport(description, category, image, userId: userId);
  }
}
