import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact_book/helpers/contact_helper.dart';

Widget avatar(List<Contact> contacts, int index) {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: contacts[index].img != null
              ? FileImage(
                  File(contacts[index].img!),
                )
              : const AssetImage('assets/images/person2x.png') as ImageProvider,
        )),
  );
}
