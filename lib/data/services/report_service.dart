import 'dart:convert';
import 'dart:io';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:http/http.dart' as http;
import 'package:communityeye_frontend/data/services/logger_service.dart';

class ReportService {
  final String baseUrl = 'http://192.168.0.143:5000/api/v1/';

  Future<List<Report>> fetchReports(String token) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}reports'), headers: {
        "x-access-token": token,
      }, );
      LoggerService.logger.i('API Call: GET ${baseUrl}reports - Status Code: ${response.statusCode} ${response.reasonPhrase}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((report) => Report.fromJson(report)).toList();
      } else {
        throw Exception('Failed to fetch reports');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Report>> fetchReportsByUserId(int userId, String token) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}reports/user/$userId'), headers: {
        "x-access-token": token,
      }, );
      LoggerService.logger.i('API Call: GET ${baseUrl}reports/user/$userId - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((report) => Report.fromJson(report)).toList();
      } else {
        throw Exception('Failed to fetch reports for user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createReport(String description, String category, File image, String token, {required int userId}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}reports'));
      request.fields['description'] = description;
      request.fields['category'] = category;
      request.fields['userID'] = userId.toString();
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers['x-access-token'] = token;

      var response = await request.send();
      LoggerService.logger.i('API Call: POST ${baseUrl}reports - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');

      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        return jsonResponse['url'];
      } else {
        if (response.statusCode == 422) {
          throw const HttpException('Missing fields or no image was provided.');
        } else if (response.statusCode == 400) {
          throw const HttpException("Image location could not be determined or is outside Northern Ireland.");
        }
        throw const HttpException('Failed to create report. Please try again later.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReport(String reportId, String token) async {
    try {
      final response = await http.delete(Uri.parse('${baseUrl}reports/$reportId'), headers: {
        "x-access-token": token,
      }, );
      LoggerService.logger.i('API Call: DELETE ${baseUrl}reports/$reportId - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete report. Please try again later.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> upvoteReport(String reportId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}reports/$reportId/upvote'),
        headers: {
          "x-access-token": token,
        },
      );
      LoggerService.logger.i('API Call: POST ${baseUrl}reports/$reportId/upvote - Status Code: ${response.statusCode} ${response.reasonPhrase}');

      if (response.statusCode != 200) {
        throw Exception('Failed to upvote report');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// needed for multipart request 
extension on http.StreamedResponse {
  get body => null;
}
