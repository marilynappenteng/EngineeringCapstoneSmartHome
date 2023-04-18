import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

late MqttClient client;
String status = '';
String message = '';

void connect() async {
  client = MqttServerClient('192.168.43.174', 'Gerald');
  client.keepAlivePeriod = 60;
  client.onConnected = () {
    status = 'Connected';
    client.subscribe('SmartVille', MqttQos.atMostOnce);
  };
  client.onDisconnected = () {
    status = 'Disconnected';
  };
  client.connect();
}

void publish(String message) {
  final builder = MqttClientPayloadBuilder();
  builder.addString(message);
  client.publishMessage(
      'smarthome/devices/ldr1', MqttQos.atMostOnce, builder.payload!);
}

void subscribe(String topic) {
  client.subscribe(topic, MqttQos.atLeastOnce);

  client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
    messages.forEach((MqttReceivedMessage<MqttMessage> message) {
      final MqttPublishMessage receivedMessage =
          message.payload as MqttPublishMessage;
      final String messageText = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
        message = messageText as MqttReceivedMessage<MqttMessage>;
    });
  });
}

void disconnect() {
  client.disconnect();
}
