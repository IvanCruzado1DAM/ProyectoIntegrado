import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:BarDamm/models/reservetable.dart';
import 'package:BarDamm/services/waiter_services.dart';

class WantsToPayScreen extends StatefulWidget {
  final String token;
  final int userId;

  const WantsToPayScreen({Key? key, required this.token, required this.userId}) : super(key: key);

  @override
  State<WantsToPayScreen> createState() => _WantsToPayScreenState();
}

class _WantsToPayScreenState extends State<WantsToPayScreen> {
  late Future<List<Reservetable>> _tablesFuture;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  void _loadTables() {
    _tablesFuture = _fetchWantsToPayTables(widget.token);
  }

  Future<List<Reservetable>> _fetchWantsToPayTables(String token) async {
    final waiterService = WaiterService();
    final allTables = await waiterService.fetchAllTables(token);

    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    return allTables.where((table) {
      final reservationDate = DateFormat('yyyy-MM-dd').format(table.reservationHour);
      return table.wanttopay == true &&
          reservationDate == today &&
          table.reservationHour.isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables Wanting to Pay'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadTables(); 
          });
          
          await _tablesFuture;
        },
        child: FutureBuilder<List<Reservetable>>(
          future: _tablesFuture,
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
                  'No tables want to pay at the moment.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              final tables = snapshot.data!;

              return ListView.builder(
                itemCount: tables.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final table = tables[index];

                  return Card(
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
                                  'Table: ${table.numTable}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Reservation Time: ${DateFormat('hh:mm a').format(table.reservationHour)}',
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.payment,
                            color: Colors.green,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
