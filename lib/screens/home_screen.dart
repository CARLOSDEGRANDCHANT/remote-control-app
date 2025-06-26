import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
//import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ui/utils/mqtt.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final mqttManager = MQTTManager();
  String? receivedData;

  void asyncInit() async {
    await mqttManager.connect();
    mqttManager.subscribe("TELEMETRYspc");
    mqttManager.client.updates!.listen(onData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncInit();
  }

  void onData(List<MqttReceivedMessage<MqttMessage>>? data) {

    if (data!.isNotEmpty) {

      var firstMessage = data[0].payload as MqttPublishMessage;
      setState(() {
        receivedData = MqttPublishPayload.bytesToStringAsString(
            firstMessage.payload.message);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            receivedData ?? "no data",
            style: TextStyle(
            fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black
        ),
        ),
      )


    );
  }
}