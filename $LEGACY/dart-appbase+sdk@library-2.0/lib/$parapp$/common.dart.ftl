import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class Pagination {

  int total = 0;

  List<dynamic> data = [];

}

///!
/// Appbase http client is as base class for its sub-classes.
///
class AppbaseHttpClient {

  ///!
  /// global http host.
  ///
  static String _host = "";

  ///!
  /// global http headers.
  ///
  static Map<String, String> _headers = new HashMap();

  static void set host(String serverAddress) {
    _host = serverAddress;
  }

  static void addHeader({String key = "", String value = ""}) {
    _headers[key] = value;
  }

  ///
  /// Makes an http post request.
  ///
  Future<AppbaseHttpClientResponse> post({
    required String uri,
    required Map params,
    Map<String, String>? headers,
    AppbaseHttpClientCallback? callback}
  ) async {
    final Dio dio = new Dio(BaseOptions(baseUrl: _host));
    dio.options.headers["Content-Type"] = "application/json";

    /// set request headers
    if (headers != null) {
      headers.forEach((k,v) => dio.options.headers[k] = v);
    }
    _headers.forEach((k,v) => dio.options.headers[k] = v);

    try {
      final response = await dio.post(uri,
        data: jsonEncode(params),
      );
      final responseData = jsonDecode(response.data);
      if (responseData["error"] != null) {
        return AppbaseHttpClientResponse(
          error: AppbaseHttpClientError(
            code: responseData["error"]["code"],
            message: responseData["error"]["message"],
          )
        );
      } else if (responseData["total"] != null) {
        Pagination page = new Pagination();
        page.total = responseData["total"];
        page.data = responseData["data"];
        return AppbaseHttpClientResponse(
          data: page
        );
      } else {
        return AppbaseHttpClientResponse(
          data: responseData["data"]
        );
      }
    } on SocketException catch (e) {
      final error = AppbaseHttpClientError(
        code: -1,
        message: "网络访问异常！",
      );
      if (callback != null) {
        callback.onError!(error);
      }
      return AppbaseHttpClientResponse(
        error: error,
      );
    } on FormatException catch (_) {
      final error = AppbaseHttpClientError(
        code: -1,
        message: "服务器返回格式解析异常！",
      );
      if (callback != null) {
        callback.onError!(error);
      }
      return AppbaseHttpClientResponse(
        error: error,
      );
    } catch (e) {
      final error = AppbaseHttpClientError(
        code: -1,
        message: "发生系统错误！",
      );
      if (callback != null) {
        callback.onError!(error);
      }
      return AppbaseHttpClientResponse(
        error: error,
      );
    }
  }
}

///!
/// Appbase http client request callback.
/// 
class AppbaseHttpClientCallback {

  ///
  /// default constructor.
  ///
  const AppbaseHttpClientCallback({
    this.onError,
  });

  ///
  /// the error handler
  ///
  final AppbaseHttpClientErrorHandler? onError;
}

///!
/// Appbase http client error.
/// 
class AppbaseHttpClientError extends Error {

  ///
  /// default constructor.
  ///
  AppbaseHttpClientError({
    this.code = -1,
    this.message = "系统错误",
  });

  ///
  /// error code.
  ///
  final int? code;

  ///
  /// error message
  ///
  final String? message;

}

///!
/// Appbase http client response.
/// 
class AppbaseHttpClientResponse {

  ///
  /// default constructor.
  ///
  AppbaseHttpClientResponse({
    this.data,
    this.error,
  });

  ///
  /// error information if error occurred.
  ///
  final AppbaseHttpClientError? error;

  ///
  /// the business data from server.
  ///
  final dynamic? data;

  ///
  /// Checks if having error in response.
  ///
  bool get hasError => error != null;

  ///
  /// Gets the business data as list object.
  ///
  List<dynamic> getDataAsList() {
    return data as List<dynamic>;
  }

  ///
  /// Gets the business data as map object.
  ///
  Map getDataAsMap() {
    return data as Map;
  }

  Pagination getDataAsPagination() {
    return data as Pagination;
  }
}

typedef AppbaseHttpClientErrorHandler = void Function(AppbaseHttpClientError error);