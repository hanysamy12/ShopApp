class CategoriesModel {
  bool? status;
  CategoriesDataModel? categoryData;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    categoryData = CategoriesDataModel.fromJson(
      json['data'],
    );
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel> data = [];

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    data = List<DataModel>.from(
        json['data'].map((data1) => DataModel.fromJson(data1)));
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
