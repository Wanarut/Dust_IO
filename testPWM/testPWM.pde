import processing.io.*;
PWM pwm;

int AC_LOAD = 18;

void setup() {
    size(300, 100);
    
    GPIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
    printArray(pwm.list());
    //you might need to use a different channel on other SBCs
    pwm = new PWM("pwmchip0/pwm0"); // GPIO pin 18
    //pwm = new PWM("pwmchip0/pwm1"); // GPIO pin 19
}
void draw() {
    background(255);
    float value = map(mouseX, 0, width, 0.0, 1.0);
    if(value > 0){
      pwm.set(value);
    }else{
      GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
      //println(value);
    }
    line(mouseX, 0, mouseX, height);
}
