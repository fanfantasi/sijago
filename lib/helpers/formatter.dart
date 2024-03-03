import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';

final formatter = new NumberFormat("#,###");

class Formatter {
  static String number(double num) {
    final formatter = new NumberFormat("#,###");
    return formatter.format(num);
  }

  static String count(int value) {
    if (value >= 1000) {
      return (value / 1000.0).toStringAsFixed(1) + 'k';
    } else {
      return value.toString();
    }
  }

  static String status(int string) {
    switch (string) {
      case 0:
        return 'Unknown';
        break;
      case 1:
        return 'Transaksi Terkirim';
        break;
      case 2:
        return 'Pesanan dalam Diproses';
        break;
      case 3:
        return 'Pesanan Sedang Diantar';
        break;
      case 4:
        return 'Transaksi Selesai';
        break;
      case 5:
        return 'Transaksi Batal';
        break;
      default:
        return 'Unknown';
    }
  }

  static String payment(int string) {
    switch (string) {
      case 0:
        return 'Lunas';
        break;
      case 1:
        return 'Menunggu Pembayaran';
        break;
      default:
        return 'Menunggu Pembayaran';
    }
  }

  static String statuspulsa(int string) {
    switch (string) {
      case 0:
        return 'Transaksi Berhasil';
        break;
      case 1:
        return 'Transaksi Pending';
        break;
      case 2:
        return 'Transaksi Gagal';
        break;
      case 3:
        return 'Transaksi Batal';
        break;
      default:
        return 'Unknown';
    }
  }

  static String stockads(int string) {
    switch (string) {
      case 0:
        return 'Kosong';
        break;
      case 1:
        return 'Ready';
        break;
      case 2:
        return 'Fre Order';
        break;
      case 3:
        return 'Booked';
        break;
      default:
        return 'Unknown';
    }
  }

  static IconData icon(int string) {
    switch (string) {
      case 0:
        return Icons.check;
        break;
      case 1:
        return Icons.near_me;
        break;
      case 2:
        return Icons.info;
        break;
      case 3:
        return Icons.remove;
        break;
      case 4:
        return Icons.check;
        break;
      case 5:
        return Icons.remove;
        break;
      default:
        return Icons.remove;
    }
  }

  static IconData icontransaksi(int string) {
    switch (string) {
      case 0:
        return Icons.info_outline;
        break;
      case 1:
        return Icons.near_me;
        break;
      case 2:
        return Icons.sync;
        break;
      case 3:
        return Icons.location_on;
        break;
      case 4:
        return Icons.check;
        break;
      case 5:
        return Icons.remove;
        break;

      default:
        return Icons.remove;
    }
  }

  static Color warnapulsa(int string) {
    switch (string) {
      case 0:
        return Colors.green;
        break;
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.red;
        break;
      case 3:
        return jagoRed;
        break;
      case 4:
        return jagoRed;
        break;
      case 5:
        return jagoRed;
        break;

      default:
        return jagoRed;
    }
  }

  static Color warna(int string) {
    switch (string) {
      case 0:
        return Colors.blue;
        break;
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.green;
        break;
      case 3:
        return Colors.green;
        break;
      case 4:
        return jagoRed;
        break;
      case 5:
        return jagoRed;
        break;

      default:
        return jagoRed;
    }
  }

  static Color warnaoperasional(bool string) {
    switch (string) {
      case true:
        return Colors.green;
        break;
      case false:
        return Colors.red;
        break;

      default:
        return jagoRed;
    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }

  static Color warnapulsa(int string) {
    switch (string) {
      case 0:
        return Colors.green;
        break;
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.red;
        break;
      case 3:
        return jagoRed;
        break;
      case 4:
        return jagoRed;
        break;
      case 5:
        return jagoRed;
        break;

      default:
        return jagoRed;
    }
  }
}

class PulsaCard {
  CardType type;
  String number;
  PulsaCard({this.type, this.number});

  String toString() {
    return '[Type: $type, Number: $number]';
  }
}

enum CardType {
  As,
  Axis,
  Simpati,
  Smartfreen,
  Xl,
  Indosat,
  Tri,
  Flexi,
  Others,
  Invalid
}

class CardUtils {
  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static Widget getCardIcon(CardType cardType) {
    String img = "";
    Icon icon;
    switch (cardType) {
      case CardType.As:
        img = 'as.png';
        break;
      case CardType.Axis:
        img = 'axis.png';
        break;
      case CardType.Simpati:
        img = 'tsel.png';
        break;
      case CardType.Smartfreen:
        img = 'smartfreen.png';
        break;
      case CardType.Xl:
        img = 'xl.png';
        break;
      case CardType.Indosat:
        img = 'indosat.png';
        break;
      case CardType.Tri:
        img = '3.png';
        break;
      case CardType.Flexi:
        img = 'flexi.png';
        break;
      case CardType.Others:
        icon = new Icon(
          Icons.credit_card,
          size: 30.0,
          color: Colors.grey[600],
        );
        break;
      case CardType.Invalid:
        icon = new Icon(
          Icons.warning,
          size: 30.0,
          color: Colors.grey[600],
        );
        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = new Image.asset(
        'images/$img',
        width: 30.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  static String validateCardNum(String input) {
    if (input.isEmpty) {
      return Strings.fieldReq;
    }

    input = getCleanedNumber(input);

    if (input.length < 9) {
      return Strings.numberIsInvalid;
    }

    if (input.length >= 10) {
      return null;
    }
    return Strings.numberIsInvalid;
  }

  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(new RegExp(r'((081[2-3])|(082[1]))'))) {
      cardType = CardType.Simpati;
    } else if (input.startsWith(new RegExp(r'((085[2-3]))'))) {
      cardType = CardType.As;
    } else if (input.startsWith(new RegExp(r'((0838)|(0831))'))) {
      cardType = CardType.Axis;
    } else if (input.startsWith(new RegExp(r'((0888)|(08811))'))) {
      cardType = CardType.Smartfreen;
    } else if (input.startsWith(new RegExp(r'((081[7-9])|(087[7-9]))'))) {
      cardType = CardType.Xl;
    } else if (input.startsWith(new RegExp(r'((085[5-8])|(081[4-6]))'))) {
      cardType = CardType.Indosat;
    } else if (input.startsWith(new RegExp(r'((089[6-9]))'))) {
      cardType = CardType.Tri;
    } else if (input.startsWith(new RegExp(r'((021[68])|(021[70]))'))) {
      cardType = CardType.Flexi;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }
}

class Strings {
  static const String fieldReq = 'Silahkan isi Nomor disini';
  static const String numberIsInvalid = 'Nomor Salah';
}
