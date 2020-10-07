import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';

CoinData coinData = CoinData();
var curr;
List crypto;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedItem = 'AUD';

  Widget ios() {
    List<Text> items = [];

    for (String currncy in currenciesList) {
      items.add(
        Text(
          currncy,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) => print(selectedIndex),
      children: items,
    );
  }

  Widget android() {
    List<DropdownMenuItem<String>> listDropDownMenue = [];

    for (String currncy in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(
          currncy,
        ),
        value: currncy,
      );

      listDropDownMenue.add(item);
    }
    return DropdownButton<String>(
      value: selectedItem,
      items: listDropDownMenue,
      onChanged: (val) async {
        setState(
          () {
            selectedItem = val;
            getData();
          },
        );
      },
    );
  }

  Map<String, String> coinValues = {};

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await coinData.getCurrency(selectedItem);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                cryptoCurrency: cryptoList[0],
                coinValues: coinValues['BTC'],
                selectedCurrency: selectedItem,
              ),
              CryptoCard(
                cryptoCurrency: cryptoList[1],
                coinValues: coinValues['ETH'],
                selectedCurrency: selectedItem,
              ),
              CryptoCard(
                cryptoCurrency: cryptoList[2],
                coinValues: coinValues['LTC'],
                selectedCurrency: selectedItem,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? ios() : android(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.coinValues,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  });

  final String coinValues;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.0, 18.0, 25.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${cryptoList[0]} = $coinValues  $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
