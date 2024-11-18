class Tip {
  final int id;
  final String category;
  final String title;
  final String student;
  final String description;

  Tip({
    required this.id,
    required this.category,
    required this.title,
    required this.student,
    required this.description,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      student: json['student'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'student': student,
      'description': description,
    };
  }
}
