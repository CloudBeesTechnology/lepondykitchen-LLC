import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../providers/restuarant_providers/restaurant_flashsales_provider.dart';

class TimerBasic extends ConsumerStatefulWidget {
  final CountDownTimerFormat format;
  final bool inverted;

  const TimerBasic({
    required this.format,
    this.inverted = false,
    super.key,
  });

  @override
  ConsumerState<TimerBasic> createState() => _TimerBasicState();
}

class _TimerBasicState extends ConsumerState<TimerBasic> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(flashSalesTimeStreamRestaurantProvider);

    return timer.when(data: (c) {
      // Parse the string into a DateTime object
      DateTime targetDate = DateTime.parse(c);

      // Calculate the difference between the target date and the current date
      DateTime currentDate = DateTime.now();
      Duration difference = targetDate.difference(currentDate);
      return TimerCountdown(
        format: widget.format,
        endTime: DateTime.now().add(difference),
        onEnd: () {
          deleteAllDocumentsInCollection('Flash Sales');
        },
        timeTextStyle: TextStyle(
          color: (widget.inverted)
              ? CupertinoColors.activeOrange
              : CupertinoColors.white,
          fontWeight: FontWeight.w300,
          fontSize: 40,
          fontFeatures: const <FontFeature>[
            FontFeature.tabularFigures(),
          ],
        ),
        colonsTextStyle: TextStyle(
          color: (widget.inverted)
              ? CupertinoColors.activeOrange
              : CupertinoColors.white,
          fontWeight: FontWeight.w300,
          fontSize: 40,
          fontFeatures: const <FontFeature>[
            FontFeature.tabularFigures(),
          ],
        ),
        descriptionTextStyle: TextStyle(
          color: (widget.inverted)
              ? CupertinoColors.activeOrange
              : CupertinoColors.white,
          fontSize: 10,
          fontFeatures: const <FontFeature>[
            FontFeature.tabularFigures(),
          ],
        ),
        spacerWidth: 5,
        daysDescription: "days",
        hoursDescription: "hours",
        minutesDescription: "minutes",
        secondsDescription: "seconds",
      );
    }, error: (c, e) {
      return Text('$c');
    }, loading: () {
      return const SizedBox();
    });
  }
}
