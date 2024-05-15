// ignore_for_file: use_super_parameters, prefer_final_fields, avoid_print, unused_import, unused_local_variable, library_private_types_in_public_api, use_build_context_synchronously

// import 'package:etf_tradings/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'homepage.dart';
import 'model.dart';

class AddDataForm extends StatefulWidget {
  const AddDataForm({Key? key}) : super(key: key);

  @override
  _AddDataFormState createState() => _AddDataFormState();
}

class _AddDataFormState extends State<AddDataForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Controllers for form fields
  late TextEditingController _usernameController = TextEditingController();
  final TextEditingController _idnoController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  // final TextEditingController _phoneNoController = TextEditingController();
  Future<String> addData({
    required String username,
    required String idno,
    required String phoneno,
  }) async {
    const String scriptUrl =
        'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec';
    try {
      final Uri uri = Uri.parse('$scriptUrl?action=addData&'
          'username=$username&'
          'idno=$idno&'
          'phoneno=$phoneno&');

      final response = await http.get(uri, headers: {});

      return response.body;
    } catch (error) {
// Handle errors appropriately
      print('Error calling Google Apps Script function: $error');
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Customer Name'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_rounded))),
      body: Expanded(
        child: Center(
          child: Material(
            shadowColor: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 20.0,
            child: SizedBox(
              height: 500,
              width: 300,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Data",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  prefixIcon: const Icon(Icons.person)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Customer name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: _idnoController,
                              decoration: InputDecoration(
                                  labelText: 'id no.',
                                  hintText: "id no.",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  prefixIcon: const Icon(Icons.person)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the id no.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: _phonenoController,
                              decoration: InputDecoration(
                                labelText: 'Contact Number',
                                hintText: "Contact Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Contact Number';
                                } else if (value.length != 10) {
                                  return 'Contact Number must be 10 digits';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, call the function to add data
                                final result = await addData(
                                  username: _usernameController.text,
                                  idno: _idnoController.text,
                                  phoneno: _phonenoController.text,
                                  // points: _pointsController.text,
                                ); // Handle the result from the addData function
                                if (kDebugMode) {
                                  print("successful");
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const Dudhwale();
                                    },
                                  ));
                                } else {
                                  (kDebugMode) {
                                    print("UnSuccessfull");
                                  };
                                }
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
