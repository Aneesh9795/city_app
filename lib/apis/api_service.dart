import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';

class ApiService {
  static Future<List<CityModel>> fetchCities(String keyword) async {
    final url = Uri.parse("https://superastrologer.com/apis/v1/customer/city/listdata");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"keyword": keyword, "page_no": "1"}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? [];
      return data.map((e) => CityModel.fromJson(e)).toList();
    } else {
      throw Exception("City API failed");
    }
  }
}
