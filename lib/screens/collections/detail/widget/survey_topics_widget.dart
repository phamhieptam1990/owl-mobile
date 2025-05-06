import 'package:flutter/material.dart';
import 'package:athena/models/survey_constant_response.dart';

class SurveyTopics extends StatefulWidget {
  final List<Survey> surveys;
  final String title;

  final Function(Survey) onTapSurvey;

  SurveyTopics({Key? key, required this.surveys, required this.onTapSurvey, this.title = ''})
      : super(key: key);

  @override
  _SurveyTopicsState createState() => _SurveyTopicsState();
}

class _SurveyTopicsState extends State<SurveyTopics> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x25606060),
                  offset: Offset(2, -4.0),
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              children: [
                buildHeader(),
                Expanded(
                    child: ListView.separated(
                        // physics: BouncingScrollPhysics(),
                        // shrinkWrap: true,
                        itemBuilder: (contex, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              widget.onTapSurvey.call(widget.surveys[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                widget.surveys[index].name ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (contex, index) {
                          return Divider(
                            height: 2,
                            color: Colors.grey,
                          );
                        },
                        itemCount: widget.surveys.length ?? 0))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25606060),
            offset: Offset(2, -4.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A),
                  fontSize: 20,
                  fontFamily: 'Roboto'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, right: 19),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('assets/images/ic_close.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
