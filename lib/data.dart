import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Data extends StatelessWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
CollectionReference notes = FirebaseFirestore.instance.collection("notes");

     return Scaffold(
      appBar: AppBar(title: const Text('notes list')),
      body: FutureBuilder<QuerySnapshot>(
        future: notes.get(), // 👈 This fetches data ONE TIME
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              var user = userDocs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(user['name'] ?? 'No name'),
                subtitle: Text(user['content'] ?? 'No content'),
                 leading: user['imageUrl'] != null
                          ? Image.network(user['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image),
                      trailing: user['audioUrl'] != null
                          ? IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                // Later you can implement audio playing functionality here
                              },
                
    
              )
              :const Icon(Icons.audiotrack),
              
              );
            },
          );
        },
      ),
    );
  }
}
  
