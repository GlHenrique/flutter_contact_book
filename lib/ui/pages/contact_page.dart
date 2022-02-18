import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact_book/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  const ContactPage({this.contact, Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editedContact;
  bool _userEdited = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
      return;
    }

    _editedContact = Contact.fromMap(widget.contact!.toMap());
    _nameController.text = _editedContact?.name ?? '';
    _emailController.text = _editedContact?.email ?? '';
    _phoneController.text = _editedContact?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact?.name ?? 'Novo Contato'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact?.img != null
                          ? FileImage(
                              File(_editedContact?.img! ?? ''),
                            )
                          : const AssetImage('assets/images/person2x.png')
                              as ImageProvider,
                    )),
              ),
            ),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                _userEdited = true;
                setState(() {
                  _editedContact?.name = value;
                });
              },
              decoration: const InputDecoration(
                label: Text('Nome'),
              ),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                _userEdited = true;
                _editedContact?.email = value;
              },
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                _userEdited = true;
                _editedContact?.phone = value;
              },
              decoration: const InputDecoration(
                label: Text('Phone'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
