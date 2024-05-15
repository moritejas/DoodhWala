import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class function extends StatelessWidget{
  const function ({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Center(
        child: Text('Welcome to Mori Tejas')
      ),
    );
  }
}
class Addition extends StatefulWidget {
  const Addition({super.key});

  @override
  State<Addition> createState() => _AdditionState();
}

class _AdditionState extends State<Addition> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:Text('Container'),
      centerTitle:true,),
      body: Container(
        color: Colors.blue,
        height: 500,
        width: 150,

      ),
    );
  }
}

int? add(int a, int b){
  int c;
  c= a+b;
  return c;
}

 int sum(int n1, int n2){
  return n1 + n2;
 }

 