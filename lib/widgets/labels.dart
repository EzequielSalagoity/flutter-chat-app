import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String titulo;
  final String subTitulo;

  const Labels({
    @required this.ruta,
    @required this.subTitulo,
    @required this.titulo,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.titulo, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300)),
          SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, this.ruta);
            },
            child: Text(
              this.subTitulo,
              style: TextStyle(
                color: Colors.blue[600], 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              )
            )
          )
        ],
      )
    );
  }
}