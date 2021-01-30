#include "DHT.h"
DHT dht;
#include "PMS.h"
PMS pms1(Serial1);
PMS::DATA data1;
PMS pms2(Serial2);
PMS::DATA data2;
PMS pms3(Serial3);
PMS::DATA data3;
int pm25_1 = 0;
int pm10_1 = 0;
int pm25_2 = 0;
int pm25_3 = 0;
unsigned long pre = 0;
unsigned long post = 0;
/**************************************************************************************/
void setup() {
  Serial.begin(4800);
  Serial1.begin(9600);
  Serial2.begin(9600);
  Serial3.begin(9600);
  dht.setup(2);
}
/**************************************************************************************/
void loop() {
  float humidity = dht.getHumidity();
  float temperature = dht.getTemperature();
  if (pms1.read(data1)) {
    pm25_1 = data1.PM_AE_UG_2_5;
    pm10_1 = data1.PM_AE_UG_10_0;
  }
  if (pms2.read(data2))
    pm25_2 = data2.PM_AE_UG_2_5;
  if (pms3.read(data3))
    pm25_3 = data3.PM_AE_UG_2_5;
  pre = millis();
  if (pre - post > 2000) {
    Serial.print(pm25_1);
    Serial.print(" ");
    Serial.print(pm10_1);
    Serial.print(" ");
    Serial.print(pm25_2);
    Serial.print(" ");
    Serial.print(pm25_3);
    Serial.print(" ");
    Serial.print(temperature, 1);
    Serial.print(" ");
    Serial.print(humidity, 0);
    Serial.print("\n");
    post = pre;
  }
}
