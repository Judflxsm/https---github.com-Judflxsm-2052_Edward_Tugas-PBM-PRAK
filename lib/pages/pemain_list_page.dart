import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'pemain_form_page.dart';

class PemainListPage extends StatelessWidget {
  const PemainListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/mu.png', height: 30),
            const SizedBox(width: 8),
            const Text("Manchester United Player"),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pemain').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            padding: const EdgeInsets.all(8),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: data['fotoUrl'] != null
                    ? Image.network(data['fotoUrl'], width: 70, height: 70, fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 70, color: Colors.red),
                  title: Text("Nama: ${data['nama']}"),
                  subtitle: Text("Posisi: ${data['posisi']}\nNomor: ${data['nomor']} - Gaji: Rp ${data['gaji']}"),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PemainFormPage(docId: doc.id, data: data),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('pemain').doc(doc.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PemainFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}