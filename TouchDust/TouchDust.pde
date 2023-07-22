static final String os = System.getProperty("os.name");

static final int timeout = 15000;
int cur_screen = 0;
long prev_mil = 0;
long counter_prev_mil = 0;
long prev_read_mil = 0;

PFont font_bold, font_regu;
Button menu, cancel, btnShutdown;

public void setup() {
    size(1024, 600, JAVA2D);
    //fullScreen();
    //noCursor();
    frameRate(15);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    // system font
    font_bold = createFont("Fira_Sans/FiraSans-Bold.ttf", 100);
    font_regu = createFont("Fira_Sans/FiraSans-Regular.ttf", 100);
    
    setupPin();
    setupGif();
    select_setBtn();
    mode_setBtn();
    timer_setBtn();
    
    // navigation btn
    menu = new Button(width / 7, int(height * 0.85), 150, 150, 1, 0, "btn/btn_back.jpg");
    cancel = new Button(width / 2, int(height * 0.85), 100, 100, 1, 0, "btn/logo.jpg");
}

static final int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF

public void draw() {
    long cur_mil = millis();
    //timmer for switching to main page
    // if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
    //     cur_screen = 0;
    //     prev_mil = cur_mil;
    // }
    //read pm value & write duty cycle every 5 second
    if (cur_mil - prev_read_mil >= 5000) {
        // read pm value
        readPMvalue();
        prev_read_mil = cur_mil;
        // write duty cycle
        String[] data_str = new String[1];
        int duty_value = int(map(dimming, 1, level, 40, 0));
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
            text_mode_post = "";
            text_level = "0";
            // setduty cycle = 0 & close ESP pin
            dimming = level;
            //if(os.equals("Linux")) pwmFan.set(period, 0);
            if (os.equals("Linux")) {
                GPIO.digitalWrite(pinESP, GPIO.LOW);
            }
            start_count = false;
        }
        counter_prev_mil = cur_mil;
    }
    // select showing screen
    switch (cur_screen) {
        case 1 :
            screen_select();
            cancel.display();
            break;
        case 2 :
            screen_mode();
            menu.display();
            cancel.display();
            break;
        case 3 :
            screen_timer();
            menu.display();
            cancel.display();
            break;
        default :
            main_screen();
            break;	
    }
}

void mousePressed() {
    //reset timmer
    prev_mil = millis();
    // button is clicking
    switch (cur_screen) {
        case 1 :
            btnMode.hasPressed();
            btnTimer.hasPressed();
            //btnShutdown.hasPressed();

            cancel.hasPressed();
            break;
        case 2 :
            btnFanPow.hasPressed();
            btnAutoHi.hasPressed();
            btnAutoEco.hasPressed();

            menu.hasPressed();
            cancel.hasPressed();
            break;
        case 3 :
            add.hasPressed();
            del.hasPressed();
            set.hasPressed();
            clear.hasPressed();

            menu.hasPressed();
            cancel.hasPressed();
            break;
        default :
            break;	
    }
}

void mouseReleased() {
    // button action
    switch (cur_screen) {
        case 1 :
            if (btnMode.hasReleased()) cur_screen = 2;
            if (btnTimer.hasReleased()) cur_screen = 3;
            //if (btnShutdown.hasReleased()) shutdown_now();
            break;
        case 2 :
            controller();
            break;
        case 3 :
            calculatetime();
            break;
        default :
            cur_screen = 1;
            break;	
    }
    if (menu.hasReleased()) cur_screen = 1;
    if (cancel.hasReleased()) cur_screen = 0;
}

void keyPressed() {
    // press ESC for exit app
    if (key == ESC) {
        exit();
    }
}
