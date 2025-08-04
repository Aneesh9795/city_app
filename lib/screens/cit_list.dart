import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CityList extends StatefulWidget {
  const CityList({super.key});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<dynamic> cityList = [];
  int page = 1;
  bool isLoading = false;
  bool isLastPage = false;
  String keyword = "agra";

  @override
  void initState() {
    super.initState();
    fetchCityData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          !isLastPage) {
        page++;
        fetchCityData();
      }
    });
  }

  Future<void> fetchCityData({bool isNewSearch = false}) async {
    setState(() => isLoading = true);

    if (isNewSearch) {
      page = 1;
      cityList.clear();
      isLastPage = false;
    }

    final url = Uri.parse('http://superastrologer.com/api/v1/customer/city/listdata');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "search": keyword,
        "page": page,
        "limit": 10,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> newCities = data["data"] ?? [];

      setState(() {
        cityList.addAll(newCities);
        if (newCities.length < 10) {
          isLastPage = true;
        }
      });
    } else {
      // Error
      print("Error: ${response.body}");
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City List"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search city",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (value) {
                keyword = value.trim().isEmpty ? "agra" : value.trim();
                fetchCityData(isNewSearch: true);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: cityList.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < cityList.length) {
                    final city = cityList[index];
                    return ListTile(
                      title: Text(city["name"] ?? "No name"),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
