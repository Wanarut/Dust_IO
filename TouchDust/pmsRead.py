from pms7003 import Pms7003Sensor, PmsSensorException

try:
    sensor_0 = Pms7003Sensor('/dev/ttyAMA0')
    sensor_1 = Pms7003Sensor('/dev/ttyAMA1')
    print(sensor_0.read()['pm2_5'], sensor_1.read()['pm2_5'])
    sensor_0.close()
    sensor_1.close()
except:
    print('-1 -1')