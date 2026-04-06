import 'package:flutter/material.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:go_router/go_router.dart';

class Addmovie extends StatefulWidget {
  Addmovie({Key? key}) : super(key: key);

  @override
  _AddmovieState createState() => _AddmovieState();
}

class _AddmovieState extends State<Addmovie> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final genreController = TextEditingController();
  final ratingController = TextEditingController();
  final statusController = TextEditingController();
  final posterUrlController = TextEditingController();
  MovieStatus? selectedStatus;

  @override
  void dispose() {
    titleController.dispose();
    genreController.dispose();
    ratingController.dispose();
    posterUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Pelicula'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un titulo';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Titulo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: genreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un genero';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Genero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: ratingController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Por favor ingrese un rating';
                    }
                    final n = double.tryParse(val);
                    if (n == null || n < 0 || n > 10) {
                      return 'Por favor ingrese un rating valido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                TextFormField(
                  controller: posterUrlController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor ingrese una url'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Poster Url',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                DropdownButtonFormField<MovieStatus>(
                  items: MovieStatus.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(
                            s.name.toUpperCase(),
                            style: TextStyle(
                              color: s == MovieStatus.pending
                                  ? Colors.red
                                  : s == MovieStatus.watching
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => selectedStatus = val),
                  validator: (val) =>
                      val == null ? 'Selecciona un estado' : null,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newMovie = Movie(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        genre_ids: [],
                        vote_average: double.parse(ratingController.text),
                        poster_path: posterUrlController.text,
                        overview: genreController.text,
                        status: selectedStatus!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pelicula agregada correctamente'),
                        ),
                      );
                      context.go('/home');
                    }
                  },
                  child: Text('Agregar Pelicula'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
