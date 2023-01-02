// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class CategoryItemWidget extends StatelessWidget {
//   final String buttonName;
//   final Function() onTap;
//
//   const CategoryItemWidget(
//       {Key? key, required this.buttonName, required this.onTap})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(boxShadow: const [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 5,
//         )
//       ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: InkWell(
//         onTap: () {
//           onTap();
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black12),
//               height: 40,
//               width: 40,
//               child: Image.asset('assets/images/apple.png'),
//             ),
//
//
//
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               child: Text(
//                 buttonName,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Spacer(),
//             SvgPicture.asset(
//               "assets/icons/arrow_right.svg",
//               height: 24,
//               width: 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
