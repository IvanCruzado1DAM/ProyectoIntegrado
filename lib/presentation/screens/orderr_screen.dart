import 'package:flutter/material.dart';
import 'package:BarDamm/models/orderr.dart';
import 'package:BarDamm/services/waiter_services.dart';

class OrdersScreen extends StatefulWidget {
  final String token;
  final int userId;

  const OrdersScreen({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Orderr>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    final waiterServices = WaiterService();
    _ordersFuture = waiterServices.fetchAllOrders(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Orderr>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No orders found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            // Filtrar las órdenes donde `paid` es `false`.
            final orders =
                snapshot.data!.where((order) => !order.paid).toList();

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  'No unpaid orders found',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final order = orders[index];

                return GestureDetector(
                  onTap: () {
                    // Al seleccionar una orden, mostramos el BottomSheet con las opciones
                    _showOrderOptions(context, order);
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Table: ${order.numtable}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Drinks: ${order.drinks}'),
                                const SizedBox(height: 5),
                                // Texto explicativo sobre la confirmación de la reserva
                                FutureBuilder<bool>(
                                  future: _isReservationConfirmed(
                                      order.idreservetable),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                        'Checking reservation...',
                                        style: TextStyle(color: Colors.grey),
                                      ); // Indicador de carga
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                        'Error checking reservation',
                                        style: TextStyle(color: Colors.red),
                                      ); // Mensaje de error
                                    } else {
                                      final isConfirmed =
                                          snapshot.data ?? false;
                                      return Row(
                                        children: [
                                          Icon(
                                            isConfirmed
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: isConfirmed
                                                ? Colors.green
                                                : Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            isConfirmed
                                                ? 'Reservation Confirmed'
                                                : 'Reservation Not Confirmed',
                                            style: TextStyle(
                                              color: isConfirmed
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Función para verificar si la reserva está confirmada
  Future<bool> _isReservationConfirmed(int reservationId) async {
    try {
      final waiterServices = WaiterService();

      // Obtener todas las reservas
      final reserves = await waiterServices.fetchAllTables(widget.token);

      // Buscar la reserva con el id especificado
      final reservation =
          reserves.firstWhere((reserve) => reserve.idTable == reservationId);

      // Si no se encuentra la reserva, retornamos false por defecto
      if (reservation == null) {
        return false;
      }

      // Retornar el estado del atributo `occupy`
      return reservation.occupy;
    } catch (e) {
      // Manejo de errores
      print('Error fetching reservation: $e');
      return false;
    }
  }

  // Función para mostrar el BottomSheet con las opciones
  void _showOrderOptions(BuildContext context, Orderr order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options for Table ${order.numtable}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _confirmAssist(order);
                      Navigator.pop(context); // Cerrar el BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: const Text('Confirm Assist'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _collectMoney(order);
                      Navigator.pop(context); // Cerrar el BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: const Text('Collect Money'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para confirmar asistencia
  void _confirmAssist(Orderr order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Assistance confirmed for Table ${order.numtable}')),
    );
  }

  // Función para cobrar dinero
  void _collectMoney(Orderr order) {
    final waiterService = WaiterService(); // Instancia de WaiterService

    try {
      // Llamar al método payOrder
      final responseMessage =
          waiterService.payOrder(order.idorder, widget.token);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order paid successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
