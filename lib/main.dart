import 'package:flutter/material.dart';

void main() {
  runApp(const MiBibliotecaApp());
}

class MiBibliotecaApp extends StatelessWidget {
  const MiBibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Biblioteca',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BibliotecaPantalla(),
    );
  }
}

class Book {
  final String title;
  final int pages;
  final bool isFiction;
  final String author;

  const Book({
    required this.title,
    required this.pages,
    required this.isFiction,
    required this.author,
  });
}

// pantalla principal
class BibliotecaPantalla extends StatefulWidget {
  const BibliotecaPantalla({super.key});

  @override
  State<BibliotecaPantalla> createState() => _BibliotecaPantallaState();
}

class _BibliotecaPantallaState extends State<BibliotecaPantalla> {
  final List<Book> _libros = [
    const Book(
      title: 'Cien años de soledad',
      author: 'Gabriel García Márquez',
      pages: 471,
      isFiction: true,
    ),
    const Book(
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      pages: 443,
      isFiction: false,
    ),
    const Book(
      title: '1984',
      author: 'George Orwell',
      pages: 328,
      isFiction: true,
    ),
    const Book(
      title: 'El principito',
      author: 'Carlos',
      pages: 200,
      isFiction: true,
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _paginasController = TextEditingController();
  bool _esFiccion = true;

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _paginasController.dispose();
    super.dispose();
  }

  void _mostrarFormularioAgregar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agregar Nuevo Libro',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _autorController,
                        decoration: const InputDecoration(labelText: 'Autor'),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _paginasController,
                        decoration: const InputDecoration(labelText: 'Número de páginas'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Campo requerido';
                          if (int.tryParse(value) == null) return 'Ingresa un número válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text('Género: '),
                          ChoiceChip(
                            label: const Text('Ficción'),
                            selected: _esFiccion,
                            onSelected: (selected) {
                              setModalState(() => _esFiccion = true);
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text('No Ficción'),
                            selected: !_esFiccion,
                            onSelected: (selected) {
                              setModalState(() => _esFiccion = false);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _libros.add(Book(
                                title: _tituloController.text,
                                author: _autorController.text,
                                pages: int.parse(_paginasController.text),
                                isFiction: _esFiccion,
                              ));
                            });
                            _tituloController.clear();
                            _autorController.clear();
                            _paginasController.clear();
                            _esFiccion = true;
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Guardar Libro'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.auto_stories, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text('Mi Biblioteca'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _libros.isEmpty
          ? const Center(child: Text('No hay libros en tu biblioteca.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _libros.length,
        itemBuilder: (context, index) {
          final libro = _libros[index];
          final colorGenero = libro.isFiction ? Colors.purple : Colors.blue;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark,
                    size: 40,
                    color: colorGenero.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          libro.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          libro.author,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.menu_book, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${libro.pages} páginas',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorGenero.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                libro.isFiction ? Icons.star : Icons.public,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }
}