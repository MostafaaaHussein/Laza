class Address {
  final String fullName;
  final String phone;
  final String city;
  final String area;
  final String street;
  final String building;
  final String floor;
  final String notes;

  Address({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.area,
    required this.street,
    required this.building,
    required this.floor,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'area': area,
      'street': street,
      'building': building,
      'floor': floor,
      'notes': notes,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      area: map['area'] ?? '',
      street: map['street'] ?? '',
      building: map['building'] ?? '',
      floor: map['floor'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
