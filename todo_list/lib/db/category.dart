class Category {
  final String name;

  Category(
      {required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name
    };
  }
}
