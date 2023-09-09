static final String os = System.getProperty("os.name");
// screen timeout interval
static final int SCREEN_TIMEOUT = 60000;
static final int HOLD_TIME = 5000;
// screen index
static final int SCREEN_MAIN = 0;
static final int SCREEN_MENU = 1;
static final int SCREEN_MODE = 2;
static final int SCREEN_TIMER = 3;
static final int SCREEN_CHANGEFILTER = 4;
static final int SCREEN_CONFIRMFILTER = 5;
static final int SCREEN_CLEANESP = 6;
static final int SCREEN_SHUTDOWN = 7;
static final int SCREEN_FILTER = 8;
int cur_screen = SCREEN_MAIN;
int save_screen = -1;
// software polling
long prev_mil = 0;
long counter_prev_mil = 0;
long prev_read_mil = 0;
long prev_filter_mil = 0;
long prev_esp_mil = 0;
long prev_shutdown_mil = 0;
// system font
PFont font_bold, font_regu, font_thai;
// navigation btn
Button menu, cancel;
// save data
static final String properties_file = "data/properties.json";
static final String lifetime_key = "filter_lifetime";
JSONObject properties;

public void setup() {
    size(1280, 720, JAVA2D);
    // fullScreen();
    // noCursor();
    // setup drawing style
    frameRate(15);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    // setup system font
    font_bold = createFont("Fira_Sans/FiraSans-Bold.ttf", 100);
    font_regu = createFont("Fira_Sans/FiraSans-Regular.ttf", 100);
    font_thai = createFont("THSarabunNew/THSarabunNew.ttf", 36);
    // setup screen
    setupPin();
    setupmain();
    select_setBtn();
    mode_setBtn();
    timer_setBtn();
    changefilter_setBtn();
    confirmfilter_setBtn();
    cleanESP_setBtn();
    confirmShutdown_setBtn();
    filter_setBtn();
    // setup navigation btn
    menu = new Button(width / 7, int(height * 0.85), 150, 150, 1, 0, "btn/btn_back.jpg");
    cancel = new Button(width / 2, int(height * 0.85), 100, 100, 1, 0, "btn/logo.jpg");
    // load properties file
    properties = loadJSONObject(properties_file);
    if (properties == null) {
        println("not found properties file");
        properties = new JSONObject();
        properties.setInt(lifetime_key, filter_lifetime_max);
        saveJSONObject(properties, properties_file);
    }
}
// pwm fan
static final int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF
static final String fan_output_path = "/home/pi/Dust_IO/testPWM/fan_output.txt";
String duty_cycles[] = new String[]{"0", "3", "10", "20", "40"};

public void draw() {
    long cur_mil = millis();
    //timmr for switching to main page
    if (cur_mil - prev_mil >= SCREEN_TIMEOUT & cur_screen != SCREEN_CONFIRMFILTER) {
        prev_mil = cur_mil;
        cur_screen = SCREEN_MAIN;
    }
    
    // adaptive fan simulation
    pm_inValue++;
    pm_inValue%=300;
    // adaptiveFan();
    
    //read pm value & write duty cycle every 5 second
    if (cur_mil - prev_read_mil >= 5000) {
        prev_read_mil = cur_mil;
        // read pm value
        readPMvalue();
        // write duty cycle
        String[] data_str = new String[1];
        // int duty_value = int(map(dimming, 1, level, 40, 0));
        data_str[0] = duty_cycles[fan_index];
        saveStrings(fan_output_path, data_str);
        
        // clean esp simulation
        // pm_inValue = 100;
        // pm_outValue += 15;
        // pm_outValue %= 100;
        // println("pm_outValue:", pm_outValue);
        
        adaptiveFan();
    }
    //timer for sleep
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
            // setduty cycle = 0 & close ESP pin
            dimming = level;
            //if(os.equals("Linux")) pwmFan.set(period, 0);
            if (os.equals("Linux")) {
                GPIO.digitalWrite(pinESP, GPIO.LOW);
            }
            start_count = false;
            shutdown_now();
        }
    }
    //decrease filter lifetime every minute
    if (cur_mil - prev_filter_mil >= 60000) {
        prev_filter_mil = cur_mil;
        decreaseFilterLife();
    }
    //check ESP Efficiency every 10 minutes
    if (cur_mil - prev_esp_mil >= 600000) {
        prev_esp_mil = cur_mil;
        // Check ESP Efficiency
        if (isESPdirty()) {
            // save cur_screen
            if (save_screen < SCREEN_MAIN) save_screen = cur_screen;
            // switch to clean esp screen
            cur_screen = SCREEN_CLEANESP;
        } else{
            // load cur_screen
            if (save_screen >= SCREEN_MAIN) cur_screen = save_screen;
            save_screen = -1;
        }
    }
    // select showing screen
    switch(cur_screen) {
        case SCREEN_MAIN :
            main_screen();
            break;
        case SCREEN_MENU :
            screen_select();
            cancel.display();
            break;
        case SCREEN_MODE :
            screen_mode();
            menu.display();
            cancel.display();
            break;
        case SCREEN_TIMER :
            screen_timer();
            menu.display();
            cancel.display();
            break;
        case SCREEN_CHANGEFILTER :
            screen_changefilter();
            break;
        case SCREEN_CONFIRMFILTER :
            screen_confirmfilter();
            break;
        case SCREEN_CLEANESP :
            screen_cleanESP();
            break;
        case SCREEN_SHUTDOWN :
            screen_confirmshutdown();
            break;
        case SCREEN_FILTER :
            screen_filter();
            menu.display();
            cancel.display();
            break;
        default :
        break;
    }
}

void mousePressed() {
    //reset timer
    prev_mil = millis();
    // button is clicking
    switch(cur_screen) {
        case SCREEN_MAIN :
            if (btnShutdown.hasPressed()) prev_shutdown_mil = prev_mil;
            if (filter_dirty) btnAlert.hasPressed();
            break;
        case SCREEN_MENU :
            btnMode.hasPressed();
            btnTimer.hasPressed();
            btnFilter.hasPressed();

            cancel.hasPressed();
            break;
        case SCREEN_MODE :
            btnFanPow.hasPressed();
            btnAutoHi.hasPressed();
            btnAutoEco.hasPressed();
            
            menu.hasPressed();
            cancel.hasPressed();
            break;
        case SCREEN_TIMER :
            add.hasPressed();
            del.hasPressed();
            set.hasPressed();
            clear.hasPressed();
            
            menu.hasPressed();
            cancel.hasPressed();
            break;
        case SCREEN_CHANGEFILTER :
            btnNext.hasPressed();
            break;
        case SCREEN_CONFIRMFILTER :
            btnYes.hasPressed();
            btnNo.hasPressed();
            break;
        case SCREEN_SHUTDOWN :
            btnShutYes.hasPressed();
            btnShutNo.hasPressed();
            break;
        case SCREEN_FILTER :
            if (filter_dirty) btnAlert.hasPressed();
            btnHidden.hasPressed();

            menu.hasPressed();
            cancel.hasPressed();
            break;
        default :
        break;
    }
}

void mouseReleased() {
    long current_mil = millis();
    // button action
    switch(cur_screen) {
        case SCREEN_MAIN :
            if (btnShutdown.hasReleased()){
                if (current_mil - prev_shutdown_mil > HOLD_TIME) cur_screen = SCREEN_SHUTDOWN;
            } else if (filter_dirty && btnAlert.hasReleased()) cur_screen = SCREEN_CHANGEFILTER;
            else cur_screen = SCREEN_MENU;
            break;
        case SCREEN_MENU :
            if (btnMode.hasReleased()) cur_screen = SCREEN_MODE;
            if (btnTimer.hasReleased()) cur_screen = SCREEN_TIMER;
            if (btnFilter.hasReleased()) cur_screen = SCREEN_FILTER;

            if (cancel.hasReleased()) cur_screen = SCREEN_MAIN;
            break;
        case SCREEN_MODE :
            controller();
            if (menu.hasReleased()) cur_screen = SCREEN_MENU;
            if (cancel.hasReleased()) cur_screen = SCREEN_MAIN;
            break;
        case SCREEN_TIMER :
            calculatetime();
            if (menu.hasReleased()) cur_screen = SCREEN_MENU;
            if (cancel.hasReleased()) cur_screen = SCREEN_MAIN;
            break;
        case SCREEN_CHANGEFILTER :
            if (btnNext.hasReleased()) cur_screen = SCREEN_CONFIRMFILTER;
            break;
        case SCREEN_CONFIRMFILTER :
            if (btnYes.hasReleased()) {
                filter_dirty = false;
                resetFilter();
                cur_screen = SCREEN_MAIN;
            }
            if (btnNo.hasReleased()) cur_screen = SCREEN_MAIN;
            break;
        case SCREEN_CLEANESP :
            if (save_screen >= SCREEN_MAIN) cur_screen = save_screen;
            save_screen = -1;
        case SCREEN_SHUTDOWN :
            if (btnShutYes.hasReleased()) {
                shutdown_now();
            }
            if (btnShutNo.hasReleased()) cur_screen = SCREEN_MAIN;
            break;
        case SCREEN_FILTER :
            if (filter_dirty && btnAlert.hasReleased()) cur_screen = SCREEN_CHANGEFILTER;
            if (btnHidden.hasReleased()) cur_screen = SCREEN_CONFIRMFILTER;

            if (menu.hasReleased()) cur_screen = SCREEN_MENU;
            if (cancel.hasReleased()) cur_screen = SCREEN_MAIN;
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
    print("starting shutdown...");
    dimming = level;
    if (os.equals("Linux")) {
        GPIO.digitalWrite(pinESP, GPIO.LOW);
        Command cmd = new Command("sleep 5;shutdown now");
        if (cmd.run() == true) {
            String[] output = cmd.getOutput();
            println(output);
        }
    }
    println("complete!");
}
