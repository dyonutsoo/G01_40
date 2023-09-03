import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../constants/text.dart';
import 'appbar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDashboardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tDashboardTitle, style: Theme.of(context).textTheme.headline6),
                Text(tDashboardHeading, style: Theme.of(context).textTheme.bodyText2),
                const SizedBox(height: tDashboardPadding),
              ],
            ),
          ),
    ),
    );
  }
}

