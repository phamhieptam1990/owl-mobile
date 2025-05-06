import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/employee/employee.tracking.model.dart';
import 'package:athena/utils/utils.dart';

class VietMapListTrackingPage extends StatefulWidget {
  final String title;
  final List<EmployeeTrackingModel> list;
  final EmployeeTrackingModel item;
  VietMapListTrackingPage({Key? key, required this.title, required this.list, required this.item})
      : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<VietMapListTrackingPage>
    with AfterLayoutMixin {
  TextEditingController editingController = TextEditingController();

  List<EmployeeTrackingModel> duplicateItems = [];
  List<EmployeeTrackingModel> items = [];

  @override
  void initState() {
    duplicateItems = widget.list;
    super.initState();
  }

  setController(String? value) async {
    editingController.value = TextEditingValue(
      text: value ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: value?.length ?? 0),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    setController(widget.item.makerId);
    filterSearchResults(widget.item.makerId);
  }

  void filterSearchResults(String? query) {
    List<EmployeeTrackingModel> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query?.isNotEmpty ?? false) {
      List<EmployeeTrackingModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (query != null &&
            item.makerId != null &&
            item.makerId!.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  actionTap(data) {
    var detail = {"action": true, "data": data};
    Navigator.of(context).pop(detail);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: S.of(context).search,
                    hintText: S.of(context).search,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Card(
                        child: Column(children: [
                      InkWell(
                          onTap: () {
                            actionTap(items[index]);
                          },
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    child: Text(items[index].makerId![0] ?? '',
                                        style:
                                            TextStyle(color: AppColor.white)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  title: Text(items[index].makerId ?? ''),
                                  subtitle: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        items[index].tenantCode ?? '',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        Utils.getTimeFromDate(
                                            items[index].trackDate ?? 0) ?? '',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54),
                                      ),
                                      new SizedBox(height: 4.0),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 2.0,
                                ),
                              ]))
                    ]))
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
