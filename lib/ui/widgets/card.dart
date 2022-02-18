import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact_book/helpers/contact_helper.dart';

Widget contactCard(BuildContext context, int index, List<Contact> contacts) {
  return GestureDetector(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(
                            File(contacts[index].img!),
                          )
                        : const AssetImage('assets/images/person2x.png')
                            as ImageProvider,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    ),
  );
}
