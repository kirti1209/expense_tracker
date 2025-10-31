enum Category {
  food('Food', '🍕'),
  travel('Travel', '✈️'),
  bills('Bills', '📄'),
  shopping('Shopping', '🛍️'),
  entertainment('Entertainment', '🎬'),
  healthcare('Healthcare', '🏥'),
  other('Other', '📦');

  final String name;
  final String emoji;

  const Category(this.name, this.emoji);

  static List<Category> get all => values;
  
  static Category fromName(String name) {
    return values.firstWhere(
      (category) => category.name == name,
      orElse: () => Category.other,
    );
  }
}