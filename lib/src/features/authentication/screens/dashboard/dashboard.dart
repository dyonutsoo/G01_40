import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/help/main_help_page.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../../constants/text.dart';
import 'appbar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tDashboardTitle, style: Theme.of(context).textTheme.headline6),
              Text(tDashboardHeading, style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: tDashboardPadding),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ));
                        },
                        child: SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/dashboard/profile.jpg",
                                      width: 64.0,
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      "Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Text(
                                      "Manage Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ));
                        },
                        child: SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/dashboard/settings.png",
                                      width: 64.0,
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      "Settings",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Text(
                                      "Manage Settings",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ));
                        },
                        child: SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/dashboard/details.png",
                                      width: 64.0,
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      "Door Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Text(
                                      "Access RFID and etc.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MainHelpPage(),
                          ));
                        },
                        child: SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/dashboard/helpdesk.jpg",
                                      width: 64.0,
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      "Help",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Text(
                                      "Send Enquiry",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: const DashboardAppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            buildDrawerItem(context, 'Profile', const ProfileScreen()),
            buildDrawerItem(context, 'Settings', const ProfileScreen()),
            buildDrawerItem(context, 'Door Details', const ProfileScreen()),
            buildDrawerItem(context, 'Help', const MainHelpPage()),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));
      },
      onHover: (isHovered) {
      },
      child: ListTile(
        title: Text(title),
      ),
    );
  }

}
