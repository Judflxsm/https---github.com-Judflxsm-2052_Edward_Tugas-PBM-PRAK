import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PemainFormPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? data;

  const PemainFormPage({super.key, this.docId, this.data});

  @override
  State<PemainFormPage> createState() => _PemainFormPageState();
}

class _PemainFormPageState extends State<PemainFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _posisiController = TextEditingController();
  final _nomorController = TextEditingController();
  final _gajiController = TextEditingController();

  File? _image;
  String? _fotoUrl;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _namaController.text = widget.data!['nama'] ?? '';
      _posisiController.text = widget.data!['posisi'] ?? '';
      _nomorController.text = widget.data!['nomor'].toString();
      _gajiController.text = widget.data!['gaji'].toString();
      _fotoUrl = widget.data!['fotoUrl'];
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('pemain/$fileName.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl = _fotoUrl;

      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      final data = {
        'nama': _namaController.text,
        'posisi': _posisiController.text,
        'nomor': int.tryParse(_nomorController.text) ?? 0,
        'gaji': int.tryParse(_gajiController.text) ?? 0,
        'fotoUrl': imageUrl,
      };

      final collection = FirebaseFirestore.instance.collection('pemain');

      if (widget.docId == null) {
        await collection.add(data);
      } else {
        await collection.doc(widget.docId).update(data);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.docId == null ? 'Tambah Pemain' : 'Edit Pemain',
          style: const TextStyle(color: Colors.red),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.red),
            onPressed: _saveData,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  labelText: 'Nama Pemain',
                  labelStyle: TextStyle(color: Colors.red),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _posisiController,
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  labelText: 'Posisi',
                  labelStyle: TextStyle(color: Colors.red),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _nomorController,
                style: const TextStyle(color: Colors.red),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nomor Punggung',
                  labelStyle: TextStyle(color: Colors.red),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _gajiController,
                style: const TextStyle(color: Colors.red),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gaji (angka)',
                  labelStyle: TextStyle(color: Colors.red),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo, color: Colors.white),
                label: const Text('Pilih Foto', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              const SizedBox(height: 16),
              _image != null
                  ? Image.file(_image!, height: 250, fit: BoxFit.cover)
                  : _fotoUrl != null
                      ? Image.network(_fotoUrl!, height: 250, fit: BoxFit.cover)
                      : const Text('Belum ada gambar', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
