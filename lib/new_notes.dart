
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _seletedImage;
  File? _seletedAudio;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    // _imageController.dispose();
    // _AudioController.dispose();
    super.dispose();
  }

  Future<void> _saveNoteToFirestore() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

 try {
    Future<String?> uploadImage() async {
      if (_seletedImage == null) return null;
      final ref = FirebaseStorage.instance
          .ref('notes/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(_seletedImage!);
      await uploadTask; // Wait for upload to complete
      return await ref.getDownloadURL();
    }

    Future<String?> uploadAudio() async {
      if (_seletedAudio == null) return null;
      final ref = FirebaseStorage.instance
          .ref('notes/audios/${DateTime.now().millisecondsSinceEpoch}.mp3');
      final uploadTask = ref.putFile(_seletedAudio!);
      await uploadTask;
      return await ref.getDownloadURL();
    }

    final results = await Future.wait([
      uploadImage(),
      uploadAudio(),
    ]);

    final imageUrl = results[0];
    final audioUrl = results[1];

    await FirebaseFirestore.instance.collection('notes').add({
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isSaving = false;
      _seletedImage = null;
      _seletedAudio = null;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved successfully!')),
    );
  } catch (e) {
    setState(() => _isSaving = false);
    print("Error saving note: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to save note.')),
    );
  }
}

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                    // imageQuality: 10);
                if (image != null) {
                  setState(() => _seletedImage = File(image.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                    // imageQuality: 10);
                if (image != null) {
                  setState(() => _seletedImage = File(image.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.audiotrack),
              title: Text('Pick Audio'),
              onTap: () async {
                Navigator.pop(context);
                final result =
                    await FilePicker.platform.pickFiles(type: FileType.audio);
                if (result != null && result.files.single.path != null) {
                  setState(() => _seletedAudio = File(result.files.single.path!));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: _isSaving ? null : _saveNoteToFirestore,
            icon: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
          IconButton(
            color: Colors.white,
            onPressed: _showAttachmentOptions,
            icon: const Icon(Icons.attach_file),
          ),
        ],
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: "Title"),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromARGB(255, 241, 240, 240),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
                if (_seletedImage != null) ...[
                  const SizedBox(height: 8),
                  Image.file(_seletedImage!),
                ],
                if (_seletedAudio != null) ...[
                  const SizedBox(height: 8),
                  Text('Audio file selected: ${_seletedAudio!.path.split('/').last}'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}