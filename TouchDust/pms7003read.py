import time
from pms7003 import Pms7003Thread

sensor = Pms7003Thread("/dev/serial0")
print(sensor.measurements)
