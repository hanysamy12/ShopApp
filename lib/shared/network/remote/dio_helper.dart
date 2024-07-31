import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        // headers: {'Content-Type': 'application/json'},
      ),
    );
  }

//  GET DATA FROM URL
  static Future<Response> getData({
    required String url, //PATH
    Map<String, dynamic>? query, //QUERY
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? ''
    }; // to control lang
    return await dio.get(url, queryParameters: query);
  }

//  BUT DATA IN URL
  static Future<Response> postData(
      {required String url, //PATH
      Map<String, dynamic>? query, //QUERY
      required Map<String, dynamic> data,
      String? lang = 'en',
      String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    }; // to control lang
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? lang,
    String? token,
  }) async {
    dio.options.headers={
      'lang':lang,
      'Content-Type':'application/json',
      'Authorization':token,
    };
    return await dio.put(url, queryParameters: query, data: data);
  }
}