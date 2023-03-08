import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({Key? key}) : super(key: key);

  static const routeName = '/editarPerfil';

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _emailController = TextEditingController();
  bool isObscurePassword = true;
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';


  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  @override
  initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2a5298),
        title: Text('Editar perfil'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
                Icons.check,
                color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2017/08/07/06/34/weimaraner-2600694_1280.jpg'
                              )
                          )
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Colors.white
                              ),
                              color: Colors.blue
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Color(0xFF2a5298),
                          ),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField('Nome', nome, false),
              buildTextField('Email', email, false),
              //buildTextField('Senha', '*********', true),
              SizedBox(height: 30),
              Row(
                children: [
                  TextButton(
                    child: const Text(
                      "Alterar senha ",
                      style: TextStyle(
                        color: Color(0xFF2a5298),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      resetPassword();
                    },
                  ),
              ]

                //   OutlinedButton(onPressed: () {},
                //       child: Text('Cancelar',
                //       style: TextStyle(
                //         fontSize: 15,
                //         letterSpacing: 2,
                //         color: Colors.black
                //       )),
                //     style: OutlinedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                //     ),
                //   ),
                  // ElevatedButton(onPressed: () {},
                  //     child: Text('Salvar', style: TextStyle(
                  //       fontSize: 15,
                  //       letterSpacing: 2,
                  //       color: Colors.white
                  //     )),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     padding: EdgeInsets.symmetric(horizontal: 50),
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20) )
                  //   )
                  //     )
                //],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String? labelText, String? placeholder, bool isPasswordTextField) {
  return Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: TextField(
      obscureText: isPasswordTextField ? isObscurePassword : false,
      decoration: InputDecoration(
        suffixIcon: isPasswordTextField ?
            IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    isObscurePassword = !isObscurePassword;
                  });
                }
            ): null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )
      ),
    ),
  );
}

  getUser() async{
    User? usuario = _firebaseAuth.currentUser;
    if (usuario != null){
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }
  Future resetPassword() async {

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de  alteração de senha enviado. Verifique sua caixa de entrada e spam'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email não cadastrado'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

