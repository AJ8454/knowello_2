import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knowello_ui/models/timeline_event_model.dart';
import 'package:knowello_ui/utils/constant.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key? key}) : super(key: key);

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  Random random = Random();
  final List<Events> listOfEvents = [
    Events(time: "5pm", eventName: "New Icon", description: "Mobile App"),
    Events(
        time: "3 - 4pm", eventName: "Design Stand Up", description: "Hangouts"),
    Events(time: "12pm", eventName: "Lunch Break", description: "Main Room"),
    Events(
        time: "9 - 11am",
        eventName: "Finish Home Screen",
        description: "Web App"),
    Events(time: "5pm", eventName: "New Icon", description: "Mobile App"),
    Events(
        time: "3 - 4pm", eventName: "Design Stand Up", description: "Hangouts"),
    Events(time: "12pm", eventName: "Lunch Break", description: "Main Room"),
    Events(
        time: "9 - 11am",
        eventName: "Finish Home Screen",
        description: "Web App"),
  ];

  final List<Color> listOfColors = [
    Constants.kPurpleColor,
    Constants.kGreenColor,
    Constants.kRedColor
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TimeLine',
          style: themeTextStyle(context: context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                // height: height(context)! * 0.3,
                width: double.infinity,
                child: Image.asset("assets/images/BuzzingFeature01.jpg",
                    fit: BoxFit.fitWidth),
              ),
              Positioned(
                top: 40,
                left: 30,
                child: Row(children: <Widget>[
                  Text(
                    "8",
                    style: themeTextStyle(context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Monday",
                          style: themeTextStyle(context: context),
                        ),
                        Text(
                          "February 2015".toUpperCase(),
                          style: themeTextStyle(context: context),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              const Positioned(
                bottom: -20,
                right: 15,
                child: FloatingActionButton(
                  onPressed: null,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: null,
                    iconSize: 40.0,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfEvents.length,
                itemBuilder: (context, i) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          children: [
                            SizedBox(width: width(context)! * 0.1),
                            SizedBox(
                              width: width(context)! * 0.2,
                              child: Text(
                                listOfEvents[i].time!,
                                style: themeTextStyle(context: context),
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listOfEvents[i].eventName!,
                                    style: themeTextStyle(context: context),
                                  ),
                                  Text(
                                    listOfEvents[i].description!,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 50,
                        child: Container(
                          height: height(context)! * 0.7,
                          width: 1.0,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              color: listOfColors[random.nextInt(3)],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
