import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:chat_app/chat_message.dart';
import 'package:flutter/animation.dart';
import 'dart:async';

class ChatApi {
  static const _baseUrl = 'https://chat.leaseshe.com';

  final Dio _dio = Dio();

  Stream<String> sendMessage(String message,{required TickerProvider vsync}) async* {
    try {
      Response<ResponseBody> response = await _dio.post<ResponseBody>(
        '$_baseUrl/chat-stream',
        data: {'message': message},
        options: Options(responseType: ResponseType.stream), // 设置接收类型为 `stream`
      );
     //print(response.data); // 响应流

      Stream<String> stream = utf8.decoder.bind(response.data!.stream).transform(const LineSplitter());  // 将响应体转换为流

      await for (String line in stream) {
        if (line.trim().isNotEmpty) {
          Map<String, dynamic> jsonResponse = jsonDecode(line);
          String content = _parseResponse(jsonResponse);
          print('Received from chat-stream: $content'); // 打印从chat-stream接收到的内容
          yield content;
        }
      }
    } on DioError catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  String _parseResponse(Map<String, dynamic> json) {
    return json['content'] ?? '';
  }
}