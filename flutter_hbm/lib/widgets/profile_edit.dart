import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileEditWidget extends StatefulWidget {
  const ProfileEditWidget({super.key});

  @override
  ProfileEditWidgetState createState() => ProfileEditWidgetState();
}

class ProfileEditWidgetState extends State<ProfileEditWidget> {
  final TextEditingController nameController =
  TextEditingController(text: "Vasil Ivanov");
  final TextEditingController dobController =
  TextEditingController(text: "01/01/1995");
  final TextEditingController genderController =
  TextEditingController(text: "Male");
  final TextEditingController heightController =
  TextEditingController(text: "180 cm");

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Profile:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),

          buildProfileField("Name:", nameController),
          buildProfileField("Date of birth:", dobController),
          buildProfileField("Gender:", genderController),
          buildProfileField("Height:", heightController),

          SizedBox(height: 15),

          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    if (kDebugMode) {
                      print("Saving data: ${nameController.text}");
                    }
                  }
                  isEditing = !isEditing;
                });
              },
              child: Text(isEditing ? "Save Profile" : "Edit Profile"),
            ),
          ),
          SizedBox(height: 15),

          TextButton(
            onPressed: () {},
            child: Text("Change password"),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Change email"),
          ),
        ],
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
