import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'AppConfig.dart';

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/api/ImageUpload/UploadImage'); // Replace with your C# service endpoint
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded');
      } else {
        // Handle other status codes
        print('Image upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _imageFile != null
              ? Image.file(
            File(_imageFile!.path),
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
              : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'No image selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
              child: const Text('Select from gallery'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_imageFile != null) {
                  _uploadImage(File(_imageFile!.path));
                } else {
                  // Handle case where no image is selected
                  print('Please select an image');
                }
              },
              child: const Text('Upload image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
