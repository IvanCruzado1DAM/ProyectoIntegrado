import 'package:flutter/material.dart';
import 'package:BarDamm/services/client_services.dart';
import 'package:BarDamm/models/opinion.dart'; // Importa tu modelo de Opinion

class OpinionScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const OpinionScreen({
    Key? key,
    required this.token,
    required this.idUser,
    required this.username,
  }) : super(key: key);

  @override
  _OpinionScreenState createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  int _selectedStars =
      0; // Para rastrear la cantidad de estrellas seleccionadas
  final TextEditingController _commentController =
      TextEditingController(); // Controlador para el campo de texto
  bool _opinionSaved = false; // Indica si la opinión ya ha sido guardada
  final ClientService clservices = ClientService();

  @override
  void initState() {
    super.initState();
    _checkExistingOpinion(); // Verificar si ya existe una opinión guardada
  }

  Future<void> _checkExistingOpinion() async {
  try {
    // Verificar que el token no esté vacío
    if (widget.token.isEmpty) {
      throw Exception('El token está vacío');
    }

    // Hacer la solicitud para obtener las opiniones
    final List<Opinion> opinions = await clservices.fetchAllOpinions(widget.token);

    // Si la respuesta es exitosa, verificar si la opinión existe
    if (opinions.isEmpty) {
      print('No hay opiniones disponibles.');
      return;
    }

    // Buscar la opinión del usuario
    final existingOpinion = opinions.firstWhere(
      (opinion) => opinion.idUserOpinion == widget.idUser,
      orElse: () => Opinion(
        idOpinion: -1, // Valor por defecto o centinela
        idUserOpinion: widget.idUser,
        score: 0,
        comment: '',
      ),
    );

    if (existingOpinion.idOpinion != -1) {
      setState(() {
        _opinionSaved = true;
        _selectedStars = existingOpinion.score;
        _commentController.text = existingOpinion.comment;
      });
    }
  } catch (e) {
    // Registrar el error para entender qué falla
    print('Error al verificar la opinión: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al verificar la opinión: $e')),
    );
  }
}




  // Llama al método saveOpinion del servicio
  Future<void> _sendOpinion() async {
    final int score = _selectedStars;
    final String? comment = _commentController.text.trim().isEmpty
        ? null
        : _commentController.text.trim();

    try {
      await clservices.saveOpinion(
        iduseropinion: widget.idUser,
        score: score,
        comment: comment ?? '',
        token: widget.token,
      );
      setState(() {
        _opinionSaved = true; // Cambiar el estado a "opinion guardada"
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opinion sent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send opinion: $e')),
      );
    }
  }

  // Llama al método updateOpinion del servicio
  Future<void> _editOpinion() async {
    final int score = _selectedStars;
    final String? comment = _commentController.text.trim().isEmpty
        ? null
        : _commentController.text.trim();

    try {
      await clservices.editOpinion(
        idUserOpinion: widget.idUser,
        score: score,
        comment: comment ?? '',
        token: widget.token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opinion updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update opinion: $e')),
      );
    }
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _selectedStars ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _selectedStars =
                  index + 1; // Cambia el número de estrellas seleccionadas
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Opinion'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Your opinion is very important for us!!!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Center(child: _buildStars()),
            const SizedBox(height: 20),
            const Text(
              'Leave a comment (optional):',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your comment here...',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _opinionSaved ? _editOpinion : _sendOpinion,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  _opinionSaved ? 'Edit Opinion' : 'Send Opinion',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}