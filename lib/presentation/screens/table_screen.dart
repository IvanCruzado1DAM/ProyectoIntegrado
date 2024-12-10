import 'package:BarDamm/services/waiter_services.dart';
import 'package:flutter/material.dart';
import 'package:BarDamm/services/client_services.dart';
import 'package:intl/intl.dart';
import 'package:BarDamm/models/reservetable.dart';

class TableScreen extends StatefulWidget {
  final String token;
  final int userId;

  const TableScreen({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int? selectedTable;
  List<Reservetable> reservedTables = []; // Lista de reservas para hoy
  late ClientService clientServices;
  late WaiterService waiterService;
  bool isLoading = true;
  String? snackBarMessage;

  @override
  void initState() {
    super.initState();
    clientServices = ClientService();
    waiterService = WaiterService();
    _fetchTodayReservations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (snackBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackBarMessage!)),
        );
        snackBarMessage = null; // Limpiar mensaje
      });
    }
  }

  Future<void> _fetchTodayReservations() async {
    try {
      final reserves = await waiterService.fetchAllTables(widget.token);

      DateTime now = DateTime.now()
          .toLocal(); // Asegurar que la hora actual esté en la zona horaria local

      // Filtrar las reservas del día de hoy con occupy == true y antes de la hora actual
      List<Reservetable> todayReservedTables = reserves.where((reserve) {
        // Convertir reservationHour a DateTime
        DateTime reservationDateTime =
            DateTime.parse(reserve.reservationHour.toString()).toLocal();

        // Comprobar que la reserva sea del mismo día, anterior a la hora actual y que esté ocupada
        return reserve.occupy == true &&
            reservationDateTime.year == now.year &&
            reservationDateTime.month == now.month &&
            reservationDateTime.day == now.day;
      }).toList();

      setState(() {
        reservedTables = todayReservedTables; // Actualizar las mesas reservadas
        isLoading = false;
      });
    } catch (e) {
      if (e.toString().contains('redirecting to')) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          isLoading = false;
          snackBarMessage = 'Failed to load reservations: $e';
        });
      }
    }
  }

  // Método para encontrar la reserva más cercana
  Reservetable? _getClosestReservation(int tableNumber) {
    DateTime now = DateTime.now().toLocal();
    List<Reservetable> tableReservations = reservedTables
        .where((reserve) => reserve.numTable == tableNumber)
        .toList();

    if (tableReservations.isEmpty) return null;

    // Filtrar las reservas que no son posteriores a la hora actual
    List<Reservetable> validReservations = tableReservations.where((reserve) {
      DateTime reservationTime =
          DateTime.parse(reserve.reservationHour.toString()).toLocal();
      return reservationTime.isBefore(now) ||
          reservationTime.isAtSameMomentAs(now);
    }).toList();

    // Si no hay reservas válidas
    if (validReservations.isEmpty) return null;

    // Ordenar las reservas válidas por hora, de más cercana a más lejana
    validReservations.sort((a, b) {
      DateTime aTime = DateTime.parse(a.reservationHour.toString()).toLocal();
      DateTime bTime = DateTime.parse(b.reservationHour.toString()).toLocal();
      return aTime.compareTo(bTime); // Ascendente
    });

    // Devuelve la última reserva válida (la más cercana a la hora actual)
    return validReservations.last;
  }

  // Método para liberar la mesa
  Future<void> _freeTable(int tableNumber) async {
    try {
      // Encontramos la reserva más cercana para la mesa seleccionada
      Reservetable? closestReservation = _getClosestReservation(tableNumber);

      if (closestReservation != null) {
        String message = await waiterService.settablefree(
            closestReservation.idTable, widget.token);
        setState(() {
          snackBarMessage = 'Table free now'; // Mostrar mensaje de éxito
          reservedTables.remove(closestReservation); // Eliminar la reserva de la lista
        });
        // Mostrar mensaje con el resultado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table free now')),
        );
      } else {
        setState(() {
          snackBarMessage = 'No valid reservation found to free this table.';
        });
      }
    } catch (e) {
      setState(() {
        snackBarMessage = 'Failed to free table: $e';
      });
    }
  }

  // Mostrar el diálogo para liberar la mesa
  void _showFreeTableDialog(int tableNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Set Table Free"),
          content: const Text("Do you want to set this table free?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _freeTable(tableNumber); // Liberar la mesa
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserved Tables'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Today\'s Reserved Tables',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    child: Stack(
                      children: [
                        _buildTableIcon(0, 'Table 1', -1, 0),
                        _buildTableIcon(1, 'Table 2', 0, -1),
                        _buildTableIcon(2, 'Table 3', 1, 0),
                        _buildTableIcon(3, 'Table 4', 0, 1),
                        _buildTableIcon(4, 'Table 5', 0, 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableIcon(int index, String label, double dx, double dy) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Verificar si alguna reserva de la mesa está ocupada
    bool isReserved = reservedTables.any((reserve) {
      return reserve.numTable == index + 1 && reserve.occupy == true;
    });

    return Align(
      alignment: Alignment(dx, dy),
      child: GestureDetector(
        onTap: () {
          if (isReserved) {
            _showFreeTableDialog(index + 1); // Mostrar opción para liberar mesa
          } else {
            setState(() {
              selectedTable = index + 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label selected')),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                color: isReserved
                    ? Colors.transparent // Sin color de fondo para las mesas reservadas
                    : (selectedTable == index + 1
                        ? Colors.blue.withOpacity(0.7) // Mesa seleccionada en azul
                        : Colors.grey.withOpacity(0.3)), // Mesa disponible en gris
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isReserved
                      ? Colors.transparent // Sin borde para las mesas reservadas
                      : (selectedTable == index + 1
                          ? Colors.blue
                          : Colors.grey),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.table_restaurant,
                size: screenWidth * 0.1,
                color: isReserved
                    ? Colors.black // Color del icono de mesa reservada
                    : (selectedTable == index + 1
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            isReserved
                ? const Text(
                    'Reserved',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: selectedTable == index + 1
                          ? Colors.blue
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
