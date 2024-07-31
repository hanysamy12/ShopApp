import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';
import '../models/categories_model.dart';
import '../models/favorites_model.dart';
import '../models/home_model.dart';
import '../models/search_model.dart';
import '../models/user_model.dart';


class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  //////Get Data Start
  HomeModel? homeModel;
  Map<int?, bool?> favorite = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: homeUrl, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //print(homeModel?.data?.products[0].image);
      //print(homeModel?.status.toString());
      homeModel?.data?.products.forEach((element) {
        favorite.addAll({element.id: element.inFavorite});
      });
      //print('favorite Map is $favorite');
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      emit(ShopErrorHomeDataState());
      //print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(ShopLoadingCategoriesState());
    DioHelper.getData(url: categoriesUrl).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      //print('category name is ${categoriesModel?.categoryData?.data[0].name}');
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      emit(ShopErrorCategoriesState());
    });
  }

  //////Get Data END

  //////Update favorite Start

  ChangeFavoritesModel? changeFavoriteModel;

  void updateFavorite(int productId) {
    favorite[productId] = !favorite[productId]!;
    //print('updated product $productId  ${favorite[productId]}');
    emit(ShopSuccessChangeFavoritesState());

    DioHelper.postData(
            url: favoritesUrl, data: {'product_id': productId}, token: token)
        .then((value) {
      changeFavoriteModel = ChangeFavoritesModel.fromJson(value.data);
      // print('favorite message ${changeFavoriteModel?.message}');

      showToast(
          text: '${changeFavoriteModel?.message}', state: ToastStates.success);

      if (changeFavoriteModel?.state != null && !changeFavoriteModel!.state!) {
        //null check and bool check
        favorite[productId] = !favorite[productId]!;
        showToast(
            text: '${changeFavoriteModel?.message}', state: ToastStates.error);
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState());
    }).catchError((error) {
      favorite[productId] = !favorite[productId]!;
      emit(ShopErrorChangeFavoritesState());
      showToast(text: error, state: ToastStates.success);
    });
  }

  //////Update favorite End

  //////Get favorite Start
  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingShowFavoritesState());
    DioHelper.getData(url: favoritesUrl, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //print('favorite model data $value.data');

      emit(ShopSuccessShowFavoritesState());
    }).catchError((error) {
      //print(error);
      emit(ShopErrorShowFavoritesState());
    });
  }

  //////Get favorite End

  //////Get UserData Start
  UserModel? usrDataModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(url: profileUrl, token: token).then((value) {
      emit(ShopSuccessUserDataState());
      usrDataModel = UserModel.fromJson(value.data);
      //print('user data = $value.data');
    }).catchError((error) {
      emit(ShopErrorUserDataState());
      //print('user data error =$error');
    });
  }

  //////Get UserData End

  ////Register Start
  UserModel? userModel;

  void addNewUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopLoadingRegisterState());
    DioHelper.postData(url: registerUrl, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      emit(ShopSuccessRegisterState());
      userModel = UserModel.fromJson(value.data);
      //print(userModel?.message);
      showToast(text: userModel!.message!, state: ToastStates.success);
    }).catchError((error) {
      emit(ShopErrorRegisterState());
      //print(error);
    });
  }

  ////Register End

  ////Update User Data Start
  UserModel? updateModel;

  void updateUser(
      {required String name, required String email, required String phone}) {
    emit(ShopLoadingUpdateState());
    DioHelper.putData(
      url: updateProfileUrl,
      data: {'name': name, 'email': email, 'phone': phone},
      token: token,
    ).then((value) {
      emit(ShopSuccessUpdateState());
      updateModel = UserModel.fromJson(value.data);
      //print('Update Data = ${value.data}');
      showToast(text: 'Update Completed', state: ToastStates.success);
    }).catchError((error) {
      emit(ShopErrorUpdateState());
      // print('Update User Error=$error');
    });
  }

  ////Update User Data End

  /////Search Products Start
  SearchModel? searchProductsModel;

  void searchProducts({required String searchText}) {
    emit(ShopLoadingSearchState());
    DioHelper.postData(url: productsSearchUrl,token: token, data: {'text': searchText})
        .then((value) {
          emit(ShopSuccessSearchState());
          searchProductsModel=SearchModel.fromJson(value.data);
          //print('Search Data = ${value.data}');
    })
        .catchError((error) {
          emit(ShopErrorSearchState());
         // print('Search Error = $error');
    });
  }

  /////Search Products End

  //////Bottom Nav Bar Start
  int currentIndex = 0;
  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];
  List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    const BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void changeBottomNavBar({required int index}) {
    currentIndex = index;
    emit(ShopChangeBottomNavBarState());
  }
//////Bottom Nav Bar Start
}
