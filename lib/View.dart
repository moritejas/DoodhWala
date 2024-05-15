// ignore_for_file: unused_import, avoid_print, library_private_types_in_public_api, non_constant_identifier_names, file_names
// import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'model_user_detail.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage(
      {Key? key, required this.name, required this.id, required this.phones})
      : super(key: key);
  final String name;
  final String id;
  final dynamic phones;

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<UserDetails> userDetailsList = []; // Placeholder for fetched data
  late DateTime _selectedDate;
  double _TotalRupees = 0.0;
  bool _isLoading = true;

  Future<void> fetchDatasFromApi(
      String userid, int selectedMonth, int selectedYear) async {
    try {
      var baseUrl =
          'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec';

      final Uri uri = Uri.parse('$baseUrl?action=getUserdetails&'
          'idno=$userid&');
      final response = await http.get(uri, headers: {});

      if (response.statusCode == 200) {
        final tempList = userDetailsFromJson(response.body);
        // Filter data by selected month and year
        setState(() {
          userDetailsList = tempList
              .where((user) =>
                  user.dateAndTime.month == selectedMonth &&
                  user.dateAndTime.year == selectedYear)
              .toList();
          _TotalRupees = calculateTotalQuantity() * 60;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from API');
        // Center(
        //   child: CircularProgressIndicator,
        // );
      }
    } catch (error) {
      print(error.toString()); // Print error for debugging purposes
      // Handle errors appropriately
    }
  }

  double calculateTotalQuantity() {
    double total = 0.0;
    for (var user in userDetailsList) {
      total += user.quantityLiter;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    // Set initial selected date to current month and year
    _selectedDate = DateTime.now();
    // Fetch data for the current month initially
    fetchDatasFromApi(widget.id, DateTime.now().month, DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        title: const Text('Show User Data'),
        centerTitle: true,
        actions: [
          // Icon(CupertinoIcons.),

          IconButton(
            onPressed: () {
              final url = 'https://wa.me/${widget.phones}?text='
                  '${Uri.encodeComponent('The total milk of "${_selectedDate.month}" Month ${_selectedDate.year}Year has been ${calculateTotalQuantity()}'
                      'liters and its cost is $_TotalRupees Rupees')}';
              launchUrl(
                Uri.parse(url),
              );
            },
            icon: Image.asset('assets/icons/whatsapp 2.png'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.monthYear,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _isLoading = true;
                  fetchDatasFromApi(
                      widget.id, newDateTime.month, newDateTime.year);
                  if (userDetailsList.isEmpty) {
                    // Check if userDetailsList is empty
                  }
                });
              },
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : const SizedBox(child:Text('Data is not Found'),), // Show CircularProgressIndicator if data is loading

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Card(
              child: ListTile(
                title: Text(
                  'Total liters: ${calculateTotalQuantity().toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  "Total Rupees: ${_TotalRupees.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                // subtitle: Text('No. ${widget.phones}'),
                onLongPress:(){

                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userDetailsList.length,
              itemBuilder: (context, index) {
                UserDetails user = userDetailsList[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.zero),
                    ),
                    child: ListTile(
                        title: Text('ID: ${user.id}'),
                        subtitle: Text(
                            '\tQuantity: ${user.quantityLiter.toStringAsFixed(2)} liters\n Date Time: ${user.dateAndTime} '),
                        // trailing: Text('Price: ${user.price}'),
                        onLongPress: () {
                          // delete operation
                          _deleteItem(userDetailsList[index].id);
                        }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  //---Delete item function
  void _deleteItem(String quantity) async {
    try {
      const String scriptUrl = 'https://script.google.com/macros/s/AKfycbz2m-YuYvecDomVj3kz68ady5giEtsujkw1m4w43HrMAoXhIVNmHG6T9FlIOfCU_R5A/exec';
      final Uri uri = Uri.parse('$scriptUrl?action=deleteuserData&quantityLiter=$quantity');
      final response = await http.get(uri, headers: {});
      if (response.statusCode == 200) {
        setState(() {
          // Remove the item from the list
          userDetailsList.removeWhere((element) => element.quantityLiter == quantity);
        });
        // Show a snackbar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item with ID $quantity deleted successfully')),
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

}
