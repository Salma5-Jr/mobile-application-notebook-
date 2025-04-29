import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook/navigation.dart';
import 'package:notebook/new_notes.dart';
import 'package:notebook/search_notes.dart'; // <-- Add this import


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notes", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () async{
final snapshot=await notes.get();
showSearch(context: context, delegate: NotesSearchDelegate(snapshot.docs),);
          }, icon: const Icon(Icons.search),
          color: Color.fromARGB(255, 238, 234, 234)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
        ],
        backgroundColor: Color.fromARGB(255, 8, 8, 8),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewNote()),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: const Navigation(),

      
      body: FutureBuilder<QuerySnapshot>(
        future: notes.get(),
        // orderBy('lastModified',descending:true).get(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No notes found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? 'No Title';
              final Content = data['content'] ?? 'No Content';

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(Content),

        
 onLongPress: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await docs[index].reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting note: $e')),
        );
      }
    }
      
                    }        ));
            },
          );
        },
      ),
    );
  }
}
