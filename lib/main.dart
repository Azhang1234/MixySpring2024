import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';
import 'mixy_app_home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env['API_KEY']!,
    appId: dotenv.env['APP_ID']!,
    messagingSenderId: dotenv.env['SENDER_ID']!,
    projectId: dotenv.env['PROJECT_ID']!,
    storageBucket: "mixy2024-5dcf8.appspot.com",
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Create FirebaseAuth instance
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Create Firestore instance

  Future<void> storeUserId(String userId) async {
    await _firestore.collection('Users').doc(userId).set({});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mixy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // User is signed in, store their user ID in Firestore
              storeUserId(snapshot.data!.uid);
              return const MixyAppHomeScreen();
            } else {
              return SignInScreen();
            }
          }
        },
      ),
      routes: {
        '/signup': (context) => SignupScreen(),
        '/home': (context) => const MixyAppHomeScreen(),
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
