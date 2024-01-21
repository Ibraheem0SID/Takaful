import 'dart:convert';
import 'dart:io';
import 'package:data_table_try/util/exeptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'local_storage.dart';
import 'package:data_table_try/util/simplifies_uri.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiBase {
  final String _baseUrl = "http://139.59.96.46/api/";
  late Map<String, String> globalHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer ${Prefs().token}"
  };

  Future<dynamic> get(
      {String? url, dynamic queryParameters, String? fullUrl}) async {
    var responseJson;
    final Uri uri = SimplifiedUri.uri(
        (fullUrl == null) ? _baseUrl + url! : fullUrl,
        (fullUrl == null) ? queryParameters : null);
    try {
      final response = await http.get(uri, headers: globalHeaders);
      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
          msg: "لا يوجد اتصال بالانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return responseJson;
  }

  Future<dynamic> post(
      {required String url,
      dynamic body,
      bool containHeaders = true,
      bool contentType = false}) async {
    var responseJson;
    final headers = globalHeaders;
    if (contentType == false) {
      headers.remove("Content-Type");
    }
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + url),
        body: body,
        headers: containHeaders ? headers : null,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
          msg: "لا يوجد اتصال بالانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return responseJson;
  }

  Future<dynamic> put({required String url, dynamic body}) async {
    var responseJson;
    final headers = globalHeaders;
    headers.remove("Content-Type");
    try {
      final response = await http.put(Uri.parse(_baseUrl + url),
          body: body, headers: globalHeaders);
      responseJson = _returnResponse(response);
      print(response.body);
    } on SocketException {
      Fluttertoast.showToast(
          msg: "لا يوجد اتصال بالانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return responseJson;
  }

  Future<dynamic> delete({required String url, dynamic body}) async {
    var responseJson;
    try {
      final response = await http.delete(Uri.parse(_baseUrl + url),
          body: body, headers: globalHeaders);
      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
          msg: "لا يوجد اتصال بالانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return responseJson;
  }

  Future<dynamic> patch(
      {required String url, dynamic body, bool contentType = false}) async {
    var responseJson;
    final headers = globalHeaders;
    print(headers);
    if (contentType == false) {
      headers.remove("Content-Type");
    }
    try {
      final response = await http.patch(Uri.parse(_baseUrl + url),
          body: body, headers: headers);
      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
          msg: "لا يوجد اتصال بالانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 204:
        Fluttertoast.showToast(
            msg: "تم التعديل على البيانات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
        break;

      case 400:
        Fluttertoast.showToast(
            msg: json.decode(response.body.toString())["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
