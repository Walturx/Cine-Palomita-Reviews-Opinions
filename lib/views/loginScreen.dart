import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/auth_cubit.dart';
import 'package:flutter_repaso/cubits/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  bool isLoggin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'lib/assets/images/Logo.png',
                  width: size.width * 0.5,
                  height: size.height * 0.3,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Center(
                child: Text(
                  isLoggin ? 'Ingresar' : 'Registrarse',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              if (!isLoggin)
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: size.height * 0.02),
              if (!isLoggin)
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: size.height * 0.02),

              Container(
                width: size.width * 0.8,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                width: size.width * 0.8,
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
              ),

              SizedBox(height: size.height * 0.10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoggin = !isLoggin;
                  });
                },
                child: Text(
                  isLoggin
                      ? 'No tiene cuenta, registrese'
                      : 'Tiene una cuenta, inicie sesion',
                ),
              ),
              SizedBox(height: size.height * 0.10),

              ElevatedButton(
                onPressed: () {
                  if (isLoggin) {
                    context.read<AuthCubit>().signIn(
                      emailController.text,
                      passwordController.text,
                    );
                  } else {
                    context.read<AuthCubit>().signUp(
                      nameController.text,
                      lastnameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
                child: Text(isLoggin ? 'Ingresar' : 'Registrarse'),
              ),
            ],
          ),
        );
      },
    );
  }
}
