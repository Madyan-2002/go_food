class MealModel {
  final String? id;
  final String img;
  final String name;
  final double price;
  final String description;
  bool isFav;
  final String category;

  MealModel({
     this.id,
    required this.img,
    required this.name,
    required this.price,
    required this.description,
    this.isFav = false,
    required this.category,
  });

  //copywith method
  MealModel copyWith({
    String? id,
    String? img,
    String? name,
    double? price,
    String? description,
    bool? isFav,
    String? category,
  }) {
    return MealModel(
      id: id ?? this.id,
      img: img ?? this.img,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      isFav: isFav ?? this.isFav,
      category: category ?? this.category,
    );
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'img': img,
    };
  }

  //fromMap
  factory MealModel.fromMap(Map<String, dynamic> map ,String docID) {
    return MealModel(
      id: map['id'],
      img: map['img'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      description: map['description'],
      category: map['category'],
    );
  }
}

List<MealModel> meals = [
  MealModel(
    name: "Curly Fries",
    img: "assets/meal/f1.jpg",
    price: 5.99,
    isFav: false,
    category: 'Frise',
    description:
        "Delicious curly fries topped with melted cheese sauce, perfect as a snack or side dish perfect as a snack or side dishperfect as a snack or side dishperfect as a snack or side dish.",
  ),
  MealModel(
    name: "Cheese Burger",
    img: "assets/meal/b2.jpg",
    price: 8.99,
    isFav: false,
    category: 'Burger',
    description:
        "Juicy beef patty topped with extra cheese, lettuce, tomato, and our special sauce, served on a toasted bun.",
  ),
  MealModel(
    name: "Grilled Chicken",
    img: "assets/meal/c1.jpg",
    price: 10.99,
    isFav: false,
    category: 'Burger',
    description:
        "Tender grilled chicken breast served with a side of fresh vegetables, seasoned to perfection.",
  ),
  MealModel(
    name: "Burger Caesar ",
    img: "assets/meal/b1.jpg",
    price: 6.99,
    isFav: false,
    category: 'Burger',
    description:
        "Crisp romaine lettuce tossed with Caesar dressing, topped with crunchy croutons and Parmesan cheese.",
  ),
];
