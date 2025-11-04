class TodoModel {
  final String name;
  final DateTime createdat;

  TodoModel({required this.name, required this.createdat});

  @override
  String toString() {
    return 'TodoModel{name: $name, createdat: $createdat}';
  }
}
