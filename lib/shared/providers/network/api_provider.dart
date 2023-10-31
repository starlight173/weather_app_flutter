import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class APIProvider {
  final http.Client _client;

  APIProvider(this._client);

  Future<dynamic> get(String url) async {
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data from $url');
    }
  }

  Future<dynamic> post(String url, String body, String contentType) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': contentType,
      },
      body: body,
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data to $url');
    }
  }
}
