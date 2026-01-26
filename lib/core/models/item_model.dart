class ItemModel {
  final String id;
  final String? name;
  final String? brand;
  final String? description;
  final List<String>? images;
  final List<String>? composition;
  final Map<String, String>? indicatingComposition;
  final List<String>? advantages;
  final List<String>? application;
  final String? manufacture;

  ItemModel({
    required this.id,
    this.name,
    this.brand,
    this.description,
    this.images,
    this.composition,
    this.indicatingComposition,
    this.advantages,
    this.application,
    this.manufacture,
  });


  Map<String, dynamic> toMap() => {
    'Name': name,
    'Brand': brand,
    'Description': description,
    'ImageUrls': images,
    'Composition': composition,
    'Indicative Composition': indicatingComposition,
    'Advantages': advantages,
    'Application': application,
    'Manufactures': manufacture,
  };


  factory ItemModel.fromMap(String id, Map<String, dynamic> map) {
    return ItemModel(
      id: id,
      name: map['Name'] ?? '',
      brand: map['Brand'] ?? '',
      description: map['Description'] ?? '',
      images: List<String>.from(map['ImageUrls'] ?? []),
      composition: List<String>.from(map['Composition'] ?? []),
      indicatingComposition:
      Map<String, String>.from(map['Indicative Composition'] ?? {}),
      advantages: List<String>.from(map['Advantages'] ?? []),
      application: List<String>.from(map['Application'] ?? []),
      manufacture: map['Manufactures'] ?? ''
    );
  }

}