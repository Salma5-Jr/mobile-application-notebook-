import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesSearchDelegate extends SearchDelegate {
  final List<QueryDocumentSnapshot> notes;

  NotesSearchDelegate(this.notes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title'] ?? '';
      return title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final data = results[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['title'] ?? ''),
          subtitle: Text(data['content'] ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title'] ?? '';
      return title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final data = suggestions[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['title'] ?? ''),
          onTap: () {
            query = data['title'] ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}