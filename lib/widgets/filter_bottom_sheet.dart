import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/property_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedType = "Sell";
  String? _selectedCountry;
  String? _selectedCity;
  double _minPrice = 0;
  double _maxPrice = 1000000;

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final filterOptions = propertyProvider.filterOptions;

    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                languageProvider.translate('filters'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type
                  Text(languageProvider.translate('property_type')),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    hint: Text("Select Item"), // 👈 default text
                    items: propertyProvider.types.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16),

                  // Price Range
                  Text(languageProvider.translate('price_range')),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: filterOptions?.priceRange.min ?? 0,
                    max: filterOptions?.priceRange.max ?? 1000000,
                    divisions: 10,
                    labels: RangeLabels(
                      '\$${_minPrice.toStringAsFixed(0)}',
                      '\$${_maxPrice.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_minPrice.toStringAsFixed(0)}'),
                      Text('\$${_maxPrice.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _selectedCountry = null;
                      _selectedCity = null;
                      _minPrice = filterOptions?.priceRange.min ?? 0;
                      _maxPrice = filterOptions?.priceRange.max ?? 1000000;
                    });
                    propertyProvider.clearFilters();
                  },
                  child: Text(languageProvider.translate('clear_all')),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    propertyProvider.filterProperties({
                      'type': _selectedType,
                      'country': _selectedCountry,
                      'city': _selectedCity,
                      'minPrice': _minPrice,
                      'maxPrice': _maxPrice,
                    });
                    Navigator.pop(context);
                  },
                  child: Text(languageProvider.translate('apply_filters')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
