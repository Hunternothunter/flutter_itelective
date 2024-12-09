class Module {
  final String title;
  final String content;
  final String codeExample;

  Module({
    required this.title,
    required this.content,
    required this.codeExample,
  });

  // Factory method to create a Module from a Map
  factory Module.fromMap(Map<String, dynamic> data) {
    return Module(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      codeExample: data['codeExample'] ?? '',
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final List<Module> modules;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.modules,
  });

  factory Course.fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      instructor: data['instructor'] ?? '',
      modules: (data['modules'] as List<dynamic>?)
              ?.map((module) => Module.fromMap(module as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
