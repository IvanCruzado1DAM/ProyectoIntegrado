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

            return RefreshIndicator(
              onRefresh: _refreshOrders, 
              child: ListView.builder(
                itemCount: orders.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return GestureDetector(
                    onTap: () {
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
                                  FutureBuilder<bool>(
                                    future: _isReservationConfirmed(
                                        order.idreservetable),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          'Checking reservation...',
                                          style: TextStyle(color: Colors.grey),
                                        ); 
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                          'Error checking reservation',
                                          style: TextStyle(color: Colors.red),
                                        ); 
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
              ),
            );
          }
        },
      ),
    );
  }

  Future<bool> _isReservationConfirmed(int reservationId) async {
    try {
      final waiterServices = WaiterService();
      final reserves = await waiterServices.fetchAllTables(widget.token);

      final reservation =
          reserves.firstWhere((reserve) => reserve.idTable == reservationId);

      if (reservation == null) {
        return false;
      }

      return reservation.occupy;
    } catch (e) {
      print('Error fetching reservation: $e');
      return false;
    }
  }

  Future<void> _refreshOrders() async {
    final waiterServices = WaiterService();
    try {
      final updatedOrders = waiterServices.fetchAllOrders(widget.token);
      setState(() {
        _ordersFuture = Future.value(updatedOrders);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error refreshing orders: $e')),
      );
    }
  }

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
                      Navigator.pop(context); 
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: const Text('Confirm Assist'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _collectMoney(order);
                      Navigator.pop(context); 
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

  Future<void> _confirmAssist(Orderr order) async {
    final waiterService = WaiterService(); 

    try {
      final isAlreadyConfirmed =
          await _isReservationConfirmed(order.idreservetable);

      if (isAlreadyConfirmed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assist already confirmed'),
            backgroundColor: Colors.orange,
          ),
        );
        return; 
      }

      final responseMessage =
          await waiterService.confirmAssist(order.idreservetable, widget.token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseMessage),
          backgroundColor: Colors.green,
        ),
      );

      await _refreshOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error confirming assistance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _collectMoney(Orderr order) {
    final waiterService = WaiterService(); 

    _isReservationConfirmed(order.idreservetable).then((isConfirmed) {
      if (!isConfirmed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to confirm assistance first.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        try {
          final responseMessage =
              waiterService.payOrder(order.idorder, widget.token);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Order paid successfully, please refresh the screen'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking assistance: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
