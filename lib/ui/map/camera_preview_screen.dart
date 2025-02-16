import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // For using the camera preview


class CameraPreviewScreen extends StatefulWidget {
  final ReportsViewModel viewModel;

  const CameraPreviewScreen({super.key, required this.viewModel});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Initialize camera
      await widget.viewModel.initializeCamera();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: () async {
              // Capture image and dispose camera afterward
              await widget.viewModel.captureImage();
              widget.viewModel.disposeCamera();
              Navigator.of(context).pop();  // Return to the previous screen
            },
          ),
        ],
      ),
      body: Center(
        child: widget.viewModel.isCameraInitialized
            ? CameraPreview(widget.viewModel.cameraController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
