import processing.serial.*;
import processing.io.*;

int PM2_5 = 145;
color circle_c;
int humidity = 0;
int temperature = 35;

int ESPpin = 22;
int UVpin = 27;
int FANpin = 17;

Serial myPort;  // The serial port
String SerialData = "";
boolean flag = false;
String data[];

void pm_display() {
  if(readSerial()){
    data = split(SerialData, " ");
    println(SerialData);
    SerialData = "";
  }
  if(data.length != 6) return;
  
  //printArray(data);
  //println(int(data[4]));
  
  PM2_5 = int(data[0]);
  humidity = int(data[5]);
  temperature = int(data[4]);
  
  if(PM2_5 < 26) {
    circle_c = color(59, 204, 255);
    emoji = emoji_1;
    GPIO.digitalWrite(ESPpin, GPIO.LOW);
    GPIO.digitalWrite(UVpin, GPIO.LOW);
    GPIO.digitalWrite(FANpin, GPIO.LOW);
  } else if (PM2_5 < 38) {
    circle_c = color(146, 208, 80);
    emoji = emoji_2;
    GPIO.digitalWrite(ESPpin, GPIO.LOW);
    GPIO.digitalWrite(UVpin, GPIO.LOW);
    GPIO.digitalWrite(FANpin, GPIO.HIGH);
  } else if (PM2_5 < 51) {
    circle_c = color(255, 255, 0);
    emoji = emoji_3;
    GPIO.digitalWrite(ESPpin, GPIO.LOW);
    GPIO.digitalWrite(UVpin, GPIO.HIGH);
    GPIO.digitalWrite(FANpin, GPIO.HIGH);
  } else {
    GPIO.digitalWrite(ESPpin, GPIO.HIGH);
    GPIO.digitalWrite(UVpin, GPIO.HIGH);
    GPIO.digitalWrite(FANpin, GPIO.HIGH);
    if (PM2_5 < 91) {
      circle_c = color(255, 162, 0);
      emoji = emoji_4;
    } else {
      circle_c = color(255, 59, 59);
      emoji = emoji_5;
    }
  }
  
  fill(circle_c);
  ellipse(banner_position[0] - width*0.3, banner_position[1], banner_size[1]*0.9, banner_size[1]*0.9);
  image(emoji, banner_position[0] - width*0.3, banner_position[1], banner_size[1]*0.8, banner_size[1]*0.8);
  textAlign(RIGHT, CENTER);
  textFont(PMFont);
  text(str(PM2_5), pm_position[0], pm_position[1]);
  fill(255);
  textFont(UnFont);
  text("ug/m3", un_position[0], un_position[1]);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textFont(NYFont);
  text(str(humidity) + "%", ny_position[0], ny_position[1]);
  text(str(temperature) + "C", ny_position[2], ny_position[3]);
}

boolean readSerial(){
  while (myPort.available() > 0) {
    char ch = char(myPort.read());
    if(SerialData.length() > 1 && ch == '\n') {
      return true;
    } else {
      SerialData += ch;
    }
  }
  return false;
}
