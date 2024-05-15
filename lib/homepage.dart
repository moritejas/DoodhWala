// ignore_for_file: avoid_print, library_private_types_in_public_api, dead_code, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'View.dart';
import 'add_data.dart';
import 'model.dart';

//---Class
class Dudhwale extends StatefulWidget {
  const Dudhwale({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dudhwale> {
  List<DudhWala> items = [];
  bool isSorted = false;


  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

//---Fetching User Data
  Future<void> fetchDataFromApi() async {
    try {
      var baseUrl =
          'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec?action=getUsername';
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final dudhwala = dudhWalaFromJson(response.body.toString());
        setState(() {
          items = dudhwala;
        });
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      // Handle errors appropriately
    }
  }

//---Add Quantity Data
  Future<String> addQuantity({
    required String idno,
    required String qt,
    // required double price,
  }) async {
    const String scriptUrl =
        'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec';
    try {
      final Uri uri = Uri.parse('$scriptUrl?action=addQuantity&'
          'idno=$idno&'
          'qt=$qt&'
          // 'price=$price&'
          );
      final response = await http.get(uri, headers: {});
      return response.body;
    } catch (error) {
// Handle errors appropriately
      print('Error calling Google Apps Script function: $error');
      return "error";
    }
  }

//---Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DoodhWala'),
        centerTitle: true,
        actions: const [Icon(Icons.more_vert_rounded)],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
            ),
            const ListTile(
              title: Text('Account'),
              leading: Icon(Icons.account_box),
            ),
            const ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
            ),
            ListTile(
              title: const Text('Modes'),
              leading: const Icon(Icons.sunny_snowing),
              onTap: () {
                Get.bottomSheet(
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.sunny),
                          title: const Text('Light Modes'),
                          onTap: () => {Get.changeTheme(ThemeData.light())},
                        ),
                        ListTile(
                          leading: const Icon(Icons.sunny),
                          title: const Text('Dark Modes'),
                          onTap: () => {Get.changeTheme(ThemeData.dark())},
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Mode"),
              leading: const Icon(Icons.light_mode_sharp),
              onTap: () {
                Get.defaultDialog();
              },
            ),
            ListTile(
              title: const Text('Theme'),
              leading: const Icon(Icons.wb_sunny_sharp),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('Dark Mode'),
                            leading: const Icon(Icons.dark_mode_rounded),
                            onTap: () => {
                              print('Dark Mode selected'),
                              Get.changeTheme(ThemeData.dark()),
                              Get.back(),
                            },
                          ),
                          ListTile(
                            title: const Text('Light Mode'),
                            leading: const Icon(Icons.wb_sunny_outlined),
                            onTap: () => {
                              print('Light Mode selected'),
                              Get.changeTheme(ThemeData.light()),
                              Get.back(),
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddDataForm());
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) {
          //     return const AddDataForm();
          //   },
          // ));
        },
        tooltip: 'Add Data',
        child: const Icon(Icons.add),
      ),
    );
  }

//--- Id, Username
//--- Widget
  Widget buildBody() {
    if (items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (!isSorted) {
        isSorted = true;
      }
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            // padding: const  EdgeInsets.fromLTRB(8, 8, 0, 8),
            padding: const EdgeInsets.all(8),
            child: Card(
              // color:const  Color(0xfffCC0C0),
              elevation: 8,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(30.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.zero),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                        // Title
                        title: Text(
                          " ${items[index].username}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        // Sub Title
                        subtitle: Text(
                          "ID-No : ${items[index].idno}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        // Leading
                        leading: const Icon(Icons.person_rounded),
                        // Trailing
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.zero),
                            ),
                          ),
                          onPressed: () {
                            _showOptionDialog(context, items[index].idno);
                          },
                          label: const Text('QTY'),
                          icon: const Icon(Icons.add),
                        ),
                        onLongPress: () {
                          // Perform delete operation
                          _deleteItem(items[index].idno);
                        }
                        ),
                    const SizedBox(
                      height: 3,
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
// Phone Number
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 2, 2, 4),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.call_rounded),
                                Text('${items[index].phoneno}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 15, 8),
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.zero,
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.zero),
                                    ),
                                  ),
                                  onPressed: () {
// Used Getx with UserDetailPage
                                    Get.to(UserDetailsPage(
                                      name: items[index].username,
                                      id: items[index].idno,
                                      phones: items[index].phoneno,
                                    ));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       //--- Call UserDetailPage
                                    //       builder: (context) => UserDetailsPage(
                                    //         name: items[index].username,
                                    //         id: items[index].idno,
                                    //         phones: items[index].phoneno,
                                    //       ),
                                    //     ));
                                  },
                                  label: const Text('View'),
                                  icon: const Icon(Icons.remove_red_eye),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

//---Delete item function
  void _deleteItem(String id) async {
    try {
      const String scriptUrl = 'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec';
      final Uri uri = Uri.parse('$scriptUrl?action=deletenameData&idno=$id');
      final response = await http.get(uri, headers: {});
      if (response.statusCode == 200) {
        setState(() {
          // Remove the item from the list
          items.removeWhere((element) => element.idno == id);
        });
        // Show a snackbar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item with ID $id deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete item');
      }
      // Handle errors appropriately
    } catch (error) {
      print('Error deleting item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item')),
      );
    }
  }

//Add Quantity value
//Void method
  void _showOptionDialog(BuildContext context, String id) {
    String? selectedValue;
    // double? pr;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Select Quantity'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOptionButton(context, 'અચ્છેર', (value) {
                  selectedValue = value;
                }),
                _buildOptionButton(context, 'સેર', (value) {
                  selectedValue = value;
                }),
                _buildOptionButton(context, 'પોણા સેર', (value) {
                  selectedValue = value;
                }),
                _buildOptionButton(context, 'એક લીટર', (value) {
                  selectedValue = value;
                }),
                _buildOptionButton(context, 'બે  લીટર', (value) {
                  selectedValue = value;
                }),
                _buildOptionButton(context, 'ત્રણ  લીટર', (value) {
                  selectedValue = value;
                }),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the dialog without passing the value
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedValue != null) {
                    Navigator.of(context)
                        .pop(selectedValue); // Pass the selected value
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      // Handle the selected option
      if (value != null) {
        setState(() {
          print('Id No: $id');
          print('Select Quantity: $value');
          // Integrate switch-case logic here
          double quantity;
          switch (value) {
            case 'અચ્છેર':
              quantity = 0.25;
              break;

            case 'સેર':
              quantity = 0.50;
              break;
            case 'પોણા સેર':
              quantity = 0.75;
              break;

            case 'એક લીટર':
              quantity = 1;
              break;

            case 'બે  લીટર':
              quantity = 2;
              break;

            case 'ત્રણ  લીટર':
              quantity = 3;
              break;
              break;

            default:
              quantity = 0;
              break;
          }
          print('Quantity: $quantity');
          addQuantity(
              idno: id,
              // price: pr.toDouble(),
              qt: quantity.toString());
        });
      }
    });
  }

  Widget _buildOptionButton(
      BuildContext context, String option, Function(String) onSelect) {
    return TextButton(
      onPressed: () {
        onSelect(option);
      },
      child: Text(option),
    );
  }
}
