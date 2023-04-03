import paho.mqtt.client as mqtt
import urllib.request
import urllib.error

MQTT_SERVER = "192.168.43.174"
MQTT_TOPIC = "smarthome/+/+"

MQTT_PATH1 = "smarthome/devices/ldr1"
MQTT_PATH2 = "smarthome/devices/ldr2"

ldr1 = 0
ldr2 = 0

def on_connect(client, userdata, flags, rc): 
    client.subscribe(MQTT_PATH1)
    client.subscribe(MQTT_PATH2)


def on_message(client, userdata, message): 
    print("Message received. Topic: {}. Payload: {}".format(
             message.topic, str(message.payload)))

    if message.payload==b'1':
        message.payload=1

    if message.payload==b'0':
        message.payload=0
        
    if message.topic == MQTT_PATH1:
        global ldr1
        ldr1 = str(message.payload.decode("utf-8"))
        
    if message.topic == MQTT_PATH2:
        global ldr2
        ldr2 = str(message.payload.decode("utf-8"))

    # if message.payload==b'ON':
    #     message.payload=1

    # if message.payload==b'OFF':
    #     message.payload=0

    url = "http://192.168.43.174/mqtt-client-ldr.php?ldr1="+str(ldr1)+"&ldr2="+str(ldr2)
    contents = urllib.request.urlopen(url).read()
    print ((message.payload))


 
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

 
client.connect(MQTT_SERVER, 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()

