class Review {
  final String id;
  final double rating;
  final String comment;

  Review({required this.id, required this.rating, required this.comment});

  factory Review.fromMap(String id, Map<String, dynamic> data) {
    return Review(
      id: id,
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
    );
  }
}
