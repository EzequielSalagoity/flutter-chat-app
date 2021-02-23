import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true ),
    Usuario(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false ),
    Usuario(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true ),
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined, color: Colors.black87), 
          onPressed: (){

            // TODO: desconectar el socket server
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue),
            // child: Icon(Icons.offline_bolt,color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400],
        ),
        onRefresh: _cargarUsuarios,
        controller: _refreshController,
        child: _listViewUsuarios(),
        enablePullDown: true,        
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      itemBuilder: (_, int i) => _usuarioListTile(usuarios[i]), 
      itemCount: usuarios.length, 
      separatorBuilder: (_, int i) => Divider(),
    );
  }

  ListTile _usuarioListTile(Usuario usuarios) {
    return ListTile(
      subtitle: Text(usuarios.email),
        title: Text(usuarios.nombre),
        leading: CircleAvatar(
          child: Text(usuarios.nombre.substring(0,2)),
        ),
        trailing: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: usuarios.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  void _cargarUsuarios() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }


}