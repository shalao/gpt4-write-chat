import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:chat_app/chat_message.dart';
import 'package:flutter/animation.dart';
import 'dart:convert';
import 'dart:async';
class ChatApi {
  static const _baseUrl = 'https://chat.leaseshe.com';

  final Dio _dio = Dio();

  Stream<String> sendMessage(String message, {required TickerProvider vsync}) async* {
    try {
      Response response = await _dio.post(
        '$_baseUrl/chat-stream',
        data: {'message': message},
      );
      String responseBody = response.data;
      List<String> lines = responseBody.split('\n');

      String concatenatedContent = "";

      for (String line in lines) {
        if (line.trim().isNotEmpty) {
          Map<String, dynamic> jsonResponse = jsonDecode(line);
          String content = _parseResponse(jsonResponse);
          concatenatedContent += content;
        }
      }
      yield concatenatedContent;

    } on DioError catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  String _parseResponse(Map<String, dynamic> json) {
    return json['content'] ?? '';
  }
}
