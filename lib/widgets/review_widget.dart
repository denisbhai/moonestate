// import 'package:flutter/material.dart';
//
// import '../models/review.dart';
//
// class ReviewWidget extends StatelessWidget {
//   final Review review;
//
//   const ReviewWidget({required this.review});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   review.userName,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '${review.createdAt.toLocal().toString().split(' ')[0]}',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.star, color: Colors.amber, size: 16),
//                 SizedBox(width: 4),
//                 Text(review.averageRating.toStringAsFixed(1)),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(review.comment),
//           ],
//         ),
//       ),
//     );
//   }
// }