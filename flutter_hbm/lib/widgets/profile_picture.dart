import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget({super.key});

  @override
  ProfilePictureWidgetState createState() => ProfilePictureWidgetState();
}

class ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File? image;
  Uint8List? webImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
      } else {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: kIsWeb
              ? (webImage != null ? MemoryImage(webImage!) : null)
              : (image != null ? FileImage(image!) : null),
          child: (image == null && webImage == null) ? Text("Your Picture") : null,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: pickImage,
          child: Text("Edit Photo"),
        ),
      ],
    );
  }
}
