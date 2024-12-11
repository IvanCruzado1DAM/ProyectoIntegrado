import 'package:flutter/material.dart';
import 'package:BarDamm/services/client_services.dart';
import 'package:BarDamm/models/turnpool.dart';

class PoolScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const PoolScreen({
    Key? key,
    required this.token,
    required this.idUser,
    required this.username,
  }) : super(key: key);

  @override
  _PoolScreenState createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  late Future<int> _turnPoolFuture;
  late Future<List<Turnpool>> _numTurnpoolFuture;
  late ClientService _clientService;

  String _errorMessage = '';
  String _buttonText = ''; // Variable para almacenar el texto del botón

  @override
  void initState() {
    super.initState();
    _clientService = ClientService();
    _turnPoolFuture = _clientService.getTurnpool(widget.token);
    _numTurnpoolFuture =
        _clientService.getnumTurnpool(widget.idUser, widget.token);
  }

  String formatTime(int num) {
    return num.toString().padLeft(2, '0');
  }

  // Método de recarga al hacer pull-to-refresh
  Future<void> _onRefresh() async {
    setState(() {
      _turnPoolFuture = _clientService.getTurnpool(widget.token);
      _numTurnpoolFuture =
          _clientService.getnumTurnpool(widget.idUser, widget.token);
    });
    await _turnPoolFuture; // Espera a que se recarguen los datos
    await _numTurnpoolFuture;
  }

  void _handleButtonPress() {
    // Lógica cuando el botón es presionado
    if (_buttonText == 'Request a turn for pool') {
      _requestTurn();
    } else if (_buttonText == 'Request a new turn for pool') {
      _requestNewTurn();
    } else if (_buttonText == 'Wait your turn for pool') {
      _waitForTurn();
    } else if (_buttonText == 'It is your turn to play, enjoy the game!') {
      // Mostrar el mensaje en la parte inferior derecha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Press the button "I finished my game" when you finish the game',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 4),
          behavior:
              SnackBarBehavior.floating, // Permite que el Snackbar sea flotante
          margin: EdgeInsets.only(
              bottom: 20,
              right: 20), // Posiciona el SnackBar en la parte inferior derecha
        ),
      );
    } else if (_buttonText == 'I finished my game') {
      _finishGame();
    }
  }

  void _requestTurn() async {
    try {
      // Llamamos al método addTurnpool con el idUser y el token
      String message =
          await _clientService.addTurnpool(widget.idUser, widget.token);

      // Si la respuesta es exitosa, mostramos un mensaje en la parte inferior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('New turn taken, refresh the page'), // Mensaje en inglés
          duration: Duration(seconds: 3), // Duración del mensaje
        ),
      );

      // Opcional: Puedes recargar la página o hacer algo más después de obtener un turno
      _onRefresh(); // Llama a la función de recarga si es necesario
    } catch (e) {
      // En caso de error, mostramos un mensaje de error en la parte inferior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _requestNewTurn() async {
  try {
    // Llamamos al método addTurnpool con el idUser y el token para solicitar un nuevo turno
    String message = await _clientService.addTurnpool(widget.idUser, widget.token);

    // Si la respuesta es exitosa, mostramos un mensaje en la parte inferior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New turn taken, refresh the page'), // Mensaje en inglés
        duration: Duration(seconds: 3), // Duración del mensaje
      ),
    );

    // Opcional: Puedes recargar la página o hacer algo más después de obtener un nuevo turno
    _onRefresh(); // Llama a la función de recarga si es necesario
  } catch (e) {
    // En caso de error, mostramos un mensaje de error en la parte inferior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


  void _waitForTurn() {
    // Lógica para esperar el turno
    print('Esperando turno...');
  }

  void _startGame() {
    // Lógica para iniciar la partida
    print('Iniciando la partida...');
  }

  void _finishGame() async {
  try {
    // Llamamos al método setpoolfree con el token
    String message = await _clientService.setpoolfree(widget.token);

    // Si la respuesta es exitosa, mostramos un mensaje de agradecimiento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for playing our pool game',
          style: TextStyle(fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      ),
    );
    _onRefresh();
  } catch (e) {
    // En caso de error, mostramos un mensaje de error en la parte inferior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error: $e',
          style: TextStyle(fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pool Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/tablero.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Usamos un RefreshIndicator encima de la imagen de fondo
          RefreshIndicator(
            onRefresh: _onRefresh, // Aquí es donde se dispara la recarga
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Fila para los recuadros "Turn Pool" y "Your Turn"
                      FutureBuilder<int>(
                        // FutureBuilder para obtener los datos de Turnpool
                        future: _turnPoolFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                              _errorMessage.isEmpty
                                  ? 'Something went wrong!'
                                  : _errorMessage,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            );
                          } else if (snapshot.hasData) {
                            int turnpool = snapshot.data!;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: EdgeInsets.only(
                                      top: 100,
                                      bottom: 20,
                                      left: 10,
                                      right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Turn Pool: ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        formatTime(turnpool),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Digital7',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: EdgeInsets.only(
                                      top: 100,
                                      bottom: 20,
                                      left: 10,
                                      right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: FutureBuilder<List<Turnpool>>(
                                    future: _numTurnpoolFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          _errorMessage.isEmpty
                                              ? 'Something went wrong!'
                                              : _errorMessage,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        );
                                      } else if (snapshot.hasData) {
                                        List<Turnpool> numTurnpool =
                                            snapshot.data!;
                                        String userTurn = numTurnpool.isNotEmpty
                                            ? formatTime(
                                                numTurnpool.last.idturnpool)
                                            : 'N/D';

                                        // Definir el texto del botón según la situación
                                        String buttonText;
                                        if (userTurn == 'N/D') {
                                          buttonText =
                                              'Request a turn for pool';
                                        } else if (int.parse(userTurn) <
                                            turnpool) {
                                          buttonText =
                                              'Request a new turn for pool';
                                        } else if (int.parse(userTurn) >
                                            turnpool) {
                                          buttonText =
                                              'Wait your turn for pool';
                                        } else {
                                          buttonText =
                                              'It is your turn to play, enjoy the game!';
                                        }

                                        // Utiliza un post-frame callback para ejecutar setState después de la construcción del widget
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            _buttonText = buttonText;
                                          });
                                        });

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Your Turn: ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  userTurn,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Digital7',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text('No data available');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text('No data available');
                          }
                        },
                      ),
                      // El botón ahora está fuera de la fila de rectángulos
                      ElevatedButton(
                        onPressed: _handleButtonPress,
                        child: Text(_buttonText),
                      ),
                      // Mostrar el botón "Terminé mi partida" solo si es el turno del jugador
                      if (_buttonText ==
                          'It is your turn to play, enjoy the game!')
                        ElevatedButton(
                          onPressed: _finishGame,
                          child: Text('I finished my game'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
