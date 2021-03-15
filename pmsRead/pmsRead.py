from pms7003 import Pms7003Sensor, PmsSensorException

try:
    sensor = Pms7003Sensor('/dev/serial0')
    print(sensor.read()['pm2_5'])
except:
    print('PMS Fail')