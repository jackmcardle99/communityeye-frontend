import 'dart:convert';
import 'dart:io';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final String baseUrl = 'http://192.168.0.143:5000/api/v1/';
  // final String baseUrl = 'http://localhost:5000/api/v1/';
  
  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('${baseUrl}reports'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromJson(report)).toList();
    } else {
      throw Exception('Failed to fetch reports');
    }
  }

  Future<List<Report>> fetchReportsByUserId(int userId) async {
    final response = await http.get(Uri.parse('${baseUrl}reports/user/$userId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromJson(report)).toList();
    } else {
      throw Exception('Failed to fetch reports for user');
    }
  }

  // I don't know why i need to use {required userId}, but it breaks without ¯\_(ツ)_/¯
  Future<String> createReport(String description, String category, File image, {required userId}) async {
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}reports'));
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.fields['userID'] = userId.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['url'];
    } else {
      // Handle specific error cases based on the backend response
      if (response.statusCode == 422) {        
        throw const HttpException('Missing fields or no image was provided.');        
      } else if (response.statusCode == 400) {
          throw const HttpException("Image location could not be determined or is outside Northern Ireland.");
        }
      }
      // Default error handling
      throw const HttpException('Failed to create report. Please try again later.');
  } 
}