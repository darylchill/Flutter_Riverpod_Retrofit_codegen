import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_client.g.dart'; // Generated file for Retrofit

@RestApi()
abstract class ApiClient{
  factory ApiClient(Dio dio,{String baseUrl}) =_ApiClient;

  //ROUTES
  @POST('/register')
  Future<User> register(@Body() User user);

  @POST('/login')
  Future<LoginResponse> login(@Body() User user);

  @GET('/products')
  Future<List<Product>> getProducts();

  @POST('/products')
  Future<Product> addProduct(@Body() Product product);

  @POST('/productsUpdate')
  Future<Product> updateProduct(@Body() Product product);

  @POST('/productsDelete')
  Future<Product> deleteProduct(@Body() Product product);


  @POST('/logout')
  Future<String> logout();

}

@JsonSerializable()
class Product{
  final String productid;
  final String name;
  final String price;

  Product( {required this.productid,required this.name,required this.price});

  //JSON
factory Product.fromJson(Map<String,dynamic>json)=>_$ProductFromJson(json);

Map<String,dynamic>toJson()=>_$ProductToJson(this);
}

@JsonSerializable()
class User{
  final String email;
  final String password;

  User({required this.email,required this.password});

//JSON
factory User.fromJson(Map<String,dynamic>json)=>_$UserFromJson(json);
Map<String,dynamic>toJson()=>_$UserToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String password;
  final String token;
  final String date;

  LoginResponse( {required this.username, required this.email,required this.password,required this.firstname, required this.lastname,required this.date, required this.token,});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}