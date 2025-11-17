class Listing {
  final int id;
  final String userId;
  final double price;
  final int structureId;
  final int floor;
  final String vehicleId;  
  final String? comment;

  Listing({
    required this.id,
    required this.userId,
    required this.price,
    required this.structureId,
    required this.floor,
    required this.vehicleId,
    this.comment,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      price: (json['price'] as num).toDouble(),
      structureId: json['structure_id'] as int,
      floor: json['floor'] as int,
      vehicleId: json['vehicle_id'] as String,
      comment: json['comment'] as String?,
    );
  }
}
