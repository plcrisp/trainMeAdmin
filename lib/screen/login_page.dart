import 'package:academia/componentes/button.dart';
import 'package:academia/componentes/my_text_field.dart';
import 'package:academia/screen/train_me_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //validator email
  String? Function(String?) validatorEmail(String _controller) {
    return (String? _controller) {
      if (_controller == null || _controller.isEmpty) {
        return "E-mail necessário";
      } else if (!RegExp(r'\w+@\w+\.\w+').hasMatch(_controller)) {
        return "Formato de e-mail inválido";
      } else {
        return null;
      }
    };
  }

  //validator password
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String? Function(String?) validatorPassword(String _controller) {
    return (String? _controller) {
      if (_controller == null || _controller.isEmpty) {
        return "Senha necessária";
      } else if (!RegExp(pattern).hasMatch(_controller)) {
        return "Senha deve conter: \n- 8 caracteres. \n- uma letra maiúscula. \n- uma minúscula. \n- um número. \n- um caractere especial.";
      } else {
        return null;
      }
    };
  }

  //sign user function
  Future signIn() async {
    //loading page
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.of(context).pop(); // Feche o diálogo primeiro
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrainMe()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Feche o diálogo em caso de erro
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Não existe usuário com o email fornecido.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              elevation: 10,
              content: Text('Informações fornecidas não existentes.'),
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Feche o diálogo em caso de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro'),
          ),
        );
      }
    } else {
      Navigator.of(context).pop(); // Feche o diálogo se a validação falhar
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 43, 69, 1),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  //welcome back
                  Text(
                    'Bem vindo de volta!',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),

                  //username
                  MyTextField(
                    controller: emailController,
                    hintText: 'E-mail',
                    obscureText: false,
                    validator: validatorEmail(emailController.text.trim()),
                  ),
                  const SizedBox(height: 25),
                  //password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                    validator:
                        validatorPassword(passwordController.text.trim()),
                  ),
                  const SizedBox(height: 10),
                  //forgot password

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Esqueceu a Senha?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  //sign in button
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(18, 154, 194, 1),
                          foregroundColor: Colors
                              .black // Substitua 'Colors.red' pela cor que você deseja
                          ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  //register now
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Register',
                              style: TextStyle(color: Colors.grey[700])),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não tem uma conta?',
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: const Text(
                          'Registre-se agora!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}