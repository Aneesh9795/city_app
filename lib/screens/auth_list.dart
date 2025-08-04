import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dropdown_screen.dart';

class AuthList extends StatefulWidget {
  const AuthList({super.key});

  @override
  State<AuthList> createState() => _AuthListState();
}

class _AuthListState extends State<AuthList> {
  List<dynamic> authList = [];
  bool isLoading = false;
  String? errorMsg;

  Future<void> fetchAuthList() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    final url = Uri.parse('https://superastrologer.com/Testcitty/index');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'auth': 'Bearer b91cc1e43370911555e55ead1706eb78',
        },
        body: jsonEncode({"key": "abc"}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            authList = data;
          });
        } else {
          setState(() {
            errorMsg = 'No data found.';
          });
        }
      } else {
        setState(() {
          errorMsg = 'Failed to load data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth List'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: fetchAuthList,
              icon: const Icon(Icons.download),
              label: const Text("Fetch Auth List"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              if (errorMsg != null)
                Center(child: Text(
                    errorMsg!, style: const TextStyle(color: Colors.red)))
              else
                if (authList.isEmpty)
                  const Center(child: Text("No data available"))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: authList.length,
                      itemBuilder: (context, index) {
                        final item = authList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text('Name: ${item['name'] ?? 'N/A'}'),
                            subtitle: Text('ID: ${item['id'] ?? 'Unknown'}'),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),

      // 👇 Bottom fixed button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DropdownScreen()),
            );
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Go to Next Screen"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size.fromHeight(50), // full-width button
          ),
        ),
      ),
    );
  }
}