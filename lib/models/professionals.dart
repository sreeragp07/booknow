class Professional {
  final String id;
  final String name;
  final double experience;
  final double rating;
  final double pricePerHour;
  final bool availabilityStatus;
  final String categoryId;
  final String categoryName;

  Professional({
    required this.id,
    required this.name,
    required this.experience,
    required this.rating,
    required this.pricePerHour,
    required this.availabilityStatus,
    required this.categoryId,
    required this.categoryName,
  });

  factory Professional.fromMap(String id, Map<String, dynamic> data) {
    return Professional(
      id: id,
      name: data['name'] ?? '',
      experience: (data['experience'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      pricePerHour: (data['pricePerHour'] ?? 0).toDouble(),
      availabilityStatus: data['availabilityStatus'] ?? false,
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
    );
  }
}
