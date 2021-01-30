#include <ESP8266WiFi.h> // เรียกใช้ไลบรารี่สำหรับใช้งาน WIFI
#include <SoftwareSerial.h> // เรียกใช้ไลบรารี่สำหรับใช้งาน SoftwareSerial
SoftwareSerial NodeSerial(D2, D3);
#define BLYNK_PRINT Serial
#include <BlynkSimpleEsp8266.h> // เรียกใช้ไลบรารี่สำหรับใช้งาน Blynk
#define ssid      "Dustkiller" //ตั้งชื่อไวไฟ
#define password  "wifi8266" //ตั้งรหัสผ่านไวไฟ
char auth[] = "S3jJOLXhmo3Pe8cKek0ohR-Ay4XI-6ST"; //ตั้ง auth สำหรับ ใช้งานแอป Blynk
#define relay1 D5 // ประกาศขาสำหรับ relay1
#define relay2 D6 // ประกาศขาสำหรับ relay2
#define relay3 D7 // ประกาศขาสำหรับ relay3
int pm2_5_1;
int pm10_1;
int pm2_5_2;
int pm2_5_3;
float temp;
int humidity;
WidgetLED led1(V5); // ประกาศขาสำหรับ led1 ในแอป blynk
WidgetLED led2(V6); // ประกาศขาสำหรับ led2 ในแอป blynk
WidgetLED led3(V7); // ประกาศขาสำหรับ led3 ในแอป blynk
WidgetLED ledAuto(V12); // ประกาศขาสำหรับ ledAUTO ในแอป blynk
BLYNK_CONNECTED() { // sync การทำงานทุกครั้งที่เปิดใช้งานเครื่อง
  Blynk.syncAll();
}
int btAuto;
BLYNK_WRITE(V11) { //อ่านค่าปุ่ม 1
  btAuto = param.asInt();
}
BLYNK_WRITE(V8) { //อ่านค่าปุ่ม 1
  int bt1 = param.asInt();
  if (btAuto == 0) {
    if (bt1 == 1) {
      led1.on();
      digitalWrite(relay1, 1);
    }
    else {
      led1.off();
      digitalWrite(relay1, 0);
    }
  }
}
BLYNK_WRITE(V9) { //อ่านค่าปุ่ม 2
  int bt2 = param.asInt();
  if (btAuto == 0) {
    if (bt2 == 1) {
      led2.on();
      digitalWrite(relay2, 1);
    }
    else {
      led2.off();
      digitalWrite(relay2, 0);
    }
  }
}
BLYNK_WRITE(V10) { //อ่านค่าปุ่ม 3
  int bt3 = param.asInt();
  if (btAuto == 0) {
    if (bt3 == 1) {
      led3.on();
      digitalWrite(relay3, 1);
    }
    else {
      led3.off();
      digitalWrite(relay3, 0);
    }
  }
}
void setup() {
  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);
  pinMode(relay1, OUTPUT);
  pinMode(relay2, OUTPUT);
  pinMode(relay3, OUTPUT);
  digitalWrite(relay1, 0);
  digitalWrite(relay2, 0);
  digitalWrite(relay3, 0);
  NodeSerial.begin(4800);
  Serial.begin(9600);
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Blynk.begin(auth, ssid, password);
}
void loop() {
  while (NodeSerial.available() > 0) {
    pm2_5_1 = NodeSerial.parseInt();
    pm10_1 = NodeSerial.parseInt();
    pm2_5_2 = NodeSerial.parseInt();
    pm2_5_3 = NodeSerial.parseInt();
    temp = NodeSerial.parseFloat();
    humidity = NodeSerial.parseInt();
    if (NodeSerial.read() == '\n') {
      Serial.print(pm2_5_1);
      Serial.print(" : ");
      Serial.print(pm10_1);
      Serial.print(" : ");
      Serial.print(pm2_5_2);
      Serial.print(" : ");
      Serial.print(pm2_5_3);
      Serial.print(" : ");
      Serial.print(temp);
      Serial.print(" : ");
      Serial.println(humidity);
    }
  }
  if (btAuto == 1) {
    if (pm2_5_1 < 10) {
      digitalWrite(relay1, 0);
      digitalWrite(relay2, 0);
      digitalWrite(relay3, 0);
    } else {
      digitalWrite(relay1, 1);
      digitalWrite(relay2, 1);
      digitalWrite(relay3, 1);
    }
  }
  Blynk.virtualWrite(V0, temp);
  Blynk.virtualWrite(V1, humidity);
  Blynk.virtualWrite(V2, pm2_5_1);
  Blynk.virtualWrite(V3, pm2_5_2);
  Blynk.virtualWrite(V4, pm2_5_3);
  Blynk.run();
}
