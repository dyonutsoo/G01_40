import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:flutter/material.dart';

import '../../../../constants/images.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: const AssetImage(tWelcomeScreenImage),
          height: size.height * 0.25,
        ),
        Text(tLoginTitle.toUpperCase(), style: Theme.of(context).textTheme.headline2, ),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}