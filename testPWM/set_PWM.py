import RPi.GPIO as GPIO
import sys

#pwm12.stop()
#GPIO.cleanup()

def check_duty_cycle(duty_cycle):
    try:
        duty = float(duty_cycle)
        if (duty > 0 and duty < 95):
            print('Valid Duty Cycle')
            return True
    except:
        print('Invalid Duty Cycle (except)')
        return False
    print('Invalid Duty Cycle')
    return False

# Setup GPIO Pins
fan_pin = 12 # GPIO 18
frequency = 1500

#GPIO.cleanup()
#GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(fan_pin, GPIO.OUT)

# Set PWM instance and their frequency
pwm12 = GPIO.PWM(fan_pin, frequency)


if (len(sys.argv)==2 and check_duty_cycle(sys.argv[1])): 
    duty = float(sys.argv[1])
else:
    duty = 100
    
pwm12.start(duty)
print('Set Duty Cycle: ' + str(duty) + '%')

input('stop?')
