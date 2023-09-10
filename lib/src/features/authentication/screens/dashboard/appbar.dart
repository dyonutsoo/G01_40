import 'package:door_security_lock_app/src/constants/colors.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile/profile_screen.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(tAppName, style: Theme.of(context).textTheme.titleLarge),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black), // Set icon color to black
      // Added text color
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: tCardBgColor),
          child: IconButton(
              onPressed: () {
                Get.to(() => const ProfileScreen());
              },
              icon: const Image(image: AssetImage(tProfileImage))),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
