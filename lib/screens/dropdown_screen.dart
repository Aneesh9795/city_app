import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/city_model.dart';
import '../apis/api_service.dart';
import 'cit_list.dart';

class DropdownScreen extends StatefulWidget {
  const DropdownScreen({Key? key}) : super(key: key);

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  final TextEditingController _controller = TextEditingController();
  CityModel? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Search'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField<CityModel>(
              debounceDuration: const Duration(milliseconds: 200), // ✅ custom debounce here
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Search city',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (String pattern) async {
                if (pattern.length < 1) return []; // don't search on empty
                return await ApiService.fetchCities(pattern);
              },
              itemBuilder: (context, CityModel city) {
                return ListTile(title: Text(city.address));
              },
              onSuggestionSelected: (CityModel city) {
                setState(() {
                  _selectedCity = city;
                  _controller.text = city.address;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${city.address}')),
                );
              },
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No city found'),
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                constraints: const BoxConstraints(maxHeight: 250),
              ),
              suggestionsBoxVerticalOffset: 10,
            ),

            const SizedBox(height: 20),

            if (_selectedCity != null)
              Text(
                'Selected City:\n${_selectedCity!.address} (ID: ${_selectedCity!.id})',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CityList()),
            );

          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Go to Next Screen"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size.fromHeight(50),
            ),
        ),
      )
    );
  }
}


