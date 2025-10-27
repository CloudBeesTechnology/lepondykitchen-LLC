class ModuleModel {
  final String name;
  final String image;
  final String route;

  ModuleModel({required this.name, required this.image, required this.route});

  ModuleModel.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        route = data['route'],
        image = data['image'];
}
