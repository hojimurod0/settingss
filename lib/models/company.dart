import 'package:vazifa4/models/employee.dart';
import 'package:vazifa4/models/producte.dart';

class Company {
  String company;
  String location;
  List<Employee> employees;
  List<Product> products;

  Company({
    required this.company,
    required this.location,
    required this.employees,
    required this.products,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    var employeesFromJson = json['employees'] as List;
    var productsFromJson = json['products'] as List;

    List<Employee> employeeList = employeesFromJson.map((e) => Employee.fromJson(e)).toList();
    List<Product> productList = productsFromJson.map((p) => Product.fromJson(p)).toList();

    return Company(
      company: json['company'],
      location: json['location'],
      employees: employeeList,
      products: productList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'location': location,
      'employees': employees.map((e) => e.toJson()).toList(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
