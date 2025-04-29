import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notebook/firebase_options.dart';
import 'package:notebook/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AllNotes());
}

class AllNotes extends StatelessWidget {
  const AllNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: HomePage(),
    );
  }
}
