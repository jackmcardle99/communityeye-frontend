import 'dart:convert';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final String baseUrl = 'http://localhost:5000/api/v1/';
  
  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('${baseUrl}reports'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromJson(report)).toList();
    } else {
      throw Exception('Failed to fetch reports');
    }
  }
}