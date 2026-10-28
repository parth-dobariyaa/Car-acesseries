class Accessory {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double price;
  final double rating;
  final int reviewsCount;
  final String badge;
  final String description;
  final List<String> highlights;
  final Map<String, String> specifications;
  final bool isFeatured;
  final String iconType; // e.g. 'steering', 'carbon', 'exhaust', 'lighting', 'audio', 'key', 'seat', 'wheel'

  const Accessory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.badge,
    required this.description,
    required this.highlights,
    required this.specifications,
    this.isFeatured = false,
    required this.iconType,
  });
}
