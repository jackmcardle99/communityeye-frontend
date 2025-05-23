/*
File: my_reports_screen.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/ui/reports/myreport_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communityeye_frontend/data/model/report.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  MyReportsScreenState createState() => MyReportsScreenState();
}

class MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyReportsViewModel>().fetchReports();
    });
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      report.image.url,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description: ',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.description,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Category: ',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.category,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Authority: ',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.authority,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Created At: ',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              report.createdAt * 1000)),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status: ',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.resolved ? 'Resolved' : 'In progress',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool isDeleted = await context
                                .read<MyReportsViewModel>()
                                .deleteReport(report.id);
                            if (isDeleted) {
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Failed to delete the report')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Reports'), automaticallyImplyLeading: false),
      body: Consumer<MyReportsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          if (viewModel.reports.isEmpty) {
            return const Center(child: Text('No reports available'));
          }

          return ListView.builder(
            itemCount: viewModel.reports.length,
            itemBuilder: (context, index) {
              Report report = viewModel.reports[index];
              String formattedDate = DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(report.createdAt * 1000),
              );

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Description: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: report.description.length > 300
                                    ? '${report.description.substring(0, 300)}...'
                                    : report.description,
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Authority: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: report.authority,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              'Created At: $formattedDate',
                            ),
                            Text('Resolved: ${report.resolved ? 'Yes' : 'No'}'),
                          ],
                        ),
                        onTap: () {
                          _showReportDetails(report);
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tap to view details',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
