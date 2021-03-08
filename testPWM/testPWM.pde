import processing.io.*;

PWM pwm;

void setup() {
    size(300, 100);
    
    printArray(pwm.list());
    //you might need to use a different channel on other SBCs
    pwm = new PWM("pwmchip0/pwm0"); // GPIO pin 18
    //pwm = new PWM("pwmchip0/pwm1"); // GPIO pin 19
}
void draw() {
    background(255);
    pwm.set(map(mouseX, 0, width, 0.0, 1.0));
    line(mouseX, 0, mouseX, height);
}
