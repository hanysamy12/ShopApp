class ChangeFavoritesModel{
  bool? state;
  String? message;
  ChangeFavoritesModel.fromJson(Map<String,dynamic>json){
    state=json['status'];
    message=json['message'];
  }
}