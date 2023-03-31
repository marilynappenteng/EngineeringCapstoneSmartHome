import paho.mqtt.client as mqtt
import urllib.request
import urllib.error

MQTT_SERVER = "192.168.43.174"
MQTT_TOPIC = "smarthome/+/+"

MQTT_PATH1 = "smarthome/devices/ldr1"
MQTT_PATH2 = "smarthome/devices/ldr2"
MQTT_PATH3 = "smarthome/devices/door1ultra1"
MQTT_PATH4 = "smarthome/devices/door1ultra2"
MQTT_PATH5 = "smarthome/devices/voltage"
MQTT_PATH6 = "smarthome/devices/current"
MQTT_PATH7 = "smarthome/devices/flowrate"
MQTT_PATH8 = "smarthome/devices/distance"


ldr1 = 0
ldr2 = 0
ultrasonic1 = 0
ultrasonic2 = 0
housevoltage = 0 
housecurrent = 0
kitchenflow = 0
kitchendistance = 0


def on_connect(client, userdata, flags, rc): 
    client.subscribe(MQTT_TOPIC)


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
        
    if message.topic == MQTT_PATH3:
        global ultrasonic1
        ultrasonic1 = str(message.payload.decode("utf-8"))

    if message.topic == MQTT_PATH4:
        global ultrasonic2
        ultrasonic2 = str(message.payload.decode("utf-8"))

    if message.topic == MQTT_PATH5:
        global housevoltage
        housevoltage = str(message.payload.decode("utf-8"))
   
    if message.topic == MQTT_PATH6:
        global housecurrent
        housecurrent = str(message.payload.decode("utf-8"))
        
    if message.topic == MQTT_PATH7:
        global kitchenflow
        kitchenflow = str(message.payload.decode("utf-8"))
        
    if message.topic == MQTT_PATH8:
        global kitchendistance
        kitchendistance = str(message.payload.decode("utf-8"))

    # if message.payload==b'ON':
    #     message.payload=1

    # if message.payload==b'OFF':
    #     message.payload=0

    url = "http://192.168.43.174/mqtt-client-database.php?ldr1="+str(ldr1)+"&ldr2="+str(ldr2)+"&ultrasonic1="+str(ultrasonic1)+"&ultrasonic2="+str(ultrasonic2)+"&housevoltage="+str(housevoltage)+"&housecurrent="+str(housecurrent)+"&kitchenflow="+str(kitchenflow)+"&kitchendistance="+str(kitchendistance)

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
