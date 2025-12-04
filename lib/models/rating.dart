class Rating {
  final String userId;
  final int movieId;
  final double value;
  final String? comment;
  final DateTime timestamp;
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
      'timestamp': timestamp.toIso8601String(),
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['user_id']?.toString() ?? '',
      movieId: json['movie_id'] ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      userName: json['userName'] ?? json['user_name'] ?? 'Anônimo',
      userPhotoUrl: json['userPhotoUrl'] ?? json['user_photo_url'],
    );
  }
}
