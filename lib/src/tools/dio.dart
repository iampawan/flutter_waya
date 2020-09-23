import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_waya/flutter_waya.dart';

//网络链接超时时间
const int HTTP_TIMEOUT_CONNECT = 5000;
//接收超时时间
const int HTTP_TIMEOUT_RECEIVE = 10000;
//请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const List<String> HTTP_CONTENT_TYPE = <String>[
  'application/x-www-form-urlencoded',
  'multipart/form-data',
  'application/json',
  'text/xml'
];

class DioTools {
  //单例模式
  factory DioTools() => getHttp();

  DioTools.internal({BaseOptions options, CookieJar cookieJar}) {
    _dio = Dio();
    if (options != null) {
      _options = _dio.options;
      _options.connectTimeout = options?.connectTimeout ?? HTTP_TIMEOUT_CONNECT;
      _options.receiveTimeout = options?.receiveTimeout ?? HTTP_TIMEOUT_RECEIVE;
      _options.contentType = options?.contentType ?? HTTP_CONTENT_TYPE[2];
      _options.responseType = options?.responseType ?? ResponseType.json;
      _options.headers = options?.headers;
    }
    _interceptorWrap = InterceptorWrap(cookieJar);
    _dio.interceptors.add(_interceptorWrap);
  }

  Dio _dio;
  DioError _error;
  final CancelToken _cancelToken = CancelToken();
  BaseOptions _options;
  InterceptorWrap _interceptorWrap;

  ///安装  cookie_jar  cookieJar:CookieJar()
  static DioTools getHttp({BaseOptions options, CookieJar cookieJar}) {
    return DioTools.internal(options: options, cookieJar: cookieJar);
  }

  Future<dynamic> get(String url, {Map<String, dynamic> params}) async {
    try {
      log('GET url:' + url + '  params:' + params.toString());
      final Response<dynamic> response =
          await _dio.get<dynamic>(url, queryParameters: params, cancelToken: _cancelToken);
      log('GET url:' + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e as DioError;
      return jsonDecode(_error.message);
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic> params, dynamic data}) async {
    try {
      log('POST url:' + url + '  params:' + params.toString() + '  data:' + data.toString());
      final Response<dynamic> response =
          await _dio.post<dynamic>(url, queryParameters: params, data: data, cancelToken: _cancelToken);
      log('POST url:' + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e as DioError;
      return jsonDecode(_error.message);
    }
  }

  Future<dynamic> put(String url, {Map<String, dynamic> params, dynamic data}) async {
    try {
      log('PUT url:' + url + '  params:' + params.toString() + '  data:' + data.toString());
      final Response<dynamic> response =
          await _dio.put<dynamic>(url, data: data, queryParameters: params, cancelToken: _cancelToken);
      log('PUT url:' + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e as DioError;
      return jsonDecode(_error.message);
    }
  }

  Future<dynamic> delete(String url, {Map<String, dynamic> params, dynamic data}) async {
    try {
      log('DELETE url:' + url + '  params:' + params.toString() + '  data:' + data.toString());
      final Response<dynamic> response =
          await _dio.delete<dynamic>(url, queryParameters: params, data: data, cancelToken: _cancelToken);
      log('DELETE url:' + url + '  responseData==  ' + response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      _error = e as DioError;
      return jsonDecode(_error.message);
    }
  }

  //下载文件需要申请文件储存权限
  Future<void> download(String url, String savePath, [ProgressCallback onReceiveProgress]) async {
    try {
      log('Download url:' + url + '  savePath:' + savePath.toString());
      return await Dio().download(url, savePath, cancelToken: _cancelToken,
          onReceiveProgress: (int received, int total) {
        onReceiveProgress(received, total);
      });
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> upload<T>(String url,
      {Map<String, dynamic> params,
      dynamic data,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    try {
      log('Upload url:' + url + '  params:' + params.toString() + '  data:' + data.toString());
      return await Dio().post<dynamic>(url,
          queryParameters: params,
          data: data,
          cancelToken: _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } catch (e) {
      return e;
    }
  }

  void cancel() => _cancelToken.cancelError;
}

class InterceptorWrap extends InterceptorsWrapper {
  InterceptorWrap(this.cookieJar);

  final CookieJar cookieJar;
  final ResponseModel responseModel = ResponseModel();

  @override
  Future<void> onRequest(RequestOptions options) async {
    /// 在请求被发送之前做一些事情
    /// 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    /// 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    /// 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    /// 这样请求将被中止并触发异常，上层catchError会被调用。 return options;
    if (cookieJar != null) {
      final List<Cookie> cookies = cookieJar?.loadForRequest(options.uri);
      cookies.removeWhere((Cookie cookie) {
        if (cookie.expires != null) return cookie.expires.isBefore(DateTime.now());
        return false;
      });
      final String cookie = getCookies(cookies);
      if (cookie.isNotEmpty) options.headers[HttpHeaders.cookieHeader] = cookie;
    }
  }

  @override
  Future<dynamic> onResponse(Response<dynamic> response) async {
    if (cookieJar != null) saveCookies(response, responseModel);
    responseModel.statusCode = response.statusCode;
    if (response.statusCode == 200) {
      responseModel.statusMessage = 'success';
      responseModel.statusMessageT = 'success';
      if (response.data is Map || jsonDecode(response.data as String) is Map) {
        responseModel.data = response.data;
        return responseModel.toMap();
      } else {
        responseModel.data = response.data;
        return responseModel.toMap();
      }
    } else {
      responseModel.statusCode = response.statusCode;
      responseModel.statusMessage = response.statusMessage;
      responseModel.statusMessageT = response.statusMessage;
      return responseModel;
    }
  }

  @override
  Future<dynamic> onError(DioError err) async {
    responseModel.type = err.type.toString();
    if (err.type == DioErrorType.DEFAULT) {
      responseModel.statusCode = ConstConstant.errorCode404;
      responseModel.statusMessage = ConstConstant.errorMessage404;
      responseModel.statusMessageT = ConstConstant.errorMessageT404;
    } else if (err.type == DioErrorType.CANCEL) {
      responseModel.statusCode = ConstConstant.errorCode420;
      responseModel.statusMessage = ConstConstant.errorMessage420;
      responseModel.statusMessageT = ConstConstant.errorMessageT420;
    } else if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode408;
      responseModel.statusMessage = ConstConstant.errorMessage408;
      responseModel.statusMessageT = ConstConstant.errorMessageT408;
    } else if (err.type == DioErrorType.RECEIVE_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode502;
      responseModel.statusMessage = ConstConstant.errorMessage502;
      responseModel.statusMessageT = ConstConstant.errorMessageT502;
    } else if (err.type == DioErrorType.SEND_TIMEOUT) {
      responseModel.statusCode = ConstConstant.errorCode450;
      responseModel.statusMessage = ConstConstant.errorMessage450;
      responseModel.statusMessageT = ConstConstant.errorMessageT450;
    } else if (err.type == DioErrorType.RESPONSE) {
      responseModel.statusCode = err.response.statusCode;
      responseModel.statusMessage = ConstConstant.errorMessage500 + err.response.statusCode.toString();
      responseModel.statusMessageT = ConstConstant.errorMessageT500;
    }
    return jsonEncode(responseModel.toMap());
  }

  void saveCookies(Response<dynamic> response, ResponseModel responseModel) {
    if (response != null && response.headers != null) {
      final List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
      responseModel.cookie = cookies;
      if (cookies != null) {
        cookieJar.saveFromResponse(
          response.request.uri,
          cookies.map((String str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }
    }
  }

  static String getCookies(List<Cookie> cookies) =>
      cookies.map((Cookie cookie) => '${cookie.name}=${cookie.value}').join('; ');
}
