import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Deletedata extends StatelessWidget {
  const Deletedata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 5, 5, 5),
        title: Text("Trash", style: TextStyle(color: Colors.white),),
      ),

body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('deletedAt', isNotEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          final now = DateTime.now();

          final deletedNotes = docs.where((doc) {
            final deletedAt = (doc['deletedAt'] as Timestamp).toDate();
            return now.difference(deletedAt).inDays <= 30;
          }).toList();

          if (deletedNotes.isEmpty) {
            return const Center(child: Text('No deleted notes.'));
          }

          return ListView.builder(
            itemCount: deletedNotes.length,
            itemBuilder: (context, index) {
              final note = deletedNotes[index];
              return ListTile(
                title: Text(
                  note['content'],
                  style: const TextStyle(color: Colors.grey), // faded look
                ),
                subtitle: Text('Deleted: ${note['deletedAt'].toDate()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .doc(note.id)
                        .delete(); // permanently delete
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
