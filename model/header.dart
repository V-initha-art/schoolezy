import 'package:flutter/widgets.dart';
import 'package:schoolezy/model/sub_header.dart';

class Header {
  Header(
    this.title,
    this.isSselected,
    this.subHeader,
    this.icons,
  );
  bool? isSselected;
  String? title;
  IconData? icons;
  List<SubHeader>? subHeader;
}
