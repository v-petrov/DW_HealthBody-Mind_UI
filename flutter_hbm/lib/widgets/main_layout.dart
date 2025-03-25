import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:flutter_hbm/widgets/widgets_for_main_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hbm/screens/utils/formatters.dart';

import '../screens/profile_settings.dart';
import '../screens/provider/user_provider.dart';
import 'chat_screen.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final bool showWelcomeNotification;

  const AppLayout({
    super.key,
    required this.child,
    this.showWelcomeNotification = false
  });

  @override
  State<AppLayout> createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> with TickerProviderStateMixin {
  final GlobalKey notificationIconKey = GlobalKey();
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    OverlayEntry buildOverlay() {
      return OverlayEntry(
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              animationController.reverse().then((_) {
                overlayEntry?.remove();
                overlayEntry = null;
              });
            },
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(-180, 40),
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 250,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userProvider.notifications.isEmpty
                              ? [Text("No notifications yet.", style: TextStyle(color: Colors.grey))]
                              : List.generate(userProvider.notifications.length * 2 - 1, (index) {
                            if (index.isOdd) return Divider();
                            final itemIndex = index ~/ 2;
                            final notification = userProvider.notifications[itemIndex];
                            final timeAgo = DateFormatter.timeAgoSinceCreated(notification.timestamp);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Colors.black),
                                    children: () {
                                      if (notification.message.startsWith("🎉")) {
                                        return [
                                          const TextSpan(
                                            text: "🎉",
                                            style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 14),
                                          ),
                                          TextSpan(
                                            text: notification.message.substring(2).trim(),
                                          ),
                                        ];
                                      } else if (notification.message.startsWith("👋")) {
                                        return [
                                          const TextSpan(
                                            text: "👋",
                                            style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 14),
                                          ),
                                          TextSpan(
                                            text: notification.message.substring(2).trim(),
                                          ),
                                        ];
                                      } else {
                                        return [TextSpan(text: notification.message)];
                                      }
                                    }(),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  timeAgo,
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CompositedTransformTarget(
                          link: layerLink,
                          child: IconButton(
                            icon: Icon(Icons.notifications, color: Colors.black54),
                            onPressed: () {
                              if (overlayEntry == null) {
                                overlayEntry = buildOverlay();
                                Overlay.of(context).insert(overlayEntry!);
                                animationController.forward(from: 0);
                              } else {
                                animationController.reverse().then((_) {
                                  overlayEntry?.remove();
                                  overlayEntry = null;
                                });
                              }
                              userProvider.markNotificationsAsRead();
                            },
                          ),
                        ),
                        if (userProvider.hasNewNotification)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
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
            Expanded(child: widget.child),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreenWidget()),
                );
              },
              icon: Icon(Icons.help_outline),
              label: Text("HealthyBot"),
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