import 'package:mixyspring2024/user_auth/controller/provider/auth_provider.dart';
// import 'package:mixyspring2024/user_auth/utils/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:mixyspring2024/user_auth/view/auth_screens.dart';
// import 'view/otp_screen.dart';
// import 'firebase_options.dart';
import 'package:mixyspring2024/user_auth/utils/theme.dart';
import 'package:mixyspring2024/user_auth/view/signInLogic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_options.dart';

class Amazon extends StatelessWidget {
  const Amazon({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider_>(create: (_) => AuthProvider_()),
      ],
      child: MaterialApp(
        theme: theme,
        // home: OTPScreen(
        //   mobileNumber: '+911100101010',
        // ),
        home: AuthScreen(),
        // home: UserBottomNavBar(),
        debugShowCheckedModeBanner: false,
      ),
    );
  } // Add closing curly brace here
}
