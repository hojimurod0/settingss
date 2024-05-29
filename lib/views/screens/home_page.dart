import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vazifa4/models/company.dart';
import 'package:vazifa4/models/employee.dart';
import 'package:vazifa4/models/producte.dart'; // Ensure correct file name

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Company company;

  @override
  void initState() {
    super.initState();
    String jsonString = '''{
      "company": "Tech Solutions",
      "location": "San Francisco",
      "employees": [
        {
          "name": "Alice",
          "age": 30,
          "position": "Developer",
          "skills": ["Dart", "Flutter", "Firebase"]
        },
        {
          "name": "Bob",
          "age": 25,
          "position": "Designer",
          "skills": ["Photoshop", "Illustrator"]
        }
      ],
      "products": [
        {
          "name": "Product A",
          "price": 29.99,
          "inStock": true
        },
        {
          "name": "Product B",
          "price": 49.99,
          "inStock": false
        }
      ]
    }''';

    final mapData = jsonDecode(jsonString);
    company = Company.fromJson(mapData);
  }

  void addEmployee(Employee employee) {
    setState(() {
      company.employees.add(employee);
    });
  }

  void deleteEmployee(int index) {
    setState(() {
      company.employees.removeAt(index);
    });
  }

  void editEmployee(int index, Employee updatedEmployee) {
    setState(() {
      company.employees[index] = updatedEmployee;
    });
  }

  void addProduct(Product product) {
    setState(() {
      company.products.add(product);
    });
  }

  void deleteProduct(int index) {
    setState(() {
      company.products.removeAt(index);
    });
  }

  void editProduct(int index, Product updatedProduct) {
    setState(() {
      company.products[index] = updatedProduct;
    });
  }

  void showAddEmployeeDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController skillsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Position'),
              ),
              TextField(
                controller: skillsController,
                decoration: const InputDecoration(
                    labelText: 'Skills (comma separated)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                List<String> skills = skillsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .toList();
                Employee newEmployee = Employee(
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  position: positionController.text,
                  skills: skills,
                );
                addEmployee(newEmployee);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showAddProductDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    bool inStock = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    title: const Text('In Stock'),
                    value: inStock,
                    onChanged: (value) {
                      setState(() {
                        inStock = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Product newProduct = Product(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      inStock: inStock,
                    );
                    addProduct(newProduct);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditProductDialog(Product product) {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    bool inStock = product.inStock;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    title: const Text('In Stock'),
                    value: inStock,
                    onChanged: (value) {
                      setState(() {
                        inStock = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Product updatedProduct = Product(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      inStock: inStock,
                    );
                    editProduct(
                        company.products.indexOf(product), updatedProduct);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Info')),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(company.company),
              subtitle: Text('Location: ${company.location}'),
            ),
          ),
          ...company.employees.map((employee) {
            return Card(
              child: ListTile(
                title: Text(employee.name),
                subtitle: Text(
                    'Age: ${employee.age}, Position: ${employee.position}'),
                isThreeLine: true,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:
                      employee.skills.map((skill) => Text(skill)).toList(),
                ),
              ),
            );
          }).toList(),
          ...company.products.map((product) {
            return Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(
                    'Price: \$${product.price}, In Stock: ${product.inStock}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showEditProductDialog(product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteProduct(company.products.indexOf(product));
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showAddEmployeeDialog,
            child: const Icon(Icons.person_add),
            heroTag: null,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: showAddProductDialog,
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
