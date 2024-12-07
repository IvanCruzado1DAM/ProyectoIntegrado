import 'package:BarDamm/models/reservetable.dart';
import 'package:flutter/material.dart';
import 'package:BarDamm/presentation/screens/user_screen.dart';
import 'package:BarDamm/services/client_services.dart';
import 'package:BarDamm/models/drink.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart'; // Asegúrate de importar intl para formatear fechas y horas.

class MenuScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const MenuScreen({Key? key, required this.token, required this.idUser, required this.username})
      : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<Drink> allDrinks = [];
  List<Reservetable> allReserves = [];
  final ClientService _clientService = ClientService();
  Map<Drink, int> selectedDrinks = {};
  bool hasReservation = false;
  double totalPrice = 0.0;

  Future<void> fetchDrinks() async {
    try {
      List<Drink> drinks = await _clientService.fetchAllDrinks(widget.token);
      List<Reservetable> reserves = await _clientService.fetchAllReservesbyClient(widget.token, widget.idUser);

      // Obtén la fecha y hora actuales
      DateTime now = DateTime.now();

      // Filtrar las reservas para el usuario que sean del mismo día y cuya hora no haya pasado
    List<Reservetable> validReserves = reserves.where((reserve) {
      if (reserve.idClient == widget.idUser) {
        DateTime reservationDateTime = DateTime.parse(reserve.reservationHour.toString());

        // Comprobar que la reserva sea del mismo día y que la hora sea anterior a la actual
        return reservationDateTime.year == now.year &&
               reservationDateTime.month == now.month &&
               reservationDateTime.day == now.day &&
               reservationDateTime.isBefore(now);
      }
      return false;
    }).toList();

    bool reservationExists = false;
    // Si hay reservas válidas, buscar la más cercana
    if (validReserves.isNotEmpty) {
      reservationExists = true;
      // Ordenar las reservas válidas por la proximidad a la hora actual (más cercana sin pasarse)
      validReserves.sort((a, b) {
        DateTime aTime = DateTime.parse(a.reservationHour.toString());
        DateTime bTime = DateTime.parse(b.reservationHour.toString());
        return aTime.compareTo(bTime);
      });

      // La primera reserva de la lista será la más cercana sin pasarse
      hasReservation = true;
    } else {
      hasReservation = false;  // Si no hay reservas válidas, entonces no se puede hacer pedido
    }

      setState(() {
        allDrinks = drinks;
        allReserves = reserves;
        hasReservation = reservationExists; // Actualiza si el usuario tiene una reserva activa
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load drinks and reservations: $e';
        isLoading = false;
      });
    }
  }

  Map<String, List<Drink>> groupDrinksByCategory() {
    Map<String, List<Drink>> groupedDrinks = {};
    for (var drink in allDrinks) {
      if (groupedDrinks.containsKey(drink.drinkcategory)) {
        groupedDrinks[drink.drinkcategory]!.add(drink);
      } else {
        groupedDrinks[drink.drinkcategory] = [drink];
      }
    }
    return groupedDrinks;
  }

  void updateTotalPrice() {
    double newTotal = selectedDrinks.entries.fold(0, (sum, entry) {
      return sum + (entry.key.drinkprice * entry.value);
    });
    setState(() {
      totalPrice = newTotal;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDrinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks Menu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : buildDrinkMenuWithOrder(),
    );
  }

  Widget buildDrinkMenuWithOrder() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              for (var category in groupDrinksByCategory().keys)
                _buildCategoryExpansionTile(category),
            ],
          ),
        ),
        // El botón de pedido solo se mostrará si hay una reserva activa
        if (hasReservation)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (selectedDrinks.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select at least one drink to order.')),
                  );
                } else {
                  confirmOrder();
                }
              },
              label: Text('Order - €${totalPrice.toStringAsFixed(2)}'),
              icon: Icon(Icons.shopping_cart),
              backgroundColor: Colors.green,
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryExpansionTile(String category) {
    List<Drink> drinksInCategory = groupDrinksByCategory()[category]!;
    bool isFirstCategory = groupDrinksByCategory().keys.toList().indexOf(category) == 0;

    return ExpansionTile(
      title: Text(
        category,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      initiallyExpanded: isFirstCategory,
      backgroundColor: Colors.blueGrey.shade50,
      leading: Icon(
        isFirstCategory ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: Colors.blueAccent,
      ),
      children: drinksInCategory.map((drink) {
        Uint8List imageBytes = Uint8List.fromList(drink.drinkimage);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: MemoryImage(imageBytes),
              ),
              title: Text(
                drink.drinkname,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${drink.drinkprice} €',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    drink.drinkdescription ?? 'No description available',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: hasReservation
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedDrinks.containsKey(drink) && selectedDrinks[drink]! > 0) {
                                selectedDrinks[drink] = selectedDrinks[drink]! - 1;
                                if (selectedDrinks[drink] == 0) {
                                  selectedDrinks.remove(drink);
                                }
                              }
                              updateTotalPrice();
                            });
                          },
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                        ),
                        Text('${selectedDrinks[drink] ?? 0}', style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDrinks[drink] = (selectedDrinks[drink] ?? 0) + 1;
                              updateTotalPrice();
                            });
                          },
                          icon: Icon(Icons.add_circle, color: Colors.green),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  void confirmOrder() {
    try {
    // Preparar la lista de bebidas seleccionadas como un string separado por comas
    String drinks = selectedDrinks.entries
        .map((entry) => '${entry.key.drinkname} x${entry.value}')
        .join(', ');

    // Obtener el número de mesa de la reserva del usuario
    DateTime now = DateTime.now();
    int idTable = 0;
    int numTable = 0; // Valor por defecto si no hay reservas válidas.
    List<Reservetable> validReserves = allReserves.where((reserve) {
      if (reserve.idClient == widget.idUser) {
        DateTime reservationDateTime = DateTime.parse(reserve.reservationHour.toString());
        return reservationDateTime.year == now.year &&
               reservationDateTime.month == now.month &&
               reservationDateTime.day == now.day &&
               reservationDateTime.isBefore(now);
      }
      return false;
    }).toList();

    if (validReserves.isNotEmpty) {
      validReserves.sort((a, b) {
        DateTime aTime = DateTime.parse(a.reservationHour.toString());
        DateTime bTime = DateTime.parse(b.reservationHour.toString());
        return aTime.compareTo(bTime);
      });

      setState(() {
          numTable = validReserves.last.numTable;
          idTable = validReserves.last.idTable; // Asumiendo que idTable existe en Reservetable
        });
    } else {
      throw Exception('No valid reservations found.');
    }

    // Llamar al método `addOrderr` del servicio
    _clientService.addOrderr(
      drinks: drinks,
      numtable: numTable,
      total: totalPrice,
      token: widget.token,
    );

    // Mostrar un mensaje de éxito y limpiar la selección
    setState(() {
      selectedDrinks.clear();
      totalPrice = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));
    showPaymentOptions(drinks, numTable, idTable);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
  }
  }

  void showPaymentOptions(String drinks, int numTable, int idTable) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildPaymentOptionCard(
                    title: 'Cash',
                    imagePath: 'assets/images/cash.png', // Ruta de tu imagen de efectivo
                    onTap: () {
                      Navigator.pop(context); // Cierra el diálogo
                      handleWantToPay('Cash', idTable);
                    },
                  ),
                  buildPaymentOptionCard(
                    title: 'Card',
                    imagePath: 'assets/images/card.png', // Ruta de tu imagen de tarjeta
                    onTap: () {
                      Navigator.pop(context); // Cierra el diálogo
                      handleWantToPay('Card', idTable);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildPaymentOptionCard({
  required String title,
  required String imagePath,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 60,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> handleWantToPay(String paymentMethod, int idTable) async {
  try {
    String response = await _clientService.wanttopay(idTable, widget.token);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment confirmed via $paymentMethod. Server says: $response')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to confirm payment: $e')),
    );
  }
}
}
