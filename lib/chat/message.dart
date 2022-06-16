import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  final String sentBy;
  final String message;
  final String time;
  final String? date;

  Message({
    required this.sentBy,
    required this.message,
    required this.time,
    this.date
  });

  factory Message.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Message(
      sentBy: data?['sentBy'] as String,
      message: data?['message'] as String,
      date: DateFormat('dd MMM yyyy').format((data?['time'] as Timestamp).toDate()),
      time: DateFormat('hh:mm a').format((data?['time'] as Timestamp).toDate()).toLowerCase()
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sentBy': sentBy,
      'message': message,
      'time': Timestamp.fromDate(DateTime.now())
    };
  }
}