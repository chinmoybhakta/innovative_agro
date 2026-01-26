class ContactModel {
  final String id;
  final String? address;
  final List<String>? phone;
  final String? email;
  final String? facebookUrl;
  final String? whatsapp;

  ContactModel({
    required this.id,
    this.address,
    this.phone,
    this.email,
    this.facebookUrl,
    this.whatsapp,
  });

  Map<String, dynamic> toMap() {
    return {
      'Address': address,
      'Phone': phone,
      'Email': email,
      'FacebookUrl': facebookUrl,
      'Whatsapp': whatsapp,
    };
  }

  factory ContactModel.fromMap(String id, Map<String, dynamic> map) {
    return ContactModel(
      id: id,
      address: map['Address'],
      phone: List<String>.from(map['Phone'] ?? []),
      email: map['Email'],
      facebookUrl: map['FacebookUrl'],
      whatsapp: map['Whatsapp'],
    );
  }
}
