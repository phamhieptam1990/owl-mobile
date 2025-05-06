import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/collections/collection/history_payment_card_response.dart';
import 'package:athena/utils/utils.dart';

class HistoryTransactionList extends StatefulWidget {
  final List<Transaction> cardTransactions;
  final List<Transaction> rechargeTransactions;
  final String currentFilterString;

  const HistoryTransactionList(
      {Key? key,
      required this.cardTransactions,
      required this.rechargeTransactions,
      this.currentFilterString = ''})
      : super(key: key);

  @override
  State<HistoryTransactionList> createState() => _HistoryTransactionListState();
}

class _HistoryTransactionListState extends State<HistoryTransactionList> {
  List<Transaction> cardTransactions =[];
  List<Transaction> searchCardTransactionList = <Transaction>[];

  List<Transaction> rechargeTransactions=[];
  List<Transaction> rechargeSearchCardTransactionList = <Transaction>[];
  TextEditingController _searchController= TextEditingController();
  TextEditingController _searchRechargeTransController= TextEditingController();
  Timer? _debounce;
  int currentIndex = 0;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchRechargeTransController = TextEditingController();

    cardTransactions = widget.cardTransactions;
    rechargeTransactions = widget.rechargeTransactions;
    super.initState();
  }

  @override
  void dispose() {
        // Fix 4: Add null check before calling cancel
    _debounce?.cancel();
    // Fix 5: Dispose controllers
    _searchController.dispose();
    _searchRechargeTransController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.topCenter,
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: currentIndex,
            backgroundColor: AppColor.appBar,
            onValueChanged: (value) {
              setState(() {
                currentIndex = value!;
              });
            },
            children: {
              0: buildTabItem(0,
                  isActive: currentIndex == 0,
                  title: 'Ghi Nợ',
                  length: cardTransactions.length ?? 0),
              1: buildTabItem(1,
                  isActive: currentIndex == 1,
                  title: 'Ghi Có',
                  length: rechargeTransactions.length ?? 0)
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Visibility(
              visible: widget.currentFilterString.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Từ ngày: ',
                      style: TextStyle(
                          color: AppColor.grey,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      widget.currentFilterString,
                      style: TextStyle(
                          color: AppColor.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: currentIndex == 0
                ? buildCardTransactions()
                : buildRechargeTransactions())
      ],
    );
  }

  Widget buildCardTransactions() {
    return (cardTransactions.isNotEmpty ?? false)
        ? Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (text) {
                    onChangedSearch(text);
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Tìm theo mã",
                      suffixIcon: _searchController.text.isNotEmpty ?? false
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            )
                          : SizedBox(),
                      fillColor: Colors.white70),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: (_searchController.text.isNotEmpty ?? false)
                      ? searchCardTransactionList.isNotEmpty ?? false
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return transactionItem(
                                    searchCardTransactionList[index]);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 8,
                                );
                              },
                              itemCount: searchCardTransactionList.length ?? 0)
                          : buildNoTransaction(
                              content: 'Không tìm thấy giao dịch')
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return transactionItem(cardTransactions[index]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 8,
                            );
                          },
                          itemCount: cardTransactions.length),
                )
              ],
            ),
          )
        : buildNoTransaction();
  }

  Widget buildRechargeTransactions() {
    return (rechargeTransactions.isNotEmpty ?? false)
        ? Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                TextField(
                  controller: _searchRechargeTransController,
                  onChanged: (text) {
                    onChangedReChargeSearch(text);
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Tìm theo mã",
                      suffixIcon:
                          _searchRechargeTransController.text.isNotEmpty ??
                                  false
                              ? IconButton(
                                  onPressed: () {
                                    _searchRechargeTransController.clear();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                )
                              : SizedBox(),
                      fillColor: Colors.white70),
                ),
                SizedBox(
                  height: 15,
                ),
                (_searchRechargeTransController.text.isNotEmpty)
                    ? rechargeSearchCardTransactionList.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return transactionItem(
                                      rechargeSearchCardTransactionList[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                                itemCount:
                                    rechargeSearchCardTransactionList.length ??
                                        0),
                          )
                        : buildNoTransaction(
                            content: 'Không tìm thấy giao dịch')
                    : Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return transactionItem(
                                  rechargeTransactions[index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                            itemCount: rechargeTransactions.length),
                      ),
              ],
            ),
          )
        : buildNoTransaction();
  }

  Widget buildTabItem(int index,
      {bool isActive = false, String title = '', int length = 0}) {
    return RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14.0,
                color: isActive ? Colors.black : Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w400),
            children: <TextSpan>[
          TextSpan(
            text: '(',
          ),
          TextSpan(
            text: '${length ?? 0}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isActive ? Colors.lightBlue[900] : Colors.lightBlue[300],
                fontStyle: FontStyle.italic),
          ),
          TextSpan(
            text: ')',
          ),
        ]));
  }

  Padding buildNoTransaction({String content = 'Không có giao dịch'}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: Center(
          child: Text(
            content,
            style: TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void onChangedSearch(String text) {
    searchCardTransactionList = cardTransactions
        .where((element) => _isContains(element, text))
        .toList();

    setState(() {});
  }

  void onChangedReChargeSearch(String text) {
    rechargeSearchCardTransactionList = rechargeTransactions
        .where((element) => _isContains(element, text))
        .toList();

    setState(() {});
  }

  bool _isContains(Transaction element, String text) {
    if (element.transactionCode
            ?.toLowerCase()
            .contains(text.toLowerCase().trim()) ??
        false) {
      return true;
    }
    return false;
  }

  Widget transactionItem(Transaction value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color(0x19000000),
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Mã giao dịch: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(value.transactionCode ?? '',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                'Ngày giao dịch: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                      Utils.convertTimeWithoutTime(value.trnxdateAndTime),
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                'Accounting Date: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(Utils.convertTimeWithoutTime(value.postingDate),
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                'Số tiền giao dịch: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(Utils.formatPrice(value.trnxamount?.toString() ?? '0'),
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mô tả: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(value.description ?? '',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                'Credit Debit Flag: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(value.creditDebitFlag ?? '',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.normal))),
            ],
          ),
        ],
      ),
    );
  }
}
