import processing.io.*;
//PWM pwmFan;

int period = 1000; // 1 kHz
int pinESP = 23;
int pinZC = 4;
int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing
int min_level = 9;
int dimming = min_level/2; // Dimming level (0-9)  0 = ON, 9 = OFF

void setupPin() {
  if(os.equals("Linux")) {
    GPIO.pinMode(pinESP, GPIO.OUTPUT);
    PIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
    GPIO.pinMode(pinZC, GPIO.INPUT);
    GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
    //pwmFan = new PWM("pwmchip0/pwm0"); // GPIO pin 18
    
    //GPIO.digitalWrite(pinESP, GPIO.HIGH);
    //pwmFan.set(period, 0.5);
  }
}

void zcDetectISR(int pin) {
  if (dimming < min_level) {
    int dimtime = (dimming);
    delay(dimtime);
    if(os.equals("Linux")) GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
    delay(1);
  }
  if(os.equals("Linux")) GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
}
