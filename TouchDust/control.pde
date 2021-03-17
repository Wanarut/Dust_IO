//import processing.io.*;

//PWM pwmFan;
int period = 1000; // 1 kHz
int pinESP = 24;
int pinZC = 4;
boolean zcState = false;  // 0 = ready, 1 = processing

void setupPin() {
  //GPIO.pinMode(pinESP, GPIO.OUTPUT);
  //GPIO.pinMode(pinZC, GPIO.INPUT_PULLUP);
  //GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
  //pwmFan = new PWM("pwmchip0/pwm0"); // GPIO pin 18
  
  //GPIO.digitalWrite(pinESP, GPIO.HIGH);
  //pwmFan.set(period, 0.5);
}

void zcDetectISR(int pin) {
  if (!zcState) {
    zcState = true;
    //pwmFan.set(period, 0);
  }
}
