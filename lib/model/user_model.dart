class AddressModel {
  final String addressId;
  final String label;
  final String address;
  final double? lat;
  final double? lng;

  AddressModel({
    required this.addressId,
    required this.label,
    required this.address,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() => {
    'addressId': addressId,
    'label': label,
    'address': address,
    'lat': lat,
    'lng': lng,
  };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    addressId: json['addressId'] as String? ?? '',
    label: json['label'] as String? ?? 'Home',
    address: json['address'] as String? ?? '',
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
  );
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profileImageUrl;
  final DateTime createdAt;

  final List<String> deviceTokens;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImageUrl,
    required this.createdAt,
    required this.deviceTokens,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'createdAt': createdAt.toIso8601String(),
    'metadata': {'deviceTokens': deviceTokens},
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    profileImageUrl: json['profileImageUrl'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    deviceTokens:
        ((json['metadata'] as Map<String, dynamic>? ?? const {})['deviceTokens']
                    as List<dynamic>? ??
                const [])
            .map((e) => e.toString())
            .toList(),
  );

  UserModel copyWith({bool? isSubscriptionPaid}) => UserModel(
    id: id,
    fullName: fullName,
    email: email,
    profileImageUrl: profileImageUrl,
    createdAt: createdAt,
    deviceTokens: deviceTokens,
  );
}
