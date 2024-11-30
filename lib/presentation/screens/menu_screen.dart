import 'package:flutter/material.dart';
import 'package:flutter_application_bardamm/presentation/screens/user_screen.dart';
import 'package:flutter_application_bardamm/services/client_services.dart';
import 'package:flutter_application_bardamm/models/drink.dart';
import 'dart:typed_data'; 

class MenuScreen extends StatefulWidget {
  final String token;  
  final int idUser;
  final String username;
  

  const MenuScreen({Key? key, required this.token, required this.idUser,required this.username })
      : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<Drink> allDrinks = [];
  final ClientService _clientService = ClientService();

  Future<void> fetchDrinks() async {
    try {
      List<Drink> drinks = await _clientService.fetchAllDrinks(widget.token);
      setState(() {
        allDrinks = drinks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load drinks: $e';
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
        backgroundColor: const Color(0xff142047),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserScreen(token: widget.token, idUser: widget.idUser, username: widget.username,),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView( 
                  child: Column(
                    children: [
                      for (var category in groupDrinksByCategory().keys) 
                        _buildCategoryExpansionTile(category),
                    ],
                  ),
                ),
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
            ),
          ),
        );
      }).toList(),
    );
  }
}
