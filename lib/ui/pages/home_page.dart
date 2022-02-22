import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact_book/helpers/contact_helper.dart';
import 'package:flutter_contact_book/ui/pages/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAz, orderZa }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactHelper contactHelper = ContactHelper();

  List<Contact> contacts = List.empty(growable: true);

  void _getAllContacts() {
    contactHelper.getAllContacts().then((value) {
      setState(() {
        contacts = value;
      });
    });
  }

  void _orderList(OrderOptions order) {
    switch (order) {
      case OrderOptions.orderAz:
        contacts.sort(((a, b) =>
            (a.name?.toLowerCase())!.compareTo((b.name)!.toLowerCase())));
        break;
      case OrderOptions.orderZa:
        contacts.sort(((a, b) =>
            (b.name?.toLowerCase())!.compareTo((a.name)!.toLowerCase())));
        break;
      default:
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        if (contacts[index].phone == null ||
                            contacts[index].phone!.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        await launch('tel://${contacts[index].phone}');
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Ligar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showContactPage(contact: contacts[index]);
                      },
                      child: const Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        contactHelper.deleteContact(contacts[index].id!);
                        _getAllContacts();
                      },
                      child: const Text(
                        'Excluir',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => ContactPage(
          contact: contact,
        ),
      ),
    );
    if (recContact != null) {
      if (contact != null) {
        await contactHelper.updateContact(recContact);
        _getAllContacts();
        return;
      }

      await contactHelper.saveContact(recContact);
      _getAllContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Contatos'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAz,
                child: Text('Ordenar A-Z'),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZa,
                child: Text('Ordenar Z-A'),
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showContactPage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await contactHelper.getAllContacts();
        },
        child: ListView.builder(
          itemCount: contacts.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
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
                              fit: BoxFit.cover,
                              image: contacts[index].img != null
                                  ? FileImage(
                                      File(contacts[index].img!),
                                    )
                                  : const AssetImage(
                                          'assets/images/person2x.png')
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
              onTap: () {
                // showContactPage(contact: contacts[index]);
                _showOptions(context, index);
              },
            );
          },
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
