import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../models/propertyDetails.dart' hide Property;
import '../services/api_service.dart';
import '../models/property.dart';
import '../models/review.dart';
import '../models/filter.dart';

class PropertyProvider with ChangeNotifier {
  List<PropertyElement> _properties = [];
  List<PropertyElement> _filteredProperties = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  FilterOptions? _filterOptions;
  PropertyDetails? _propertyDetails;

  PropertyDetails? get propertyDetails => _propertyDetails;

  set propertyDetails(PropertyDetails? value) {
    _propertyDetails = value;
    notifyListeners();
  }

  String _searchQuery = '';

  String _selectedOption = 'Sell';

  String get selectedOption => _selectedOption;

  set selectedOption(String value) {
    _selectedOption = value;
    notifyListeners();
  }

  List<PropertyElement> get properties => _filteredProperties;
  bool get isLoading => _isLoading;
  FilterOptions? get filterOptions => _filterOptions;

  PropertyProvider() {
    fetchProperties();
  }

  Future<void> fetchProperties({bool loadMore = false}) async {
    if (!loadMore) {
      _currentPage = 1;
      log("_currentPage====_currentPage$loadMore");
      _hasMore = true;
      _properties.clear();
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        'api/properties?page=$_currentPage',
      );

      log("response===response==$response");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Property newProperties = Property.fromJson(data);

        _properties.addAll(newProperties.data.properties);
        _filteredProperties = _properties;

        _hasMore = data['next_page_url'] != null;
        _currentPage++;
      }
    } catch (error) {
      print('Error fetching properties: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFilterOptions() async {
    try {
      final response = await ApiService.get('api/filter');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _filterOptions = FilterOptions.fromJson(data);
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching filter options: $error');
    }
  }

  double parsePrice(String price) {
    price = price.replaceAll('\$', '').replaceAll(',', '').trim();

    // Handle "million" and "k" cases
    if (price.toLowerCase().contains("million")) {
      price = price.toLowerCase().replaceAll("million", "").trim();
      return double.parse(price) * 1000000;
    } else if (price.toLowerCase().contains("k")) {
      price = price.toLowerCase().replaceAll("k", "").trim();
      return double.parse(price) * 1000;
    }

    return double.tryParse(price) ?? 0.0;
  }

  List<String> types = ["Sell", "Rent"];

  String _searchText = "";

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  Future<void> searchProperties(String query) async {
    _searchQuery = query;
    Map<String, dynamic> search = {
      "search": _searchQuery,
      "type": selectedOption,
    };
    // await fetchProperties();
    filterProperties(search);
  }

  void filterProperties(Map<String, dynamic> filters) {
    clearFilters();
    _filteredProperties = _properties.where((property) {
      bool matches = true;

      if (filters['search'] != null && filters['search'].isNotEmpty) {
        log("filters['search']==${filters['search']}");
        matches =
            matches &&
            property.location.toLowerCase().contains(
              filters['search'].toString().toLowerCase(),
            );
      }

      if (filters['type'] != null && filters['type'].isNotEmpty) {
        log("property.type${property.type}");
        matches =
            matches &&
            property.type ==
                (filters['type'] == "Sell" ? Type.SALE : Type.RENT);
      }

      if (filters['minPrice'] != null) {
        matches = matches && parsePrice(property.price) >= filters['minPrice'];
      }

      if (filters['maxPrice'] != null) {
        matches = matches && parsePrice(property.price) <= filters['maxPrice'];
      }

      return matches;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _filteredProperties = _properties;
    notifyListeners();
  }

  Review? _reviews;

  Review? get reviews => _reviews;

  set reviews(Review? value) {
    _reviews = value;
    notifyListeners();
  }

  Future getPropertyReviews(int propertyId) async {
    try {
      reviews = null;
      notifyListeners();

      final response = await ApiService.get(
        'api/reviews',
        params: {'property_id': propertyId.toString()},
      );

      if (response.statusCode == 200) {
        final data = response.body;

        final details = reviewFromJson(data);

        if (details.error == false) {
          reviews = details;
        } else {
          reviews = null; // clear on error
        }
        notifyListeners();
        log('==getPropertyReviews=data==${data}');
      }
    } catch (error) {
      propertyDetails = null; // clear on exception
      notifyListeners();
      print('Error fetching reviews: $error');
    }

    return [];
  }

  Future<void> getPropertyDetails(int id) async {
    try {
      // reset previous data before new call
      propertyDetails = null;
      notifyListeners();

      final response = await ApiService.get('api/properties?id=$id');
      String? data = response.body;
      log("message=response==${response.body}");

      if (data != null) {
        final details = propertyDetailsFromJson(data);

        // check if error exists in API response
        if (details.error == false) {
          propertyDetails = details;
        } else {
          propertyDetails = null; // clear on error
        }

        log("propertyDetails==${propertyDetails?.data.property.id}");
        notifyListeners();
      }
    } catch (e) {
      propertyDetails = null; // clear on exception
      notifyListeners();
      print("getHomeCategoryERROR===>>>${e}");
    }
  }

  Future<Map<String, dynamic>> addReview(
    int propertyId,
    double serviceRating,
    double valueRating,
    double locationRating,
    double cleanlinessRating,
    String comment,
  ) async {
    try {
      final response = await ApiService.post('api/review/add', {
        'property_id': propertyId,
        'service_rating': serviceRating,
        'value_rating': valueRating,
        'location_rating': locationRating,
        'cleanliness_rating': cleanlinessRating,
        'comment': comment,
      });

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message']};
      }
    } catch (error) {
      return {'success': false, 'error': error.toString()};
    }
  }
}
