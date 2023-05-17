import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_login_payment/user/user_information_controller.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key});
  final UserInformationController _con = Get.put(UserInformationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text("ID: ${Get.arguments['id'] ?? ''}"),
          Text("Email: ${Get.arguments['email'] ?? ''}"),
          Text("Displayname: ${Get.arguments['displayName'] ?? ''}"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async => _con.logout(),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
