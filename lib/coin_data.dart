import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const coinAPI = 'https://rest.coinapi.io/v1/exchangerate/';
const apiKey = '20FB7E67-2D76-43E8-BB72-E851D5EEF82A';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCurrency(String currency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      var url = '$coinAPI$crypto/$currency?apikey=$apiKey';
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);

        double lastPrice = data['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
