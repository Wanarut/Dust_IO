import processing.io.*;

static final int pinESP = 23;
static final int pinZC = 4;
static final int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing

void setupPin() {
  // setup pin of pi
  if(os.equals("Linux")) {
    GPIO.pinMode(pinESP, GPIO.OUTPUT);
    //GPIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
    //GPIO.pinMode(pinZC, GPIO.INPUT);
    //GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
    
    GPIO.digitalWrite(pinESP, GPIO.HIGH);
  }
}

void zcDetectISR(int pin) {
  if (dimming < level) {
    int dimtime = (dimming);
    delay(dimtime);
    if(os.equals("Linux")){
      //GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
    }
    delay(1);
  }
  if(os.equals("Linux")){
    //GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
  }
}
