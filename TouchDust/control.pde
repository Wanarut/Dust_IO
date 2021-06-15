//import processing.io.*;

int pinESP = 23;
int pinZC = 4;
int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing
int level = 9;
int dimming = level/2; // Dimming level (0-9)  0 = ON, 9 = OFF

void setupPin() {
  //if(os.equals("Linux")) {
  //  GPIO.pinMode(pinESP, GPIO.OUTPUT);
  //  PIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
  //  GPIO.pinMode(pinZC, GPIO.INPUT);
  //  GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
    
  //  GPIO.digitalWrite(pinESP, GPIO.HIGH);
  //}
}

void zcDetectISR(int pin) {
  if (dimming < level) {
    int dimtime = (dimming);
    delay(dimtime);
    //if(os.equals("Linux")){
    //  GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
    //}
    delay(1);
  }
  //if(os.equals("Linux")){
  //  GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
  //}
}
