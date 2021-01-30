// Example by Tom Igoe

import processing.serial.*;

Serial myPort;  // The serial port
String SerialData = "";
boolean flag = false;

void setup() {
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[5], 4800);
}

void draw() {
  while (myPort.available() > 0) {
    char data = char(myPort.read());
    SerialData += data;
    if(SerialData.length() > 0 && data == '\n') flag = true;
  }
  if(flag){
    println(SerialData);
    SerialData = "";
    flag = false;
  }
}
