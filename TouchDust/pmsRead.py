from pms7003 import Pms7003Sensor, PmsSensorException

pm_value_0 = -1
pm_value_1 = -1

try:
    sensor_0 = Pms7003Sensor('/dev/ttyAMA0')
    pm_value_0 = sensor_0.read()['pm2_5']
    sensor_0.close()
except:
    pass

try:
    sensor_1 = Pms7003Sensor('/dev/ttyAMA1')
    pm_value_1 = sensor_1.read()['pm2_5']
    sensor_1.close()
except:
    pass

print(pm_value_0, pm_value_1)