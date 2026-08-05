import 'package:intl/intl.dart';
import '../../app/models/currency_model.dart';
import '../../app/services/guest_service/guest_service.dart';
import '../data/api_public_data.dart';
import '../data/app_data.dart';

class CurrencyUtils {
  static late String userCurrency;

  CurrencyUtils() {
    AppData.getCurrency().then((value) {
      userCurrency = value;
      GuestService.getCurrencyList();
    });
  }

  static String getSymbol(String currency) {
    // Handle IQD specifically
    if (currency != 'IQD') {
      return 'IQD';
    }

    var format = NumberFormat.simpleCurrency(name: currency);
    return format.currencySymbol;
  }

  static String calculator(var price) {
    String symbol = getSymbol(userCurrency);

    // Convert price to double
    double priceValue;
    if (price is String) {
      priceValue = double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      priceValue = price.toDouble();
    } else {
      priceValue = 0.0;
    }

    if (PublicData.currencyListData
            .indexWhere((element) => element.currency == userCurrency) ==
        -1) {
      // For IQD, format without decimals
      if (userCurrency == 'IQD') {
        final numberFormat = NumberFormat('#,###', 'en_US');
        final formattedPrice = numberFormat.format(priceValue.toInt());
        return PublicData.apiConfigData['currency_position']
                    ?.toString()
                    .toLowerCase() ==
                'right'
            ? '$formattedPrice $symbol'
            : '$symbol $formattedPrice';
      }
      // Fallback for other currencies
      final numberFormat = NumberFormat('#,###.##', 'en_US');
      final formattedPrice = numberFormat.format(priceValue);
      return PublicData.apiConfigData['currency_position']
                  ?.toString()
                  .toLowerCase() ==
              'right'
          ? '$formattedPrice $symbol'
          : '$symbol $formattedPrice';
    }

    CurrencyModel currency = PublicData.currencyListData[PublicData
        .currencyListData
        .indexWhere((element) => element.currency == userCurrency)];
    double newPrice = priceValue * (currency.exchangeRate ?? 1.0);

    // For IQD, format without decimals
    if (userCurrency == 'IQD') {
      final numberFormat = NumberFormat('#,###', 'en_US');
      final formattedPrice = numberFormat.format(newPrice.toInt());
      return currency.currencyPosition?.toString().toLowerCase() == 'right'
          ? '$formattedPrice $symbol'
          : '$symbol $formattedPrice';
    }

    // For other currencies, format with decimals
    final numberFormat =
        NumberFormat('#,###.${'0' * (currency.currencyDecimal ?? 0)}', 'en_US');
    final formattedPrice = numberFormat.format(newPrice);

    return currency.currencyPosition?.toString().toLowerCase() == 'right'
        ? '$formattedPrice $symbol'
        : '$symbol $formattedPrice';
  }
}
