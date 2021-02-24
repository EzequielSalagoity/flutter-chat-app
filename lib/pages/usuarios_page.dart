import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosService = new UsuariosService();

  List<Usuario> usuarios = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

      @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined, color: Colors.black87), 
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) ? Icon(Icons.check_circle, color: Colors.blue) : Icon(Icons.offline_bolt,color: Colors.red),
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
        onTap: (){
          final chatService = Provider.of<ChatService>(context, listen:false);
          chatService.usuarioPara = usuarios;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  void _cargarUsuarios() async{

    
    this.usuarios = await usuariosService.getUsuarios();
    setState(() {
      
    });
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }


}