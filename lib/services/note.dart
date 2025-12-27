import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String title;
  String content;
  DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Safely parse updatedAt - handle null or missing field
    DateTime parsedUpdatedAt;
    if (data['updatedAt'] != null && data['updatedAt'] is Timestamp) {
      parsedUpdatedAt = (data['updatedAt'] as Timestamp).toDate();
    } else {
      parsedUpdatedAt = DateTime.now(); // Fallback to current time
    }
    
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      updatedAt: parsedUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

