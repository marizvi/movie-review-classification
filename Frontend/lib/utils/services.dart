import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// dio.options.headers["Access-Control-Allow-Credentials"] = true;
// dio.options.headers["Access-Control-Allow-Headers"] =
//     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale";
// dio.options.headers["Access-Control-Allow-Methods"] =
//     "GET, HEAD, POST, OPTIONS";

String url = "https://marizvi.pythonanywhere.com/predict";

Future<int> fetchScore({required String text}) async {
  Dio dio = Dio();
  final uri = Uri.parse(url);
  try {
    var response = await http.post(uri,
        body: json.encode({
          "phrase": [text]
        }),
        headers: {
          "Content-Type": "application/json",
        });
    print("response: ${response.body}");
    final data = json.decode(response.body);
    List<String> sentiments =
        (data["sentiment"] as List).map((e) => e.toString()).toList();
    print("sentiments: $sentiments");
    return int.parse(sentiments[0]);
    return 0;
  } catch (e) {
    print("error: ${e.toString()}");
    throw Exception("${e.toString()}");
  }
}
