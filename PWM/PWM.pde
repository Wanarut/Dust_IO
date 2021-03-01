import processing.io.*;
SoftwareServo pwm;

float gear[] = {0, 90, 135, 180};
int gear_i = 0;
int pwmPin = 4;

void setup() {
  frameRate(0.5);
  pwm = new SoftwareServo(this);
  pwm.attach(pwmPin);
  // On the Raspberry Pi, GPIO 4 is pin 7 on the pin header,
  // located on the fourth row, above one of the ground pins
}

void draw() {
  // Here we are using the Software Servo class as a Kludge (as recommended by Processing) for PWM.
  // The only software PWM available in the processing.io library is
  // SoftwareServo, intended for pwm motors, not LEDs, or DC motors.
  // Therefore:
  //    100% PWM == 180 degrees.
  //     75% PWM == 135 degrees.
  //     50% PWM == 90 degrees.
  //      0% PWM == 0 degrees.

  pwm.write(gear[gear_i]);
  println(gear[gear_i]);
  gear_i++;
  gear_i %= gear.length;
}
