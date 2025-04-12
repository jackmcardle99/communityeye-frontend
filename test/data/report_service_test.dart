import 'dart:convert';
import 'dart:io';
import 'package:communityeye_frontend/data/model/report.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'report_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ReportService reportService;
  late MockClient mockClient;

  const token = 'mock_jwt_token';

  final report = Report(
    id: '1',
    userId: 1,
    description: 'Test report',
    category: 'Test',
    geolocation: Geolocation(
      type: 'Point',
      geometry: Geometry(
        type: 'Point',
        coordinates: [12.34, 56.78],
      ),
    ),
    authority: 'Local authority',
    image: ImageData(
      url: 'http://example.com/image.jpg',
      imageName: 'image.jpg',
      dimensions: [100, 100],
      geolocation: ImageGeolocation(lat: 12.34, lon: 56.78),
      fileSize: 1024,
    ),
    resolved: false,
    upvoteCount: 5,
    createdAt: 1625214100,
  );

  final reportsJson = jsonEncode([report.toJson()]);

  setUp(() {
    mockClient = MockClient();
    reportService = ReportService();
  });

  // reusable mock setup function
  Future<void> mockGetRequest(String url, {required int statusCode, required String responseBody}) async {
    when(mockClient.get(
      Uri.parse(url),
      headers: {'x-access-token': token},
    )).thenAnswer((_) async => http.Response(responseBody, statusCode));
  }

  group('ReportService Tests', () {
    group('fetchReports', () {
      test('returns a list of reports if fetch is successful', () async {
        await mockGetRequest(
          'http://192.168.0.143:5000/api/v1/reports',
          statusCode: 200,
          responseBody: reportsJson,
        );

        final result = await reportService.fetchReports(token);

        expect(result, equals([report]));
      });

      test('throws an exception if fetching reports fails', () async {
        await mockGetRequest(
          'http://192.168.0.143:5000/api/v1/reports',
          statusCode: 400,
          responseBody: 'Failed',
        );

        expectLater(reportService.fetchReports(token), throwsException);
      });
    });

    group('fetchReportsByUserId', () {
      test('returns a list of reports if fetch is successful', () async {
        await mockGetRequest(
          'http://192.168.0.143:5000/api/v1/reports/user/1',
          statusCode: 200,
          responseBody: reportsJson,
        );

        final result = await reportService.fetchReportsByUserId(1, token);

        expect(result, equals([report]));
      });

      test('throws an exception if fetching reports by user ID fails', () async {
        await mockGetRequest(
          'http://192.168.0.143:5000/api/v1/reports/user/1',
          statusCode: 400,
          responseBody: 'Failed',
        );

        expectLater(reportService.fetchReportsByUserId(1, token), throwsException);
      });
    });

    group('createReport', () {
      test('returns a URL if report creation is successful', () async {
        const reportUrl = 'http://192.168.0.143:5000/api/v1/reports/1';
        final image = File('test/image.jpg');
        const userId = 1;

        when(mockClient.send(any)).thenAnswer((_) async {
          final response = http.StreamedResponse(Stream.fromIterable([utf8.encode('{"url": "$reportUrl"}')]), 201);
          return response;
        });

        final result = await reportService.createReport('Test description', 'Test category', image, token, userId: userId);

        expect(result, equals(reportUrl));
      });

      test('throws an exception if report creation fails', () async {
        final image = File('test/image.jpg');
        const userId = 1;

        when(mockClient.send(any)).thenAnswer((_) async {
          final response = http.StreamedResponse(Stream.fromIterable([utf8.encode('{"error": "Missing fields"}')]), 422);
          return response;
        });

        expectLater(reportService.createReport('Test description', 'Test category', image, token, userId: userId), throwsA(isA<HttpException>()));
      });
    });

    group('deleteReport', () {
      test('does not throw if report deletion is successful', () async {
        const reportId = '1';

        when(mockClient.delete(
          Uri.parse('http://192.168.0.143:5000/api/v1/reports/$reportId'),
          headers: {'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Deleted', 204));

        await reportService.deleteReport(reportId, token);
      });

      test('throws an exception if report deletion fails', () async {
        const reportId = '1';

        when(mockClient.delete(
          Uri.parse('http://192.168.0.143:5000/api/v1/reports/$reportId'),
          headers: {'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(reportService.deleteReport(reportId, token), throwsException);
      });
    });

    group('upvoteReport', () {
      test('does not throw if upvoting is successful', () async {
        const reportId = '1';

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5000/api/v1/reports/$reportId/upvote'),
          headers: {'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Upvoted', 200));

        await reportService.upvoteReport(reportId, token);
      });

      test('throws an exception if upvoting fails', () async {
        const reportId = '1';

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5000/api/v1/reports/$reportId/upvote'),
          headers: {'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Failed', 409));

        expectLater(reportService.upvoteReport(reportId, token), throwsException);
      });
    });
  });
}
