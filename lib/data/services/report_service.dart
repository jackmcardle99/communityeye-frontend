import 'dart:convert';
import 'dart:io';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final String baseUrl = 'http://192.168.0.143:5000/api/v1/';
  
  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('${baseUrl}reports'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromJson(report)).toList();
    } else {
      throw Exception('Failed to fetch reports');
    }
  }

  Future<String> createReport(String description, String category, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}reports'));
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['url'];
    } else {
      throw Exception('Failed to create report');
    }
  }
}