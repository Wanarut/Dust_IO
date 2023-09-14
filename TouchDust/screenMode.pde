Button btnFanPow, btnAutoHi, btnAutoEco;
PImage[] fanPowerImgs = new PImage[5];
int fan_index = 0;
// working mode
static final int MODE_HIGH = 1;
static final int MODE_AUTO = 2;
static final int MODE_MANUAL = 3;
int cur_mode = MODE_AUTO;

void mode_setBtn() {
    btnFanPow = new Button(width / 2, int(height * 0.25), 400, 400, 1, 0, "btn/fan_1.jpg");
    btnAutoEco = new Button(int(width * 0.25), int(height * 0.6), 250, 250, 1, 0, "btn/mode_eco.jpg");
    btnAutoHi = new Button(int(width * 0.75), int(height * 0.6), 250, 250, 1, 0, "btn/mode_high.jpg");
    
    for (int i = 0; i < fanPowerImgs.length; i++) {
        fanPowerImgs[i] = loadImage("btn/fan_" + str(i) + ".jpg");
    }
}

static final String STRING_AUTO = "Auto";
static final String STRING_HIGH = "Hi";
static final String STRING_MANUAL = "Manual";

void screen_mode() {
    background(255);
    
    btnFanPow.display();
    btnAutoHi.display();
    btnAutoEco.display();
    
    textFont(font_bold);
    textSize(40);
    if (cur_mode == MODE_MANUAL) fill(0, 176, 80);
    else fill(128);
    text(STRING_MANUAL, width * 0.54, height * 0.34);
    if (cur_mode == MODE_AUTO) fill(0, 176, 80);
    else fill(128);
    text(STRING_AUTO, int(width * 0.25), int(height * 0.73));
    if (cur_mode == MODE_HIGH) fill(0, 176, 80);
    else fill(128);
    text(STRING_HIGH, int(width * 0.76), int(height * 0.73));
}

void controller() {
    if (btnAutoHi.hasReleased()) {
        cur_mode = MODE_HIGH;
        println("Eco Mode: ESP On");
        text_mode = "Hi";
        text_mode_post = "Hi";
        text_mode_color = color(255, 0, 0);
    }
    if (btnAutoEco.hasReleased()) {
        cur_mode = MODE_AUTO;
        println("Eco Mode: ESP Off");
        text_mode = "AUTO";
        text_mode_post = "Eco";
        text_mode_color = color(0, 176, 80);
    }
    if (btnFanPow.hasReleased()) {
        cur_mode = MODE_MANUAL;
        println("Manual Mode");
        text_mode = "MANUAL";
        text_mode_post = "";
        text_mode_color = color(128);

        dimming -= 2;
        if (dimming < 1) dimming = level;
    }
    adaptiveFan();
    println(text_mode, text_mode_post, "Fan Level:", str(fan_index));
}


void adaptiveFan() {
    switch(cur_mode) {
        case MODE_HIGH :
            if (pm_inValue <= 3) {
                dimming = level;
            }
            if (pm_inValue > 3 && pm_inValue < 9) {
                dimming = 5;
            }
            if (pm_inValue > 12) {
                dimming = 1;
            }
            break;
        case MODE_AUTO :
            if (pm_inValue <= 3) {
                dimming = level;
            }
            if (pm_inValue > 3 && pm_inValue < 9) {
                dimming = 7;
            }
            if (pm_inValue > 12 && pm_inValue < 35) {
                dimming = 5;
            }
            if (pm_inValue > 38 && pm_inValue < 55) {
                dimming = 3;
            }
            if (pm_inValue > 58) {
                dimming = 1;
            }
            break;
        default :
            break;
    }
    // case fan is turn off
    if (dimming == level) {
        if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
    } else {
        if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
    }
    fan_index = (level - dimming) / 2;
    btnFanPow.setImage(fanPowerImgs[fan_index]);
}