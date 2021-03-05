import RPi.GPIO as GPIO
import sys

pwmPin = int(sys.argv[1])	    # PWM output pin
duty_cycle = int(sys.argv[2])   # Duty cycle value

GPIO.setwarnings(False)			#disable warnings
GPIO.setmode(GPIO.BCM)		#set pin numbering system
GPIO.setup(pwmPin, GPIO.OUT)

pi_pwm = GPIO.PWM(pwmPin, 1000) #create PWM instance with frequency
pi_pwm.stop()
pi_pwm.start(0)
pi_pwm.ChangeDutyCycle(duty_cycle)	    #start PWM of required Duty Cycle
print("PWM Done!")