import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/property.dart';
import '../services/api_service.dart';
import '../utils/image_utilies.dart';

class PropertyCard extends StatelessWidget {
  final PropertyElement property;
  final VoidCallback onTap;

  const PropertyCard({required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: property.image.isNotEmpty
                  ? CachedNetworkImage(
                      ///${ApiService.imageUrlPrefix}
                      imageUrl: property.image,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.home,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
            ),

            // Property Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AssetsImage.carbon_location,
                                  scale: 5,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    property.location,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff6D6D6D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff7065EF).withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "For ${property.type.name.toLowerCase()}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff7065EF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(AssetsImage.bad, scale: 4),
                      SizedBox(width: 8),
                      Text("${property.numberBedroom} Bed"),
                      SizedBox(width: 10),
                      Image.asset(AssetsImage.bath, scale: 4),
                      SizedBox(width: 8),
                      Text("${property.numberBathroom} Bath"),
                      SizedBox(width: 10),
                      Image.asset(AssetsImage.square, scale: 4),
                      SizedBox(width: 8),
                      Text("${property.square} m²"),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "(${property.averageRating.toStringAsFixed(0)} Reviews)",
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${property.price}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/ Month',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff3BBE74),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: Text(
                            "View",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
