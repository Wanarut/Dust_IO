String os = System.getProperty("os.name");

int timeout = 15000;
long cur_screen = 0;
long prev_mil = 0;
long counter_prev_mil = 0;
long prev_read_mil = 0;

public void setup() {
    size(1024, 600, JAVA2D);
    //fullScreen();
    //noCursor();
    frameRate(15);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    
    setupPin();
    setupGif();
    select_setBtn();
    mode_setBtn();
    timer_setBtn();
}

int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF

public void draw() {
    long cur_mil = millis();
    //timmer for switching to main page
    if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
        cur_screen = 0;
        prev_mil = cur_mil;
    }
    //read pm value & write duty cycle every 5 second
    if (cur_mil - prev_read_mil >= 5000) {
        // read pm value
        readPMvalue();
        prev_read_mil = cur_mil;
        // write duty cycle
        String[] data_str = new String[1];
        int duty_value = int(map(dimming, 1, 7, 40, 3));
        data_str[0] = str(duty_value);
        saveStrings("/home/pi/Dust_IO/testPWM/fan_output.txt", data_str);
    }
    //timmer for sleep
    if (start_count & cur_mil - counter_prev_mil >= 1000) {
        if (time_min > 0) {
            time_min--;
            //pm_inValue+=10;
        } else {
            println("Timer End");
            text_mode = "OFF";
            text_level = "0";
            //if(os.equals("Linux")) pwmFan.set(period, 0);
            if (os.equals("Linux")) {
                // setduty cycle = 0 & close ESP pin
                dimming = 9;
                GPIO.digitalWrite(pinESP, GPIO.LOW);
            }
            start_count = false;
        }
        counter_prev_mil = cur_mil;
    }
    // select showing screen
    if (cur_screen ==  0) main_screen();
    else if (cur_screen ==  1) screen_select();
    else if (cur_screen ==  2) screen_mode();
    else if (cur_screen ==  3) screen_timer();
}

void mousePressed() {
    //reset timmer
    prev_mil = millis();
    if (cur_screen ==  1) {
        btnMode.hasPressed();
        btnTimer.hasPressed();
        btnShutdown.hasPressed();
    } else if (cur_screen ==  2) {
        btnHi.hasPressed();
        btnEco.hasPressed();
        for (int i = 0; i < btnPower.length; i++) {
            btnPower[i].hasPressed();
        }
    } else if (cur_screen ==  3) {
        add.hasPressed();
        del.hasPressed();
        set.hasPressed();
        clear.hasPressed();
        cancel.hasPressed();
    }
}

void mouseReleased() {
    if (cur_screen ==  0) cur_screen = 1;
    else if (cur_screen ==  1) {
        if (btnMode.hasReleased()) cur_screen = 2;
        if (btnTimer.hasReleased()) cur_screen = 3;
        if (btnShutdown.hasReleased()) shutdown_now();
    } else if (cur_screen ==  2) controller();
    else if (cur_screen ==  3) calculatetime();
}

void keyPressed() {
    if (key == ESC) {
        //fan_output.flush();
        //fan_output.close();
        exit();
    }
}
