import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Home extends StatefulWidget {
  var username;
  Home({Key? key, this.username}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  String humidity = "";
  Future readHumidity() async {
    http.Response response =
        await http.get(Uri.parse("http://192.168.0.103/readhumidity"));
    humidity = response.body;
    // debugPrint(humidity);
  }

  String accName = "";
  Future getFirstName() async {
    http.Response response = await http.get(Uri.parse(
        "http://192.168.43.155/smarthome/name.php?email=${widget.username}"));
    accName = response.body;
  }

  String accEmail = "";
  Future getEmail() async {
    http.Response response = await http.get(Uri.parse(
        "http://192.168.43.155/smarthome/email.php?email=${widget.username}"));
    accEmail = response.body;
  }

  @override
  void initState() {
    getFirstName();
    getEmail();
    connect();
    Timer mytimer = Timer.periodic(Duration(seconds: 5), (timer) {
      subscribe('smarthome/devices/ldr1');
      setState(() {});
      //mytimer.cancel() //to terminate this timer
    });
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

  void goControls() {
    Navigator.pushReplacementNamed(context, '/controls');
  }

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
              accountName: Text(
                accName,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              accountEmail: Text(
                accEmail,
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
                    top: 50.0,
                    left: 40.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Override System',
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
                                  setState(() {
                                    // Put authentication function here
                                    goControls();
                                  });
                                },
                                child: const Text(
                                  'Activate',
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
                    top: 150.0,
                    left: 50.0,
                    right: 50.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Total Power Used',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                message['smarthome/devices/ldr1'] ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Today',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                '500kWh',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Last Week',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                '2500kWh',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Last Month',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
