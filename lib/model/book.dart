const String tableBooks = 'books';

class BookFields {
  static final List<String> values = [
    id, title, description, createdTime, bookImage
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdTime = 'createdTime';
  static const String bookImage = 'bookImage';
}

class Book {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  final String bookImage;

  const Book({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.bookImage
  });

  Map<String, Object?> toJson() => {
    BookFields.id: id,
    BookFields.title: title, 
    BookFields.description: description,
    BookFields.bookImage: bookImage,
    BookFields.createdTime: createdTime.toIso8601String(),
  };

  static Book fromJson(Map<String, Object?> json) => Book(
    id: json[BookFields.id] as int?,
    title: json[BookFields.title] as String,
    description: json[BookFields.description] as String,
    bookImage: json[BookFields.bookImage] as String,
    createdTime: DateTime.parse(json[BookFields.createdTime] as String)
  );

  Book copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
    String? bookImage
  }) => Book(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    createdTime: createdTime ?? this.createdTime,
    bookImage: bookImage ?? this.bookImage
  );
}