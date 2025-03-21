import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:flutter_hbm/widgets/widgets_for_main_page.dart';
import 'package:provider/provider.dart';

import '../screens/profile_settings.dart';
import '../screens/provider/user_provider.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 2,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Health Body&Mind",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Hello, how are you today, ${userProvider.firstName}! ",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black54,
                            ),
                          ),
                          TextSpan(
                            text: "😊",
                            style: TextStyle(
                              fontFamily: 'NotoColorEmoji',
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.black54),
                      onPressed: null,
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
                        );
                      },
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: userProvider.imageUrl.isNotEmpty
                                ? NetworkImage(userProvider.imageUrl)
                                : null,
                            child: userProvider.imageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.white)
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 180,
              color: Colors.grey[200],
              child: VerticalScrollable(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    menuButton(context, "Home Page"),
                    SizedBox(height: 20),
                    menuButton(context, "Food"),
                    SizedBox(height: 20),
                    menuButton(context, "Exercise"),
                    SizedBox(height: 20),
                    menuButton(context, "Charts"),
                  ],
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.help_outline),
              label: Text("AI Help"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}