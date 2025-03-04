import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> pin;

  const DetailScreen({
    required this.pin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onPressed: () async {

                    try {
                      // Tampilkan dialog konfirmasi
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: Text(
                              'Konfirmasi Hapus',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              'Apakah Anda yakin ingin menghapus postingan ini?',
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      // Jika user mengkonfirmasi
                      if (confirm == true) {
                        // Hapus dokumen dari Firestore
                        await FirebaseFirestore.instance

                            .collection('posts')
                            .doc(pin['id'])
                            .delete();

                        // Kembali ke halaman sebelumnya
                        Navigator.pop(context);

                        // Tampilkan snackbar sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Postingan berhasil dihapus'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      // Tampilkan snackbar error jika terjadi kesalahan
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Terjadi kesalahan: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                },
              ),
            ],
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                pin['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pin['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(pin["user"])
                              .get(),
                          builder: (context, snapshot) => Text(
                            snapshot.data != null
                                ? snapshot.data?.get("username")
                                : "Loading...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          )),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Follow'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Penggunaan yang benar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     _buildActionButton(Icons.thumb_up, 'Like'),
                  //     _buildActionButton(Icons.comment, 'Comment'),
                  //     _buildActionButton(Icons.share, 'Share'),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}