import 'package:expense/core/payment/payment_systems_manager.dart';

extension CurrencyFormatter on double {
  String toCurrencyString(String currencyCode) {
    final symbol = toCurrencySymbol(currencyCode);
    return '$symbol${toStringAsFixed(2)}';
  }

  String toCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'BDT':
        return '৳';
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'Fr.';
      case 'CNY':
        return '¥';
      case 'NZD':
        return 'NZ\$';
      case 'BRL':
        return 'R\$';
      case 'ZAR':
        return 'R';
      default:
        try {
          for (final country in PaymentSystemsManager.allCountriesData) {
            if (country.currencyCode.toUpperCase() == currencyCode.toUpperCase()) {
              return country.currencySymbol;
            }
          }
        } catch (_) {}
        return '\$';
    }
  }
}
