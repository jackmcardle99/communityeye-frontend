// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ChangeNotifierProvider(
//         create: (context) => ReportsViewModel()..fetchReports(),
//         child: Consumer<ReportsViewModel>(
//           builder: (context, viewModel, child) {
//             if (viewModel.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (viewModel.errorMessage.isNotEmpty) {
//               return Center(child: Text('Error: ${viewModel.errorMessage}'));
//             } else {
//               return FlutterMap(
//                 options: const MapOptions(
//                   initialCenter: LatLng(54.637, -6.671),
//                   initialZoom: 8
//                 ),
//                 children: [
//                   TileLayer(
//                       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                       userAgentPackageName: 'com.example.app',
//                   ),
//                   MarkerLayer(
//                     markers: viewModel.markers
//                   )
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             builder: (context) => const AddReportForm(),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddReportForm extends StatefulWidget {
//   const AddReportForm({super.key});
  
//   @override
//   _AddReportFormState createState() => _AddReportFormState();
// }

// class _AddReportFormState extends State<AddReportForm> {
//   final ImagePicker _picker = ImagePicker();
//   File? _image;
//   final TextEditingController _descriptionController = TextEditingController();
//   String? _selectedCategory;
//   final List<String> _categories = ['Category 1', 'Category 2', 'Category 3'];

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   bool _isFormValid() {
//     return _descriptionController.text.isNotEmpty &&
//         _selectedCategory != null &&
//         _image != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: MediaQuery.of(context).viewInsets,
//       child: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 controller: _descriptionController,
//                 maxLength: 300,
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: InputDecoration(labelText: 'Category'),
//                 items: _categories.map((category) {
//                   return DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: () => _pickImage(ImageSource.camera),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                   ),
//                 ],
//               ),
//               if (_image != null)
//                 Image.file(_image!, height: 200.0, width: 200.0),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: viewModel.isFormValid()
//                     ? () {
//                         viewModel.submitReport();
//                         Navigator.of(context).pop(); // Close the bottom sheet after submission
//                       }
//                     : null,
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ReportsViewModel()..fetchReports(),
        child: Consumer<ReportsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            } else {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(54.637, -6.671),
                  initialZoom: 8,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: viewModel.markers,
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap bottom sheet with the provider
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return ChangeNotifierProvider.value(
                value: Provider.of<ReportsViewModel>(context, listen: false),
                child: const AddReportForm(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddReportForm extends StatefulWidget {
  const AddReportForm({super.key});

  @override
  _AddReportFormState createState() => _AddReportFormState();
}

class _AddReportFormState extends State<AddReportForm> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage(ImageSource source, ReportsViewModel viewModel) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      viewModel.setImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReportsViewModel>(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _descriptionController,
                onChanged: viewModel.setDescription,
                maxLength: 300,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: viewModel.selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: viewModel.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: viewModel.setCategory,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _pickImage(ImageSource.camera, viewModel),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => _pickImage(ImageSource.gallery, viewModel),
                  ),
                ],
              ),
              if (viewModel.image != null)
                Image.file(viewModel.image!, height: 200.0, width: 200.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: viewModel.isFormValid()
                    ? () {
                        viewModel.submitReport();
                        Navigator.of(context).pop(); // Close the bottom sheet after submission
                      }
                    : null,
                child: const Text('Submit'),
              ),
              if (viewModel.errorMessage.isNotEmpty)
                Text(
                  viewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
