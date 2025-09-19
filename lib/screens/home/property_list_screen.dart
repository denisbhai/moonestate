import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:moonestate/utils/image_utilies.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/property_card.dart';
import 'property_detail_screen.dart';
import 'map_view_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isMapView = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<PropertyProvider>(
        context,
        listen: false,
      ).fetchProperties(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          width: 250,
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children:  [
              DrawerHeader(
                child: CircleAvatar(
                  radius: 50,
                  child: Image.asset(AssetsImage.app_logo),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 90),
                  child: Image.asset(AssetsImage.home),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: 342,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // shadow color
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Sell',
                                    groupValue: propertyProvider.selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        propertyProvider.selectedOption =
                                            value!;
                                      });
                                    },
                                  ),
                                   Text(languageProvider.translate(
                                    'sell',
                                  )),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ), // space between options
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Rent',
                                    groupValue: propertyProvider.selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        propertyProvider.selectedOption =
                                            value!;
                                      });
                                    },
                                  ),
                                   Text(languageProvider.translate(
                                     'rent',
                                   )),
                                ],
                              ),
                            ],
                          ),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: languageProvider.translate(
                                'search_properties',
                              ),
                              prefixIcon: Image.asset(
                                AssetsImage.carbon_location,
                                scale: 4,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(
                                    0xffF0F0F0,
                                  ), // color when not focused
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(
                                    0xffF0F0F0,
                                  ), // color when focused
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              propertyProvider.searchText = value;
                            },
                          ),
                          const SizedBox(height: 20), // space between options
                          ElevatedButton(
                            onPressed: () {
                              log("selectedOption===${propertyProvider.selectedOption}");
                              propertyProvider.searchProperties(propertyProvider.searchText);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff08184B),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              languageProvider.translate('search'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer(); // 👈 opens the drawer
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => FilterBottomSheet(),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              languageProvider.translate('filters'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.filter_list, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _isMapView
                  ? MapViewScreen(properties: propertyProvider.properties)
                  : propertyProvider.isLoading &&
                        propertyProvider.properties.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : propertyProvider.properties.isEmpty
                  ? Center(
                      child: Text(
                        languageProvider.translate('no_properties_found'),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "See All",
                                    style: TextStyle(
                                      color: Color(0xff7065EF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              controller: _scrollController,
                              itemCount: propertyProvider.properties.length + 1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index <
                                    propertyProvider.properties.length) {
                                  final property =
                                      propertyProvider.properties[index];
                                  return PropertyCard(
                                    property: property,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PropertyDetailScreen(
                                                id: property.id,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return propertyProvider.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
