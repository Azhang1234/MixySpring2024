import 'package:flutter/material.dart';

import 'fitness_app_home_screen.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.blueGrey,
//         appBar: AppBar(
//           title: Text('I am Rich'),
//           backgroundColor: Colors.blueGrey[900],
//         ),
//         body: Center(
//           child: Image(
//             image: NetworkImage(
//                 'https://www.imgacademy.com/sites/default/files/july2023timelinephoto.jpg'),
//           ),
//         ),
//       ),
//     ),
//   );
// }
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FitnessAppHomeScreen(), // Directly using it as the home screen
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
