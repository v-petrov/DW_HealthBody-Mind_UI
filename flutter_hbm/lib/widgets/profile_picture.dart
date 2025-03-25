import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens/provider/user_provider.dart';
import '../screens/services/user_service.dart';

class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget({super.key});

  @override
  ProfilePictureWidgetState createState() => ProfilePictureWidgetState();
}

class ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  Uint8List? webImage;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadProfilePicture();
    });
  }

  Future<void> uploadImageToFirebaseWeb(Uint8List fileBytes) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      String fileName = "profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = ref.putData(fileBytes);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await UserService.updateProfilePicture(downloadUrl);
        await userProvider.updateProfilePicture(downloadUrl);

        setState(() {
          profilePictureUrl = userProvider.imageUrl;
        });
      } else {
        throw Exception("Upload failed, TaskState: ${snapshot.state}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
        await uploadImageToFirebaseWeb(bytes);
      }
    }
  }

  Future<void> loadProfilePicture() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.loadProfilePicture();
      if (userProvider.imageUrl.isNotEmpty) {
        setState(() {
          profilePictureUrl = userProvider.imageUrl;
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: profilePictureUrl != null
              ? NetworkImage(profilePictureUrl!)
              : null,
          child: (profilePictureUrl == null) ? Text("Your Picture") : null,
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
