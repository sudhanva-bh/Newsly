import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/Widgets/widgets_main.dart';

// Fetches stock data for a given symbol using the Finnhub API
Future<StockData> fetchStock({
  required String symbol,
  required String apiKey,
}) async {
  // Build the API URL
  final url = Uri.parse(
    'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey',
  );

  try {
    // Make the HTTP GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the response JSON
      final data = jsonDecode(response.body);

      // Use 0.0 as fallback if fields are missing
      final price = (data['c'] is num) ? (data['c'] as num).toDouble() : 0.0;
      final change = (data['d'] is num) ? (data['d'] as num).toDouble() : 0.0;

      // Return the fetched stock data
      return StockData(symbol: symbol, price: price, change: change);
    } else {
      // Fallback in case of error response
      return StockData(symbol: symbol, price: 0.0, change: 0.0);
    }
  } catch (e) {
    // Fallback in case of parsing/network errors
    return StockData(symbol: symbol, price: 0.0, change: 0.0);
  }
}
