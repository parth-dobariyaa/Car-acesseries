class ConsultationRequest {
  final String id;
  final String clientName;
  final String email;
  final String phone;
  final String vehicleMakeModel;
  final String serviceInterest;
  final DateTime preferredDate;
  final String timeSlot;
  final String notes;
  final DateTime createdAt;

  ConsultationRequest({
    required this.id,
    required this.clientName,
    required this.email,
    required this.phone,
    required this.vehicleMakeModel,
    required this.serviceInterest,
    required this.preferredDate,
    required this.timeSlot,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
