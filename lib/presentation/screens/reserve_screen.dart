import 'package:flutter/material.dart';
import 'package:flutter_application_bardamm/presentation/screens/user_screen.dart';
import 'package:flutter_application_bardamm/services/client_services.dart';
import 'package:intl/intl.dart';

class ReserveScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const ReserveScreen({Key? key, required this.token, required this.idUser, required this.username})
      : super(key: key);

  @override
  _ReserveScreenState createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  int? selectedTable;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  late ClientService clientServices;

  @override
  void initState() {
    super.initState();
    clientServices = ClientService();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve a Table'),
        backgroundColor: const Color(0xff142047),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserScreen(
                  token: widget.token,
                  idUser: widget.idUser,
                  username: widget.username,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose a Table to Reserve',
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
                  const SizedBox(height: 20),
                  if (selectedDate != null && selectedTime != null)
                    Text(
                      'Reservation: ${_formatDateTime(selectedDate!, selectedTime!)}',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedTable != null && selectedDate != null && selectedTime != null)
                  ElevatedButton(
                    onPressed: () async {
                      final reservationDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      final reserves = await clientServices.fetchAllReserves(widget.token);

                      bool isReserved = false;

                      for (var reserve in reserves) {
                        if (reserve.idTable == selectedTable &&
                            reserve.reservationHour == reservationDateTime) {
                          isReserved = true;
                          break;
                        }
                      }

                      if (isReserved) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('The table is already reserved at this time.')),
                        );
                      } else {
                        final result = await clientServices.reserveTable(
                          token: widget.token,
                          numTable: selectedTable!,
                          idClient: widget.idUser,
                          reservationHour: reservationDateTime,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                          ),
                        );
                      }
                    },
                    child: const Text('Reserve Table'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      primary: Colors.green,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableIcon(int index, String label, double dx, double dy) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment(dx, dy),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            selectedTable = index + 1;
          });
          DateTime? datePicked = await _selectDate(context);
          if (datePicked != null) {
            setState(() {
              selectedDate = datePicked;
            });
            TimeOfDay? timePicked = await _selectTime(context); // Usar el dialog personalizado
            if (timePicked != null) {
              setState(() {
                selectedTime = timePicked;
              });
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                color: selectedTable == index + 1
                    ? Colors.blue.withOpacity(0.7)
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedTable == index + 1 ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.table_restaurant,
                size: screenWidth * 0.1,
                color: selectedTable == index + 1 ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selectedTable == index + 1 ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  // Función para mostrar solo las horas en punto
  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    // Lista de horas en punto que queremos mostrar (de 08:00 AM a 10:00 PM)
    List<TimeOfDay> availableTimes = List.generate(24, (index) {
      return TimeOfDay(hour: index, minute: 0); // solo horas en punto
    }).where((time) => time.hour >= 8 && time.hour <= 22).toList(); // Limitar a las 8AM - 10PM

    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Time"),
          content: SizedBox(
            height: 200,
            width: 100,
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                TimeOfDay time = availableTimes[index];
                return ListTile(
                  title: Text('${time.format(context)}'),
                  onTap: () {
                    Navigator.pop(context, time);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
  final DateTime combinedDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  // Aquí se convierte a un formato sin "T" ni milisegundos
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  return dateFormat.format(combinedDateTime);  // Devuelve la fecha con formato adecuado
}


}
