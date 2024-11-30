import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:BarDamm/services/client_services.dart';
import 'user_screen.dart'; 

class CvScreen extends StatefulWidget {
  final String token;
  final int userId;
  final String username;
  

  const CvScreen({Key? key, required this.token, required this.userId,required this.username })
      : super(key: key);

  @override
  _CvSubmissionScreenState createState() => _CvSubmissionScreenState();
}

class _CvSubmissionScreenState extends State<CvScreen> {
  File? _selectedFile;
  final ClientService _clientService = ClientService();

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submitCv(int userId, String username) async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file before submitting')),
      );
      return;
    }

    try {
      bool accept = false;
      await _clientService.submitCv(widget.token, _selectedFile!, userId, accept, username);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('CV submitted successfully! Redirecting in 3 seconds...'),
          duration: Duration(seconds: 3), 
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserScreen(
              token: widget.token,
              idUser: widget.userId,
              username: widget.username,
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting CV: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Our Team'),
          backgroundColor: const Color(0xff142047),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserScreen(
                    token: widget.token,
                    idUser: widget.userId,
                    username: widget.username,
                  ),
                ),
              );
            },
          ),
        ),
        body: Padding(
            padding:
                const EdgeInsets.all(16.0), 
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Do you want to work with us as a waiter?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please upload your CV in PDF format. We are excited to have you on our team!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/camareros.jpg',
                  width: screenWidth * 0.9, 
                  height: screenHeight * 0.4, 
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Select CV (PDF)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedFile != null)
                Text(
                  'Selected file: ${_selectedFile!.path.split('/').last}',
                  style: const TextStyle(color: Colors.green),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _submitCv(widget.userId, widget.username),
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserScreen(
                        token: widget.token,
                        idUser: widget.userId,
                        username: widget.username,
                      ),
                    ),
                  );
                },
                child: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ])));
  }
}
