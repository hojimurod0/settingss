class Employee {
  String name;
  int age;
  String position;
  List<String> skills;

  Employee({
    required this.name,
    required this.age,
    required this.position,
    required this.skills,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    var skillsFromJson = json['skills'] as List;
    List<String> skillList = skillsFromJson.map((s) => s.toString()).toList();

    return Employee(
      name: json['name'],
      age: json['age'],
      position: json['position'],
      skills: skillList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'position': position,
      'skills': skills,
    };
  }
}
