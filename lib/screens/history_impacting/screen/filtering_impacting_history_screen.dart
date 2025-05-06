import 'package:flutter/material.dart';

import '../../../common/constants/color.dart';
import '../../../widgets/common/appbar.dart';
import '../models/action_code_response.dart';

class FilteringImpactingHistoryScreen extends StatefulWidget {
  // Fix 1: Add ? to Key and required to required parameters
  FilteringImpactingHistoryScreen({
    Key? key,
    this.actionCodeList = const [],
    required this.currentChossed,
    required this.onSelected,
  }) : super(key: key);

  final List<ActionCodeItem> actionCodeList;
  final ActionCodeItem currentChossed;
  final Function(ActionCodeItem) onSelected;

  @override
  State<FilteringImpactingHistoryScreen> createState() =>
      _FilteringImpactingHistoryState();
}

class _FilteringImpactingHistoryState
    extends State<FilteringImpactingHistoryScreen> {
  // Fix 2: Remove 'new' keyword and use const for static widgets
  final _impactingDropdownKey =
      GlobalKey<FormFieldState>(debugLabel: '_impactingDropdownKey');

  // Fix 3: Initialize late variables or make nullable
   List<ActionCodeItem>? _actionCodeList=[];
   ActionCodeItem? _currentChossed;
   int? _currentChossedId; // Fix 4: Make nullable since actionId is nullable
  
  // Fix 5: Add type parameter for better type safety
  List<DropdownMenuItem<ActionCodeItem>> _dropdownItems = [];

  // Fix 6: Mark test variables as final const
  final List<String> itemList = ['Alpha', 'Beta', 'Cat'];
  String itemSelected = 'Cat'; //Can be Alpha, Beta or Cat but not any other value
  
  @override
  void initState() {
    // Fix 7: Remove unnecessary null check since widget.actionCodeList has default value
    _actionCodeList = widget.actionCodeList;
    _currentChossed = widget.currentChossed;
    _currentChossedId = widget.currentChossed.actionId;
    
 
   _dropdownItems = _actionCodeList?.map((ActionCodeItem e) {
          return DropdownMenuItem<ActionCodeItem>(
            value: e,
            child: Text(e.name ?? 'Không có tên'),
          );
        }).toList() ??
        []; // Nếu _actionCodeList là null, trả về danh sách trống



    // No need to call setState in initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCommon(
          title: 'Lọc lịch sử tác động',
          lstWidget: const [], // Fix 10: Add const
        ),
        body: Column(
          children: [
            Listener(
              onPointerDown: (_) => FocusScope.of(context).unfocus(),
              child: DropdownButtonFormField<ActionCodeItem>(
                alignment: AlignmentDirectional.topStart,
                decoration: const InputDecoration( // Fix 11: Add const
                  filled: true,
                  labelText: "Lọc theo",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                key: _impactingDropdownKey,
                isExpanded: true,
                value: _currentChossed,
                hint: const Text('Tất cả'), // Fix 12: Add const
                items: _dropdownItems,
                onChanged: (value) {
                  // Fix 13: Add null check for onChanged callback
                  if (value != null) {
                    setState(() {
                      _currentChossed = value;
                    });
                  }
                },
              ),
            ),
            const Spacer(), // Fix 14: Add const
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  elevation: 4.0,
                  // color: Color(0xFF801E48),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    height: 56,
                    minWidth: double.infinity,
                    onPressed: () async {
                      Navigator.pop(context);
                      // Fix 15: Remove unnecessary call method
                      widget.onSelected(_currentChossed!);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Lọc',
                      style: TextStyle(color: AppColor.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}