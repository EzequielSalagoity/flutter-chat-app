import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final void Function() onPressed;
  final String texto;

  BotonAzul({
    @required this.onPressed,
    @required this.texto,   
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(this.texto,style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
      onPressed: this.onPressed
    );
  }



}