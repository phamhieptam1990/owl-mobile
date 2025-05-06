import 'package:flutter/material.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/utils/utils.dart';

class LeadingTitle extends StatefulWidget {
  final TicketModel detail;

  LeadingTitle({
    Key? key,
    required this.detail,
  }) : super(key: key);

  @override
  _LeadingTitleState createState() => _LeadingTitleState();
}

class _LeadingTitleState extends State<LeadingTitle> {
  CollectionService _collectionService = new CollectionService();

  @override
  Widget build(BuildContext context) {
    String lastPaymentAmount = '0';
    if (Utils.checkIsNotNull(widget.detail.lastPaymentAmount)) {
      if (Utils.checkValueIsDouble(widget.detail.lastPaymentAmount)) {
        double? amount = widget.detail.lastPaymentAmount;
        lastPaymentAmount = Utils.formatPrice(
            Utils.repplaceCharacter((amount?.round() ?? 0).toString()));
      } else {
        lastPaymentAmount = Utils.formatPrice(Utils.repplaceCharacter(
            widget.detail.lastPaymentAmount.toString()));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 4.0),
        Text(
          (Utils.checkIsNotNull(widget.detail.empFullName)
                  ? widget.detail.empFullName ?? ''
                  : '') +
              ' - ' +
              _collectionService.getAssisneeData(widget.detail),
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        // SizedBox(height: 4.0),
        Row(
          children: [
            Icon(
              Icons.person,
              size: 15.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                (Utils.checkIsNotNull(widget.detail.empFullName)
                        ? widget.detail.empFullName ?? ''
                        : '') +
                    ' - ' +
                    _collectionService.getAssisneeData(widget.detail),
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
        // SizedBox(height: 4.0),
        // Visibility(
        //     visible: Utils.checkIsNotNull(widget?.detail?.empFullName),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.person_add_alt,
        //           size: 15.0,
        //         ),
        //         Flexible(
        //           child: Padding(
        //             padding: EdgeInsets.only(left: 6.0),
        //             child: Text(
        //               Utils.checkIsNotNull(widget?.detail?.empFullName)
        //                   ? widget?.detail?.empFullName
        //                   : '',
        //               overflow: TextOverflow.ellipsis,
        //               maxLines: 2,
        //               style: TextStyle(fontSize: 12.0),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 4.0),
        //       ],
        //     )),
        Row(
          children: [
            Icon(
              Icons.gif_box_rounded,
              size: 15.0,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  'Bucket đầu kỳ: ' +
                      (Utils.checkIsNotNull(widget.detail.periodBucket)
                          ? widget.detail.periodBucket
                          : ''),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          ],
        ),
        // SizedBox(height: 4.0),
        Visibility(
            visible: Utils.checkIsNotNull(widget.detail.cusFullAddress),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  size: 15.0,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text(
                      Utils.checkIsNotNull(widget.detail.cusFullAddress)
                          ? widget.detail.cusFullAddress ?? ''
                          : '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 4.0),
              ],
            )),
        // SizedBox(height: 4.0),
        Visibility(
            visible: widget.detail.lastEventDate != null,
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  size: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(
                    Utils.convertTimehasDay(Utils.convertTimeStampToDateEnhance(
                        widget.detail.lastEventDate ?? '0') ?? 0),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                // SizedBox(height: 4.0),
              ],
            )),

        Visibility(
            visible: widget.detail.lastPaymentDate != null,
            child: Row(
              children: [
                Icon(
                  Icons.note,
                  size: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(
                    Utils.convertTimeWithoutTime(
                            Utils.convertTimeStampToDateEnhance(
                                widget.detail.lastPaymentDate ?? '') ?? 0) +
                        ", " +
                        lastPaymentAmount +
                        " VNĐ",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                // SizedBox(height: 4.0),
              ],
            )),
        // this._collectionService.buildCustomerAttitude(widget.detail),
        this._collectionService.buildManager(widget.detail),
        this._collectionService.buildCaseExpirationDate(widget.detail),
        // SizedBox(
        //   height: 8,
        // ),
        // Visibility(
        //   visible:
        //       widget.detail?.mustPay != null && widget.detail.mustPay != 0.0,
        //   child: Text(
        //       'Must Pay: ' +
        //           Utils.formatPrice(
        //               widget.detail?.mustPay?.round()?.toString() ?? '0') +
        //           ' đ',
        //       style: TextStyle(
        //           fontSize: 14,
        //           color: Colors.red[400],
        //           fontWeight: FontWeight.bold)),
        // ),
        // SizedBox(height: 4.0),

        Row(
          children: [
            Icon(
              Icons.attach_money,
              size: 15.0,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                   'Số tiền quá hạn: ' +
                      (Utils.checkIsNotNull(widget.detail.mustPay)
                          ? Utils.formatPrice(Utils.repplaceCharacter(
                              (widget.detail.mustPay?.round() ?? 0).toString()))
                          : '0') + " VNĐ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          ],
        ),
        // SizedBox(height: 4.0),
        Row(
          children: [
            Icon(
              Icons.money,
              size: 15.0,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  'Số tiền kỳ xa nhất: ' +
                      (Utils.checkIsNotNull(widget.detail.installmentAmt)
                          ? Utils.formatPrice(Utils.repplaceCharacter(
                              widget.detail.installmentAmt.round().toString()))
                          : '0') +
                      " VNĐ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
