import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/history.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:user_web/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionHistoryWidget extends StatefulWidget {
  const TransactionHistoryWidget({super.key});

  @override
  State<TransactionHistoryWidget> createState() =>
      _TransactionHistoryWidgetState();
}

class _TransactionHistoryWidgetState extends State<TransactionHistoryWidget> {
  bool isLoaded = true;
  List<HistoryModel> history = [];
  String currency = '';
  int itemsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    getCurrency();
    getTransactionHistory();
  }

  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  getTransactionHistory() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
        .orderBy('timeCreated', descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
        history = event.docs
            .map((e) => HistoryModel.fromMap(e.data(), e.id))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (history.length / itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const  Color(0xFFDF7EB).withOpacity(1.0),
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width >= 1100 ? 15 : 15),
        ).tr(),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            : const  Color(0xFFDF7EB).withOpacity(1.0),
      ),
      // backgroundColor: Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(10),
            // Align(
            //   alignment: MediaQuery.of(context).size.width >= 1100
            //       ? Alignment.bottomLeft
            //       : Alignment.center,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //         left: MediaQuery.of(context).size.width >= 1100 ? 20 : 12),
            //     child: Row(
            //       children: [
            //         InkWell(
            //             onTap: () {
            //               Navigator.pop(context);
            //             },
            //             child: const Icon(Icons.arrow_back)),
            //         const Gap(20),
            //         Text(
            //           'Transaction History',
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: MediaQuery.of(context).size.width >= 1100
            //                   ? 15
            //                   : 15),
            //         ).tr(),
            //       ],
            //     ),
            //   ),
            // ),
            if (MediaQuery.of(context).size.width >= 1100)
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
            const Gap(20),
            isLoaded
                ? _buildShimmerList()
                : history.isEmpty
                    ? _buildEmptyState()
                    : _buildTransactionList(),
            const Gap(20),
            _buildPaginationControls(totalPages),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 1100
          ? const EdgeInsets.only(left: 100, right: 100)
          : const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              title: Container(
                height: 20,
                color: Colors.grey,
              ),
              subtitle: Container(
                height: 16,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.receipt,
            color: appColor,
            size: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 5
                : MediaQuery.of(context).size.width / 1.5,
          ),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 1100
          ? const EdgeInsets.only(left: 100, right: 100)
          : const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width >= 1100
            ? MediaQuery.of(context).size.height
            : null,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemsPerPage,
          itemBuilder: (context, index) {
            final itemIndex = currentPage * itemsPerPage + index;
            if (itemIndex < history.length) {
              HistoryModel historyModel = history[itemIndex];
              return ListTile(
                title: Text(historyModel.message).tr(),
                trailing: Text(timeago.format(historyModel.timeCreated)),
                subtitle: Text(
                    '$currency${Formatter().converter(double.parse(historyModel.amount))} with ${historyModel.paymentSystem}'),
              );
            }
            return null;
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              indent: 20,
              endIndent: 20,
              color: Color.fromARGB(255, 220, 214, 214),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: currentPage > 0
                ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                : null,
          ),
          Text('Page ${currentPage + 1} of $totalPages'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages - 1
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
