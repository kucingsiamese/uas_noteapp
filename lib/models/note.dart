import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id; // ID yang dihasilkan oleh Firestore
  String title; // Judul catatan
  String content; // Isi catatan
  String category; // Kategori catatan (opsional)
  int? color; // Warna latar belakang catatan (opsional, sebagai integer)
  DateTime createdAt; // Waktu pembuatan catatan

  // Konstruktor untuk Note
  Note({
    this.id,
    required this.title,
    required this.content,
    this.category = 'Others',
    this.color,
    required this.createdAt,
  });

  // Konversi dari Map (Firestore) ke objek Note
  factory Note.fromFirestore(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String? ?? 'Others',
      color: json['color'] as int?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  // Konversi dari objek Note ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'color': color,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
