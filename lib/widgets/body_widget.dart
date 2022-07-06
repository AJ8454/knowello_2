// import 'package:flutter/material.dart';
// import 'package:knowello_ui/models/image_model.dart';
// import 'package:knowello_ui/widgets/carosule_card.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// class BodyWidget extends StatefulWidget {
//   const BodyWidget({Key? key}) : super(key: key);

//   @override
//   State<BodyWidget> createState() => _BodyWidgetState();
// }

// class _BodyWidgetState extends State<BodyWidget> {
//   final ItemScrollController itemScrollController = ItemScrollController();
//   bool isloading = true;
//   int cardScrollIndex = 0;

//   List<Post>? allpost;
//   List<Widget>? images;

//   @override
//   void initState() {
//     super.initState();

//     _loaddata();
//   }

//   _loaddata() async {
//     allpost = [
//       Post(
//         images: [
//           'assets/images/VideoThumb.jpg',
//         ],
//         description: 'post',
//         postedBy: 'postedBy',
//         profileImage: '',
//         imageSize: 'large',
//       ),
//       Post(
//         images: [
//           'assets/images/post1.jpg',
//           'assets/images/post2.jpg',
//           'assets/images/post3.jpg',
//           'assets/images/post4.jpg',
//         ],
//         description: 'post',
//         postedBy: 'postedBy',
//         profileImage: '',
//         imageSize: 'small',
//       ),
//       Post(
//           images: [
//             'assets/images/Buzzing1.jpg',
//             'assets/images/Buzzing01.jpg',
//             'assets/images/Buzzing2.jpg',
//             'assets/images/Buzzing02.jpg',
//           ],
//           description: 'post',
//           postedBy: 'postedBy',
//           profileImage: '',
//           imageSize: 'medium'),
//       Post(
//           images: [
//             'assets/images/Buzzing03.jpg',
//             'assets/images/Buzzing04.png',
//             'assets/images/Buzzing05.png',
//             'assets/images/Buzzing02.jpg',
//           ],
//           description: 'post',
//           postedBy: 'postedBy',
//           profileImage: '',
//           imageSize: 'medium'),
//       Post(
//           images: [
//             'assets/images/BuzzingFeature01.jpg',
//             'assets/images/BuzzingFeature02.jpg',
//             'assets/images/BuzzingFeature03.jpg',
//           ],
//           description: 'post',
//           postedBy: 'postedBy',
//           profileImage: '',
//           imageSize: 'medium'),
//     ];
//     setState(() {
//       isloading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isloading
//           ? const Center(child: CircularProgressIndicator())
//           : ScrollablePositionedList.builder(
//               padding: const EdgeInsets.only(
//                 bottom: 10,
//                 left: 5,
//                 right: 5,
//               ),
//               physics: const ScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return CarouselCard(
//                   itemIndex: index,
//                   postdata: allpost,
//                 );
//               },
//               itemCount: allpost!.length,
//               itemScrollController: itemScrollController,
//             ),
//     );
//   }
// }
