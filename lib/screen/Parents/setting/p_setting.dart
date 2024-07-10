import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kiddielink_app/theme/provider.dart';
import 'package:provider/provider.dart';
import 'package:kiddielink_app/screen/Parents/p_editProfile.dart';
import 'package:kiddielink_app/screen/Parents/p_homepage.dart';
import 'package:kiddielink_app/screen/Parents/setting/p_changePassword.dart';
import 'package:kiddielink_app/screen/Parents/setting/widget/forward_button.dart';
import 'package:kiddielink_app/screen/Parents/setting/widget/setting_item.dart';
import 'package:kiddielink_app/screen/Parents/setting/widget/setting_switch.dart';

class SettingScreen extends StatelessWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final String studentId;

  const SettingScreen({
    required this.email,
    required this.parentData,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PHomePage(
                  email: email,
                  parentData: parentData,
                  studentId: studentId,
                ),
              ),
            );
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE040FB),
                Color(0xFF7C4DFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      parentData['photoUrl'] != null
                          ? Image.network(
                        parentData['photoUrl'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/logo.png",
                        width: 70,
                        height: 70,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parentData['name'] ?? 'No name available',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ForwardButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAccountScreen(
                                email: email,
                                parentData: parentData,
                                studentId: studentId,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Change Password",
                  icon: Ionicons.lock_closed,
                  bgColor: Colors.orange.shade100,
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangePasswordScreen(email: email),
                      ),
                    );
                  },
                ),
                /* const SizedBox(height: 20),
                SettingItem(
                  title: "Notifications",
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ), */
                /* const SizedBox(height: 20),
                SettingSwitch(
                  title: "Dark Mode",
                  icon: Ionicons.moon,
                  bgColor: Colors.purple.shade100,
                  iconColor: Colors.purple,
                  value: notifier.isDark,
                  onTap: (value)=>notifier.changeTheme()
                ), */
               /*  const SizedBox(height: 20),
                SettingItem(
                  title: "Help",
                  icon: Ionicons.nuclear,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {},
                ), */
              ],
            ),
          );
        },
      ),
    );
  }
}
