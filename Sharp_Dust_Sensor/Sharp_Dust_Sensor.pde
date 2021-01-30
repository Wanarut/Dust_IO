import processing.io.*;
SPI adc;
/////////////////////////////////////////////////////////////////////////////
// Sharp GP2Y1014AU0F Dust Sensor Demo
//
// Board Connection:
//   GP2Y1014    Arduino
//   V-LED       Between R1 and C1 (R1=150ohms, C1=220uF)
//   LED-GND     C1 and GND
//   LED         Pin 7
//   S-GND       GND
//   Vo          A5
//   Vcc         5V
//
// Serial monitor setting:
//   9600 baud
/////////////////////////////////////////////////////////////////////////////

boolean PRINT_RAW_DATA = false;
boolean USE_AVG = false;

// Arduino pin numbers.
int sharpLEDPin = 7;   // Arduino digital pin 7 connect to sensor LED.
//const sharpVoPin = A5;   // Arduino analog pin 5 connect to sensor Vo.

// For averaging last N raw voltage readings.
//#ifdef USE_AVG
int N = 100;
static long VoRawTotal = 0;
static int VoRawCount = 0;
//#endif // USE_AVG

// Set the typical output voltage in Volts when there is zero dust. 
static float Voc = 0.6;

// Use the typical sensitivity in units of V per 100ug/m3.
float K = 0.5;
float max_dval = 4096.0
  
/////////////////////////////////////////////////////////////////////////////

// Helper functions to print a data value to the serial monitor.
void printValue(String text, long value, boolean isLast) {
  print(text);
  print("=");
  print(value);
  if (!isLast) {
    print(", ");
  }
}
void printFValue(String text, float value, String units, boolean isLast) {
  print(text);
  print("=");
  print(value);
  print(units);
  if (!isLast) {
    print(", ");
  }
}
int SPIRead(SPI adc){
  // read in values over SPI from an analog-to-digital
  // converter
  // dummy write, actual values don't matter
  byte[] out = { 0, 0 };
  byte[] in = adc.transfer(out);
  // some input bit shifting according to the datasheet
  int val = ((in[0] & 0x1f) << 5) | ((in[1] & 0xf8) >> 3);
  // val is between 0 and 1023
  return val;
}
float calculate_dust(float Vo){
  // Compute the output voltage in Volts.
  Vo = Vo / max_dval * 5.0;
  printFValue("Vo", Vo*1000.0, "mV", false);

  // Convert to Dust Density in units of ug/m3.
  float dV = Vo - Voc;
  if ( dV < 0 ) {
    dV = 0;
    Voc = Vo;
  }
  float dustDensity = dV / K * 100.0;
  return dustDensity;
}

/////////////////////////////////////////////////////////////////////////////

// setup function.
void setup() {
  // Choose program options.
  PRINT_RAW_DATA = true;
  //USE_AVG = true;
  
  printArray(SPI.list());
  adc = new SPI(SPI.list()[0]);
  adc.settings(500000, SPI.MSBFIRST, SPI.MODE0);
  
  // Set LED pin for output.
  GPIO.pinMode(sharpLEDPin, GPIO.OUTPUT);
  
  // Wait two seconds for startup.
  delay(2000);
  println("");
  println("GP2Y1014AU0F Demo");
  println("=================");
}

// main loop.
void draw() {
  // Turn on the dust sensor LED by setting digital pin LOW.
  GPIO.digitalWrite(sharpLEDPin, GPIO.LOW);

  // Wait 1ms before taking a reading of the output voltage as per spec.
  delay(1);

  // Record the output voltage. This operation takes around 100 microseconds.
  int VoRaw = SPIRead(adc);
  
  // Turn the dust sensor LED off by setting digital pin HIGH.
  GPIO.digitalWrite(sharpLEDPin, GPIO.HIGH);

  // Wait for remainder of the 10ms cycle = 10000 - 280 - 100 microseconds.
  delay(10);
  
  // Print raw voltage value (number from 0 to 1023).
  if (PRINT_RAW_DATA) {
    printValue("VoRaw", VoRaw, true);
    println("");
  } // PRINT_RAW_DATA
  
  // Use averaging if needed.
  float Vo = VoRaw;
  if (USE_AVG) {
    VoRawTotal += VoRaw;
    VoRawCount++;
    if ( VoRawCount >= N ) {
      Vo = 1.0 * VoRawTotal / N;
      VoRawCount = 0;
      VoRawTotal = 0;
    } else {
      return;
    }
  } // USE_AVG
  float dustDensity = calculate_dust(Vo);
  printFValue("DustDensity", dustDensity, "ug/m3", true);
  println("");
  
} // END PROGRAM
