import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../providers/property_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/image_utilies.dart';
import '../../models/review.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int id;

  const PropertyDetailScreen({super.key, required this.id});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();

  static Widget _buildExpandableTile(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // spacing between tiles
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // shadow color
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            initiallyExpanded: true,
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            children: [content],
          ),
        ),
      ),
    );
  }

  // Rating row widget
  static Widget _ratingRow(String label, int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        RatingBarIndicator(
          rating: stars.toDouble(),
          itemCount: 5,
          itemSize: 20,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
        ),
      ],
    );
  }

  // Review card widget
  static Widget _reviewCard(String name, String review, int rating) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: RatingBarIndicator(
        rating: rating.toDouble(),
        itemCount: 5,
        itemSize: 18,
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.amber),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "02 Jul 2023",
            style: const TextStyle(fontSize: 14, color: Color(0xff3BBE74)),
          ),
          const SizedBox(height: 4),
          Text(review, style: TextStyle(color: Color(0xff8D8D8D))),
        ],
      ),
    );
  }
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  bool _isLoadingReviews = false;
  bool _showReviewForm = false;

  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _serviceRating = 0;
  double _valueRating = 0;
  double _locationRating = 0;
  double _cleanlinessRating = 0;

  CarouselSliderController carouselSliderController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });

    final propertyProvider = Provider.of<PropertyProvider>(
      context,
      listen: false,
    );
    await propertyProvider.getPropertyReviews(widget.id);
    await propertyProvider.getPropertyDetails(widget.id);
    setState(() {
      _isLoadingReviews = false;
    });
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final propertyProvider = Provider.of<PropertyProvider>(
        context,
        listen: false,
      );

      final result = await propertyProvider.addReview(
        widget.id,
        _serviceRating,
        _valueRating,
        _locationRating,
        _cleanlinessRating,
        _commentController.text,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully')),
        );

        setState(() {
          _showReviewForm = false;
          _serviceRating = 0;
          _valueRating = 0;
          _locationRating = 0;
          _cleanlinessRating = 0;
          _commentController.clear();
        });

        await _loadReviews();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['error'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    print("==widget===========widget==${widget.id}");
    return SafeArea(
      child: Scaffold(
        body: _isLoadingReviews == true
            ? Center(child: CircularProgressIndicator())
            : propertyProvider.propertyDetails == null
            ? Center(child: Text("Server Error"))
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 220,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.white,
                    iconTheme: const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          CarouselSlider(
                            carouselController: carouselSliderController,
                            options: CarouselOptions(
                              height: 270,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                            ),
                            items: propertyProvider
                                .propertyDetails
                                ?.data
                                .property
                                .images
                                .map((imageUrl) {
                                  return CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                })
                                .toList(),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 0,
                            left: 0,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_currentImageIndex + 1}/${propertyProvider.propertyDetails?.data.property.images.length}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xff000000).withOpacity(0.4),
                        ),
                        child: Icon(Icons.favorite_border, color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xff000000).withOpacity(0.4),
                        ),
                        child: Center(
                          child: Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Design part
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                    0.3,
                                  ), // shadow color
                                  spreadRadius:
                                      2, // how much the shadow spreads
                                  blurRadius: 8, // soften the shadow
                                  offset: const Offset(
                                    2,
                                    4,
                                  ), // x,y position of shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${propertyProvider.propertyDetails?.data.property.name}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${propertyProvider.propertyDetails?.data.property.location}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${propertyProvider.propertyDetails?.data.property.price} / Month",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Details & Features
                          PropertyDetailScreen._buildExpandableTile(
                            "Details & Features",
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Bedrooms"),
                                    Text(
                                      "${propertyProvider.propertyDetails?.data.property.numberBedroom}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff8D8D8D),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Bathrooms"),
                                    Text(
                                      "${propertyProvider.propertyDetails?.data.property.numberBathroom}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff8D8D8D),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Garage"),
                                    Text(
                                      "1",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff8D8D8D),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Size"),
                                    Text(
                                      "${propertyProvider.propertyDetails?.data.property.square} sqft",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff8D8D8D),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Description
                          PropertyDetailScreen._buildExpandableTile(
                            "Description",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${propertyProvider.propertyDetails?.data.property.description}",
                                  style: TextStyle(color: Color(0xff8D8D8D)),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ],
                            ),
                          ),

                          // Amenities
                          PropertyDetailScreen._buildExpandableTile(
                            "Amenities",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(
                                      0xff3BBE74,
                                    ).withOpacity(0.2),
                                    child: Icon(
                                      Icons.check,
                                      size: 10,
                                      color: Colors.green,
                                    ),
                                  ),
                                  title: Text("Parking"),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(
                                      0xff3BBE74,
                                    ).withOpacity(0.2),
                                    child: Icon(
                                      Icons.check,
                                      size: 10,
                                      color: Colors.green,
                                    ),
                                  ),
                                  title: Text("Pets allow"),
                                ),
                              ],
                            ),
                          ),

                          // Location
                          PropertyDetailScreen._buildExpandableTile(
                            "Location",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${propertyProvider.propertyDetails?.data.property.location}",
                                ),
                                const SizedBox(height: 8),
                                Image.asset(
                                  AssetsImage.mapImage,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),

                          // Gallery
                          PropertyDetailScreen._buildExpandableTile(
                            "Gallery",
                            SizedBox(
                              height: 100,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  propertyProvider
                                          .propertyDetails
                                          ?.data
                                          .property
                                          .images
                                          .length ??
                                      0,
                                  (index) => Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        propertyProvider
                                                .propertyDetails
                                                ?.data
                                                .property
                                                .images[index] ??
                                            "",
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Nearby Ratings
                          PropertyDetailScreen._buildExpandableTile(
                            "Nearby",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Supermarkets"),
                                const Text("Mall"),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ],
                            ),
                          ),

                          // Reviews Section
                          PropertyDetailScreen._buildExpandableTile(
                            "Reviews",
                            Column(
                              children:
                                  propertyProvider.propertyDetails == null ||
                                      propertyProvider.reviews == null
                                  ? [Center(child: Text("Server Error"))]
                                  : propertyProvider.reviews?.data.reviews.map((
                                          e,
                                        ) {
                                          return PropertyDetailScreen._reviewCard(
                                            e.user,
                                            e.comment,
                                            e.star,
                                          );
                                        }).toList() ??
                                        [],
                            ),
                          ),

                          // Write Review
                          PropertyDetailScreen._buildExpandableTile(
                            "Write a Review",
                            _buildReviewForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildReviewForm() {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingField(
            label: languageProvider.translate('service'),
            value: _serviceRating,
            onChanged: (value) => setState(() => _serviceRating = value),
          ),

          _buildRatingField(
            label: languageProvider.translate('value'),
            value: _valueRating,
            onChanged: (value) => setState(() => _valueRating = value),
          ),

          _buildRatingField(
            label: languageProvider.translate('location'),
            value: _locationRating,
            onChanged: (value) => setState(() => _locationRating = value),
          ),

          _buildRatingField(
            label: languageProvider.translate('cleanliness'),
            value: _cleanlinessRating,
            onChanged: (value) => setState(() => _cleanlinessRating = value),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _averageRating.toStringAsFixed(1), // show average number
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Average Rating",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: languageProvider.translate('comment'),
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('please_enter_comment');
              }
              return null;
            },
          ),

          SizedBox(height: 16),

          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff08184B),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              languageProvider.translate('submit'),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  double get _averageRating {
    final ratings = [
      _serviceRating,
      _valueRating,
      _locationRating,
      _cleanlinessRating,
    ];

    // include only ratings > 0
    final nonZeroRatings = ratings.where((r) => r > 0).toList();

    if (nonZeroRatings.isEmpty) return 0;

    return nonZeroRatings.reduce((a, b) => a + b) / nonZeroRatings.length;
  }

  Widget _buildRatingField({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  onChanged(index + 1.0);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
