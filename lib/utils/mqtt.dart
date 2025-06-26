import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MQTTManager {
  // Establish connection with server as attribute.
  MqttClient client = MqttServerClient.withPort('mqtt.eclipseprojects.io', 'SPClient001', 1883);
  bool isClientConnected = false;

  Future<int> connect() async {
      client.logging(on: true);
      client.keepAlivePeriod = 60;
      client.onConnected = onConnected;
      client.onDisconnected = onDisconnected;
      client.onSubscribed = onSubscribed;
      client.pongCallback = pong;

      final connMessage =
      MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
      client.connectionMessage = connMessage;

      print("Client initialized");

      try {
        await client.connect();
        print('Client connected');
      } on NoConnectionException catch (e) {
        print('MQTTClient::Client exception - $e');
        client.disconnect();
      } on SocketException catch (e) {
        print('MQTTClient::Socket exception - $e');
        client.disconnect();
      }

    return 0;
  }

  void setOnData(void Function(List<MqttReceivedMessage<MqttMessage>>)? onData){
    if(isClientConnected){
      client.updates?.listen(onData);
    }else{
      print('Cannot get data. Client is no t connected');
    }
  }

  void disconnect(){
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    print('MQTTClient::Connected');
    isClientConnected = true;
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
    isClientConnected = false;
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }

}
