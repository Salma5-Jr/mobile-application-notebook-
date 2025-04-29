import 'package:flutter/material.dart';
import 'package:notebook/deletedata.dart';
import 'package:notebook/home_page.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(color: const Color.fromARGB(255, 243, 241, 241),width: 200,
          child: Column(
      children: [const SizedBox(height: 80,),
          TextButton.icon(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()) );
              },
            icon: const Icon(Icons.note),
            label: const Text("All notes"),
          ),
      TextButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Deletedata()));
            },
            icon: const Icon(Icons.delete),
            label: const Text("Trash"),
          // ),TextButton.icon(
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          //   },
          //   icon: const Icon(Icons.folder),
          //   label: const Text("folders"),
           ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            label: const Text("settings"),
          )],
    ),
        ));
  }
}
