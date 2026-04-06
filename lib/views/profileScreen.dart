import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/auth_cubit.dart';
import 'package:flutter_repaso/cubits/profile_cubit.dart';
import 'package:flutter_repaso/cubits/profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ProfileError) {
          return Scaffold(body: Center(child: Text(state.error)));
        }
        if (state is ProfileLoaded) {
          final total = state.watched + state.watching + state.pending;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Mi Perfil',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    context.go('/home');
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          context.read<ProfileCubit>().uploadAvatar(
                            File(picked.path),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: size.width * 0.3,
                        backgroundImage: state.avatarUrl != null
                            ? NetworkImage(state.avatarUrl!)
                            : null,
                        child: state.avatarUrl == null
                            ? Icon(Icons.person, size: size.width * 0.1)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text(
                    state.name,
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(state.user.email ?? ''),

                  SizedBox(height: size.height * 0.05),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.brown),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.movie, color: Colors.brown),
                            Text('Total de películas: '),
                            Text(total.toString()),
                          ],
                        ),
                        Divider(color: Colors.black),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.movie, color: Colors.brown),
                            Text('Películas vistas: '),
                            Text(state.watched.toString()),
                          ],
                        ),
                        Divider(color: Colors.black),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.movie, color: Colors.brown),
                            Text('Películas viendo: '),
                            Text(state.watching.toString()),
                          ],
                        ),
                        Divider(color: Colors.black),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.movie, color: Colors.brown),
                            Text('Películas pendientes: '),
                            Text(state.pending.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                    },
                    child: Text('Cerrar sesión'),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
