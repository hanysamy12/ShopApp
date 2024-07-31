class HomeModel {
  bool? status;

  HomeDataModel? data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(
      json['data'],
    );
  }
}

/*class HomeDataModel {
  List<BannersModel> banners=[];
  List<ProductsModel> products=[];

  //String? ads;
  HomeDataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(element);
    });
    json['products'].forEach((element) {
      products.add(element);
    });
  }
}*/
class HomeDataModel {
  List<BannersModel> banners = [];
  List<ProductsModel> products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = List<BannersModel>.from(
          json['banners'].map((banner) => BannersModel.fromJson(banner)));
    }

    if (json['products'] != null) {
      products = List<ProductsModel>.from(
          json['products'].map((product) => ProductsModel.fromJson(product)));
    }
  }
}

class BannersModel {
  int? id;
  String? image;

  //bool? categories;
  //bool? products;
  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;

  //String? description;
  //List<String?> images=[];
  bool? inFavorite;
  bool? inCart;

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorite = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
