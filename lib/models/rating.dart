import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String userId;
  final int movieId;
  final double value;
  final String? comment;
  final Timestamp timestamp;
  final String userName;
  final String? userPhotoUrl;

  Rating({
    required this.userId,
    required this.movieId,
    required this.value,
    this.comment,
    required this.timestamp,
    required this.userName,
    this.userPhotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'movieId': movieId,
      'value': value,
      'comment': comment,
      'timestamp': timestamp,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  factory Rating.fromFirestore(Map<String, dynamic> data) {
    return Rating(
      userId: data['userId'] as String? ?? '',
      movieId: data['movieId'] as int? ?? 0,
      value: (data['value'] as num? ?? 0.0).toDouble(),
      comment: data['comment'] as String?,
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
      userName: data['userName'] as String? ?? 'Usuário Anônimo',
      userPhotoUrl: data['userPhotoUrl'] as String?,
    );
  }
}
