import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/profile/widgets/Address_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/faq_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/favorite_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/password_change_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/personal_info_bottom_sheet.dart';
import 'package:flutter/material.dart';

void showUserProfileOptions(BuildContext context, String optionText) {
  showModalBottomSheet(
    showDragHandle: true,
    barrierColor: Color.fromARGB(214, 0, 0, 0),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            switch (optionText) {
              case 'Dane osobiste':
                return PersonalInfoBottomSheet();
              case 'Ulubione':
                return FavoriteBottomSheet();
              case 'Zmień hasło':
                return PasswordChangeBottomSheet();
              case 'FAQ':
                return FaqBottomSheet();
              case 'Powiadomienia':
                return PasswordChangeBottomSheet();
              case 'Mój adres':
                return AddressBottomSheet();
              default:
                return Container(); // Return an empty container or default widget
            }
          },
        ),
      );
    },
  );
}
