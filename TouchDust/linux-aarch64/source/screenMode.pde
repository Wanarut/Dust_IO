Button btnFanPow, btnAutoHi, btnAutoEco;
PImage[] fanPowerImgs = new PImage[5];
int fan_index = 0;
// working mode
static final int mode_high = 1;
static final int mode_eco = 2;
static final int mode_man = 3;
int cur_mode = mode_eco;

void mode_setBtn() {
    btnFanPow = new Button(width / 2 - 280, int(height / 2.3), 400, 400, 1, 0, "btn/fan_0.jpg");
    btnAutoEco = new Button(width / 2 + 280, height / 4, 250, 250, 1, 0, "btn/mode_eco.jpg");
    btnAutoHi = new Button(width / 2 + 280, int(1.8 * height) / 3, 250, 250, 1, 0, "btn/mode_high.jpg");
    
    for (int i = 0; i < fanPowerImgs.length; i++) {
        fanPowerImgs[i] = loadImage("btn/fan_" + str(i) + ".jpg");
    }
}

static final String eco = "ECO";
static final String high = "High Air Quality";

void screen_mode() {
    background(255);
    
    btnFanPow.setImage(fanPowerImgs[fan_index]);
    btnFanPow.display();
    btnAutoHi.display();
    btnAutoEco.display();
    
    fill(128);
    textFont(font_bold);
    textSize(40);
    text(eco, width / 2 + 280, height / 4 + 110);
    text(high, width / 2 + 280, int(2.3 * height) / 3);
}

void controller() {
    if (btnAutoHi.hasReleased()) {
        cur_mode = mode_high;
        println("Eco Mode: ESP On");
        text_mode = "AUTO";
        text_mode_post = "Hi";
        text_mode_color = color(255, 0, 0);
    }
    if (btnAutoEco.hasReleased()) {
        cur_mode = mode_eco;
        println("Eco Mode: ESP Off");
        text_mode = "AUTO";
        text_mode_post = "Eco";
        text_mode_color = color(0, 176, 80);
    }
    if (btnFanPow.hasReleased()) {
        cur_mode = mode_man;
        println("Manual Mode");
        text_mode = "MANUAL";
        text_mode_post = "";

        dimming -= 2;
        if (dimming < 1) dimming = 7;
    }
    adaptiveFan();
    println(text_mode, text_mode_post, "Fan Level:", str(fan_index));
}


void adaptiveFan() {
    switch(cur_mode) {
        case mode_high :
            if (pm_inValue > 3 && pm_inValue < 9) {
                dimming = 7;
            }
            if (pm_inValue > 12) {
                dimming = 1;
            }
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
            break;
        case mode_eco :
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
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
            break;
        default :
            break;
    }
    fan_index = (level - dimming) / 2;
}
