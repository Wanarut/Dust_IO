import RPi.GPIO as GPIO
import time

# Setup GPIO Pins
fan_pin = 12 # GPIO 18
frequency = 3000

GPIO.setmode(GPIO.BOARD)
GPIO.setup(fan_pin, GPIO.OUT)

# Set PWM instance and their frequency
pwm12 = GPIO.PWM(fan_pin, frequency)
pwm12.start(0)
print('Start Reading Dimming')

try:
    while True:
        try:
            fan_file = open("/home/pi/Dust_IO/testPWM/fan_output.txt", "r")
            duty_str = fan_file.readline()
            fan_file.close()
            duty = float(duty_str)
        except:
            continue
        print('Set Duty Cycle: ' + str(duty) + '%')
        pwm12.ChangeDutyCycle(duty)
        
        time.sleep(1)
except KeyboardInterrupt:
    pass
    
pwm12.stop()
GPIO.cleanup()
print('Stop Reading Dimming')