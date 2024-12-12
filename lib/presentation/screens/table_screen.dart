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
  List<Reservetable> reservedTables = []; 
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
        snackBarMessage = null; 
      });
    }
  }

  Future<void> _fetchTodayReservations() async {
    try {
      final reserves = await waiterService.fetchAllTables(widget.token);

      DateTime now = DateTime.now()
          .toLocal(); 

      List<Reservetable> todayReservedTables = reserves.where((reserve) {
        DateTime reservationDateTime =
            DateTime.parse(reserve.reservationHour.toString()).toLocal();

        return reserve.occupy == true &&
            reservationDateTime.year == now.year &&
            reservationDateTime.month == now.month &&
            reservationDateTime.day == now.day;
      }).toList();

      setState(() {
        reservedTables = todayReservedTables; 
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

  Reservetable? _getClosestReservation(int tableNumber) {
    DateTime now = DateTime.now().toLocal();
    List<Reservetable> tableReservations = reservedTables
        .where((reserve) => reserve.numTable == tableNumber)
        .toList();

    if (tableReservations.isEmpty) return null;

    List<Reservetable> validReservations = tableReservations.where((reserve) {
      DateTime reservationTime =
          DateTime.parse(reserve.reservationHour.toString()).toLocal();
      return reservationTime.isBefore(now) ||
          reservationTime.isAtSameMomentAs(now);
    }).toList();

    if (validReservations.isEmpty) return null;

    validReservations.sort((a, b) {
      DateTime aTime = DateTime.parse(a.reservationHour.toString()).toLocal();
      DateTime bTime = DateTime.parse(b.reservationHour.toString()).toLocal();
      return aTime.compareTo(bTime); 
    });

    return validReservations.last;
  }

  Future<void> _freeTable(int tableNumber) async {
    try {
      Reservetable? closestReservation = _getClosestReservation(tableNumber);

      if (closestReservation != null) {
        String message = await waiterService.settablefree(
            closestReservation.idTable, widget.token);
        setState(() {
          snackBarMessage = 'Table free now'; 
          reservedTables.remove(closestReservation); 
        });
        
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
                Navigator.of(context).pop(); 
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _freeTable(tableNumber);  
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

    bool isReserved = reservedTables.any((reserve) {
      return reserve.numTable == index + 1 && reserve.occupy == true;
    });

    return Align(
      alignment: Alignment(dx, dy),
      child: GestureDetector(
        onTap: () {
          if (isReserved) {
            _showFreeTableDialog(index + 1); 
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
                    ? Colors.transparent 
                    : (selectedTable == index + 1
                        ? Colors.blue.withOpacity(0.7)  
                        : Colors.grey.withOpacity(0.3)),  
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isReserved
                      ? Colors.transparent  
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
                    ? Colors.black  
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
