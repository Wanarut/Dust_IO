static final String os = System.getProperty("os.name");
// timeout interval
static final int timeout = 15000;
// screen index
int cur_screen = 0;
int save_screen = -1;
// software polling
long prev_mil = 0;
long counter_prev_mil = 0;
long prev_read_mil = 0;
long prev_filter_mil = 0;
// system font
PFont font_bold, font_regu, font_thai;
// navigation btn
Button menu, cancel;
// save data
JSONObject properties;

public void setup() {
    // size(1024, 600, JAVA2D);
    fullScreen();
    noCursor();
    // setup drawing style
    frameRate(15);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    // setup system font
    font_bold = createFont("Fira_Sans/FiraSans-Bold.ttf", 100);
    font_regu = createFont("Fira_Sans/FiraSans-Regular.ttf", 100);
    font_thai = createFont("THSarabunNew/THSarabunNew.ttf", 24);
    // setup screen
    setupPin();
    setupmain();
    select_setBtn();
    mode_setBtn();
    timer_setBtn();
    changefilter_setBtn();
    confirmfilter_setBtn();
    cleanESP_setBtn();
    // setup navigation btn
    menu = new Button(width / 7, int(height * 0.85), 150, 150, 1, 0, "btn/btn_back.jpg");
    cancel = new Button(width / 2, int(height * 0.85), 100, 100, 1, 0, "btn/logo.jpg");
    // load properties file
    properties = loadJSONObject("data/properties.json");
    if (properties == null) {
        println("not found properties file");
        properties = new JSONObject();
        properties.setInt("filter_lifetime", filter_lifetime_max);
        saveJSONObject(properties, "data/properties.json");
    }
}
// pwm fan
static final int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF
static final String fan_output_path = "../testPWM/fan_output.txt";

public void draw() {
    long cur_mil = millis();
    //timmer for switching to main page
    // if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
    //     prev_mil = cur_mil;
    //     cur_screen = 0;
    // }
    //read pm value & write duty cycle every 5 second
    if (cur_mil - prev_read_mil >= 5000) {
        prev_read_mil = cur_mil;
        // read pm value
        readPMvalue();
        // write duty cycle
        String[] data_str = new String[1];
        int duty_value = int(map(dimming, 1, level, 40, 0));
        data_str[0] = str(duty_value);
        saveStrings(fan_output_path, data_str);

        // pm_inValue = 100;
        // pm_outValue += 15;
        // pm_outValue %= 100;
        // println("pm_outValue:", pm_outValue);

        // Check ESP Efficiency
        if (isESPdirty()) {
            // save cur_screen
            if (save_screen < 0) save_screen = cur_screen;
            // switch to clean esp screen
            cur_screen = 6;
        } else{
            // load cur_screen
            if (save_screen >= 0) cur_screen = save_screen;
            save_screen = -1;
        }
    }
    //timmer for sleep
    if (start_count & cur_mil - counter_prev_mil >= 1000) {
        counter_prev_mil = cur_mil;
        // start countdown
        if (time_min > 0) {
            time_min--;
        } else {
            // end countdown
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
    }
    //decrease filter lifetime every minute
    if (cur_mil - prev_filter_mil >= 60000) {
        prev_filter_mil = cur_mil;
        decreaseFilterLife();
    }
    // select showing screen
    switch(cur_screen) {
        case 0 :
            main_screen();
            break;
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
        case 4 :
            screen_changefilter();
            break;
        case 5 :
            screen_confirmfilter();
            break;
        case 6 :
            screen_cleanESP();
            break;
        default :
        break;
    }
}

void mousePressed() {
    //reset timmer
    prev_mil = millis();
    // button is clicking
    switch(cur_screen) {
        case 0 :
            btnShutdown.hasPressed();
            if (filter_dirty) btnAlert.hasPressed();
            break;
        case 1 :
            btnMode.hasPressed();
            btnTimer.hasPressed();
            
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
        case 4 :
            btnNext.hasPressed();
            break;
        case 5 :
            btnYes.hasPressed();
            btnNo.hasPressed();
            break;
        default :
        break;
    }
}

void mouseReleased() {
    // button action
    switch(cur_screen) {
        case 0 :
            if (btnShutdown.hasReleased()) shutdown_now();
            else if (filter_dirty && btnAlert.hasReleased()) cur_screen = 4;
            else cur_screen = 1;
            break;
        case 1 :
            if (btnMode.hasReleased()) cur_screen = 2;
            if (btnTimer.hasReleased()) cur_screen = 3;
            
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 2 :
            controller();
            if (menu.hasReleased()) cur_screen = 1;
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 3 :
            calculatetime();
            if (menu.hasReleased()) cur_screen = 1;
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 4 :
            if (btnNext.hasReleased()) cur_screen = 5;
            break;
        case 5 :
            if (btnYes.hasReleased()) {
                filter_dirty = false;
                resetFilter();
                cur_screen = 0;
            }
            if (btnNo.hasReleased()) cur_screen = 0;
            break;
        default :
        break;	
    }
}

void keyPressed() {
    // press ESC for exit app
    if (key == ESC) {
        exit();
    }
}

void shutdown_now() {
    // linux shutdown command
    if (os.equals("Linux")) dimming = 9;
    if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
    Command cmd = new Command("shutdown now");
    if (cmd.run() == true) {
        String[] output = cmd.getOutput();
        println(output);
    }
}
