import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/deal.dart';
import '../utils/exceptions.dart';

class ApiService {
  final String baseUrl = 'https://www.cheapshark.com/api/1.0';
  final http.Client client;
  
  ApiService({http.Client? client}) : this.client = client ?? http.Client();
  
  Future<List<Deal>> getDeals({String? title}) async {
    try {
      String url = '$baseUrl/deals?storeID=1';
      
      if (title != null && title.isNotEmpty) {
        url += '&title=${Uri.encodeComponent(title)}';
      }
      
      final response = await client.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        List<dynamic> dealsJson = json.decode(response.body);
        return dealsJson.map((json) => Deal.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load deals: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Failed to fetch deals: $e');
    }
  }
}