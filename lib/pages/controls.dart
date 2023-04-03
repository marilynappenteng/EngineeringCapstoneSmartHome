import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // MQTT
  late MqttClient client;
  String status = '';
  Map<String, String> message = {};

  void connect() async {
    client = MqttServerClient('192.168.43.174', 'Gerald');
    client.keepAlivePeriod = 60;
    client.onConnected = () {
      setState(() {
        status = 'Connected';
      });
    };
    client.onDisconnected = () {
      setState(() {
        status = 'Disconnected';
      });
    };
    client.connect();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      messages.forEach((MqttReceivedMessage<MqttMessage> message) {
        final MqttPublishMessage receivedMessage =
            message.payload as MqttPublishMessage;
        final String topic = message.topic;
        final String messageText = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        setState(() {
          this.message[topic] = messageText;
        });
      });
    });
  }

  void disconnect() {
    client.disconnect();
  }

  @override
  void initState() {
    connect();
    super.initState();
  }

  void goHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goReadPowerMeasurements() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goSettings() {
    Navigator.pushReplacementNamed(context, '/settings');
  }

  void goHelp() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void bathroomLightsOn() {
    publish('smarthome/devices/lightbulb', '0');
  }

  void bathroomLightsOff() {
    publish('smarthome/devices/lightbulb', '1');
  }

  void bathroomTapOn() {
    publish('smarthome/devices/tap', '0');
  }

  void bathroomTapOff() {
    publish('smarthome/devices/tap', '1');
  }

  void bedroomBlindsOn() {
    publish('smarthome/devices/blindsmotor', '0');
  }

  void bedroomBlindsOff() {
    publish('smarthome/devices/blindsmotor', '1');
  }

  void bathroomDoorOn() {
    publish('smarthome/devices/door', '0');
  }

  void bathroomDoorOff() {
    publish('smarthome/devices/door', '1');
  }

  String buttonText_BathroomLights = "Activate";
  bool isActive_BathroomLights = false;

  String buttonText_BathroomTap = "Activate";
  bool isActive_BathroomTap = false;

  String buttonText_BedroomBlinds = "Activate";
  bool isActive_BedroomBlinds = false;

  String buttonText_BathroomDoor = "Activate";
  bool isActive_BathroomDoor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(56, 134, 151, 1),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Gerald Akita',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              accountEmail: const Text(
                'gerald_akita@yahoo.com',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/profile-bg3.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Read Power Measurements',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goSettings();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Help',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goLogout();
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(87, 65, 104, 1),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    color: const Color.fromRGBO(87, 65, 104, 0),
                    height: 750.0,
                    // width: double.infinity,
                  ),
                  Positioned(
                    top: 5,
                    left: 10,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: 30.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: const Color.fromRGBO(238, 238, 238, 1000),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300.0,
                    left: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: const Color.fromRGBO(238, 238, 238, 1000),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Lights',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(247, 236, 89, 1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomLights =
                                      !isActive_BathroomLights;
                                  setState(() {
                                    if (isActive_BathroomLights == true) {
                                      bathroomLightsOn();
                                      buttonText_BathroomLights = "Deactivate";
                                    } else {
                                      bathroomLightsOff();
                                      buttonText_BathroomLights = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomLights,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Tap',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(247, 236, 89, 1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomTap = !isActive_BathroomTap;
                                  setState(() {
                                    if (isActive_BathroomTap == true) {
                                      bathroomTapOn();
                                      buttonText_BathroomTap = "Deactivate";
                                    } else {
                                      bathroomTapOff();
                                      buttonText_BathroomTap = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomTap,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 250.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bedroom Blinds',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(247, 236, 89, 1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BedroomBlinds =
                                      !isActive_BedroomBlinds;
                                  setState(() {
                                    if (isActive_BedroomBlinds == true) {
                                      bedroomBlindsOn();
                                      buttonText_BedroomBlinds = "Deactivate";
                                    } else {
                                      bedroomBlindsOff();
                                      buttonText_BedroomBlinds = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BedroomBlinds,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 350.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Door',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 90),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(247, 236, 89, 1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomDoor =
                                      !isActive_BathroomDoor;
                                  setState(() {
                                    if (isActive_BathroomDoor == true) {
                                      bathroomDoorOn();
                                      buttonText_BathroomDoor = "Deactivate";
                                    } else {
                                      bathroomDoorOff();
                                      buttonText_BathroomDoor = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomDoor,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // controlTrigger('LED', 550, 40),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget controlTrigger(String device, double topVal, double leftVal) {
//   String buttonText = "Activate";
//   bool isActive = true;

//   return Positioned(
//     top: topVal,
//     left: leftVal,
//     child: Row(
//       // ignore: prefer_const_literals_to_create_immutables
//       children: [
//         Text(
//           device,
//           style: TextStyle(
//             color: Color.fromRGBO(238, 238, 238, 1),
//             fontFamily: 'Quicksand',
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 80),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: const Color.fromRGBO(247, 236, 89, 1),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: const Offset(0, 3),
//                   )
//                 ]),
//             child: Center(
//               child: TextButton(
//                 onPressed: () {
//                   isActive = !isActive;
//                   setState(() {
//                     // Put authentication function here
//                     isActive == true
//                         ? buttonText = "Deactivate"
//                         : buttonText = "Activate";
//                   });

//                   print(isActive);
//                 },
//                 child: Text(
//                   buttonText,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
