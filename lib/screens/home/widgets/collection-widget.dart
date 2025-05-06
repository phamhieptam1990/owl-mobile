import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/utils/utils.dart';
import '../../../getit.dart';
import '../home.provider.dart';

class CollectionWidget extends StatelessWidget {
  final homeProvider = getIt<HomeProvider>();
  final _collectionProvider = getIt<CollectionProvider>();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, right: 30, top: 15, bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 150,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 15.0),
                    child: Text(S.of(context).collections,
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: AppFont.fontSize18)),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                          params: '');
                    },
                    child: Text(
                      S.of(context).seeAll + ' >',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: AppFont.fontSize18),
                    ))
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 15.0, bottom: 0.0, left: 7.0, right: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        this._collectionProvider.filter = {
                          "nvcontract_status": {
                            "type": FilterType.EQUALS,
                            "filter": "PAID",
                            "filterType": FilterType.TEXT
                          }
                        };
                        Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                            params: S.of(context).paidCases);
                      },
                      child: Column(children: [
                        Text(homeProvider.getPaiCases().toString(),
                            style: TextStyle(
                                fontSize: AppFont.fontSize50,
                                color: AppColor.blackOpacity)),
                        Text(S.of(context).paidCases,
                            style: TextStyle(fontSize: AppFont.fontSize16)),
                      ]),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                          onTap: () {
                            this._collectionProvider.filter = {
                              "nvcontract_status": {
                                "type": FilterType.EQUALS,
                                "filter": "UNPAID",
                                "filterType": FilterType.TEXT
                              }
                            };
                            Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                                params: S.of(context).unpaidCases);
                          },
                          child: Column(children: [
                            Text(homeProvider.getUnpaidCases().toString(),
                                style: TextStyle(
                                    fontSize: AppFont.fontSize50,
                                    color: AppColor.blackOpacity)),
                            Text(S.of(context).unpaidCases,
                                style: TextStyle(fontSize: AppFont.fontSize16)),
                          ]))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
