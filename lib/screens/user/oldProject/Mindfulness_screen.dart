// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/services.dart';
// import 'package:oilsavings/models/ExerciseModel.dart';
// import 'package:mindcare_app/screens/user/exercise_screen.dart';
// import 'package:oilsavings/services/ExerciseService.dart';
// import 'package:oilsavings/services/UserService.dart';
// import 'package:mindcare_app/themes/themeColors.dart';

// class MindFulnessScreen extends StatelessWidget {
//   const MindFulnessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     final cardWidth = MediaQuery.of(context).size.width * 0.8;
//     final cardHeight = (cardWidth * 0.7);
//     final exerciseService = ExerciseService();

//     Future<void> _refresh() async {
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => const MindFulnessScreen()),
//       );
//     }

//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: ThemeColors.getGradient(),
//         ),
//         child: RefreshIndicator(
//           onRefresh: _refresh,
//           child: ListView(
//             children: [
//               const SizedBox(height: 8.0),
//               _buildFloatingPanel("Meditation"),
//               buildSwiperMeditation(cardWidth, cardHeight, exerciseService,
//                   'Meditation', context),
//               _buildFloatingPanel("Relaxation"),
//               buildSwiperRelaxation(
//                   cardWidth, cardHeight, exerciseService, 'Relaxation'),
//               _buildFloatingPanel("Breathing"),
//               buildSwiperBreathing(
//                   cardWidth, cardHeight, exerciseService, 'Breathing'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingPanel(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 110.0, vertical: 8.0),
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18.0,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildSwiperMeditation(double cardWidth, double cardHeight,
//       ExerciseService exerciseService, String type, BuildContext context) {
//     return FutureBuilder<ExerciseResponse>(
//       future: exerciseService.getExercises(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData ||
//             snapshot.data!.data == null ||
//             snapshot.data!.data!.isEmpty) {
//           return const Text('No exercises available');
//         } else {
//           final exercises = snapshot.data!.data!
//               .where((exercise) => exercise.type == type)
//               .toList();
//           return Container(
//             width: cardWidth,
//             height: cardHeight,
//             margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//             child: Swiper(
//               itemCount: exercises.length,
//               pagination: const SwiperPagination(),
//               itemBuilder: (BuildContext context, int index) {
//                 return FutureBuilder<ExerciseData>(
//                   future: exerciseService
//                       .getExerciseById(exercises[index].id.toString()),
//                   builder: (context, exerciseSnapshot) {
//                     if (exerciseSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (exerciseSnapshot.hasError) {
//                       return Text('Error: ${exerciseSnapshot.error}');
//                     } else if (!exerciseSnapshot.hasData) {
//                       return const Text('Exercise data not available');
//                     } else {
//                       final exerciseData = exerciseSnapshot.data!;
//                       return GestureDetector(
//                         child: CardWithExerciseInfo(
//                           cardWidth: cardWidth,
//                           cardHeight: cardHeight,
//                           imageUrl: exerciseData.image ??
//                               'assets/screen_images/meditacion.png',
//                           exerciseName: exerciseData.name ??
//                               'Nombre de Ejercicio Predeterminado',
//                           isMade: exerciseData.made ?? 0,
//                           exerciseId: exerciseData.id ?? 0,
//                           onTap: () {
//                             // exerciseService.exerciseMade(
//                             //     UserService.userId.toString(),
//                             //     exerciseData.id.toString());
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ExerciseDescription(
//                                     exerciseId: exerciseData.id.toString()),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//               autoplay: false,
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget buildSwiperRelaxation(double cardWidth, double cardHeight,
//       ExerciseService exerciseService, String type) {
//     return FutureBuilder<ExerciseResponse>(
//       future: exerciseService.getExercises(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData ||
//             snapshot.data!.data == null ||
//             snapshot.data!.data!.isEmpty) {
//           return const Text('No exercises available');
//         } else {
//           final exercises = snapshot.data!.data!
//               .where((exercise) => exercise.type == type)
//               .toList();
//           return Container(
//             width: cardWidth,
//             height: cardHeight,
//             margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//             child: Swiper(
//               itemCount: exercises.length,
//               pagination: const SwiperPagination(),
//               itemBuilder: (BuildContext context, int index) {
//                 return FutureBuilder<ExerciseData>(
//                   future: exerciseService
//                       .getExerciseById(exercises[index].id.toString()),
//                   builder: (context, exerciseSnapshot) {
//                     if (exerciseSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (exerciseSnapshot.hasError) {
//                       return Text('Error: ${exerciseSnapshot.error}');
//                     } else if (!exerciseSnapshot.hasData) {
//                       return const Text('Exercise data not available');
//                     } else {
//                       final exerciseData = exerciseSnapshot.data!;
//                       return GestureDetector(
//                         child: CardWithExerciseInfo(
//                           cardWidth: cardWidth,
//                           cardHeight: cardHeight,
//                           imageUrl: exerciseData.image ??
//                               'assets/screen_images/relaxation.png',
//                           exerciseName: exerciseData.name ??
//                               'Nombre de Ejercicio Predeterminado',
//                           isMade: exerciseData.made ?? 0,
//                           exerciseId: exerciseData.id ?? 0,
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ExerciseDescription(
//                                     exerciseId: exerciseData.id.toString()),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//               autoplay: false,
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget buildSwiperBreathing(double cardWidth, double cardHeight,
//       ExerciseService exerciseService, String type) {
//     return FutureBuilder<ExerciseResponse>(
//       future: exerciseService.getExercises(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData ||
//             snapshot.data!.data == null ||
//             snapshot.data!.data!.isEmpty) {
//           return const Text('No exercises available');
//         } else {
//           final exercises = snapshot.data!.data!
//               .where((exercise) => exercise.type == type)
//               .toList();
//           return Container(
//             width: cardWidth,
//             height: cardHeight,
//             margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//             child: Swiper(
//               itemCount: exercises.length,
//               pagination: const SwiperPagination(),
//               itemBuilder: (BuildContext context, int index) {
//                 return FutureBuilder<ExerciseData>(
//                   future: exerciseService
//                       .getExerciseById(exercises[index].id.toString()),
//                   builder: (context, exerciseSnapshot) {
//                     if (exerciseSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (exerciseSnapshot.hasError) {
//                       return Text('Error: ${exerciseSnapshot.error}');
//                     } else if (!exerciseSnapshot.hasData) {
//                       return const Text('Exercise data not available');
//                     } else {
//                       final exerciseData = exerciseSnapshot.data!;
//                       return GestureDetector(
//                         child: CardWithExerciseInfo(
//                           cardWidth: cardWidth,
//                           cardHeight: cardHeight,
//                           imageUrl: exerciseData.image ??
//                               'assets/screen_images/breathing.png',
//                           exerciseName: exerciseData.name ??
//                               'Nombre de Ejercicio Predeterminado',
//                           isMade: exerciseData.made ?? 0,
//                           exerciseId: exerciseData.id ?? 0,
//                           onTap: () {
//                             // exerciseService.exerciseMade(
//                             //     UserService.userId.toString(),
//                             //     exerciseData.id.toString());
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ExerciseDescription(
//                                     exerciseId: exerciseData.id.toString()),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//               autoplay: false,
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class CardWithExerciseInfo extends StatefulWidget {
//   final double cardWidth;
//   final double cardHeight;
//   final String imageUrl; // Cambiar el nombre del parámetro a imageUrl
//   final String exerciseName;
//   final int isMade;
//   final int exerciseId;
//   final void Function() onTap;

//   CardWithExerciseInfo({
//     required this.cardWidth,
//     required this.cardHeight,
//     required this.imageUrl, // Cambiar el nombre del parámetro a imageUrl
//     required this.exerciseName,
//     required this.isMade,
//     required this.exerciseId,
//     required this.onTap,
//   });

//   @override
//   _CardWithExerciseInfoState createState() => _CardWithExerciseInfoState();
// }

// class _CardWithExerciseInfoState extends State<CardWithExerciseInfo> {
//   final exerciseService = ExerciseService();

//   @override
//   Widget build(BuildContext context) {
//     bool exerciseMade = false;
//     if (widget.isMade == 1) {
//       exerciseMade = true;
//     }
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: InkWell(
//         onTap: widget.onTap,
//         child: Container(
//           width: widget.cardWidth,
//           height: widget.cardHeight,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: NetworkImage(widget
//                   .imageUrl), // Usar NetworkImage para cargar la imagen desde la URL
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 10.0,
//                 left: 10.0,
//                 child: Row(
//                   children: [
//                     Text(
//                       widget.exerciseName,
//                       style: const TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Icon(
//                       exerciseMade ? Icons.star : Icons.star_border,
//                       color: Colors.yellow,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
