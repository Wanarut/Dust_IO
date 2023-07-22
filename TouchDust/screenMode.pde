Button btnFanPow, btnAutoHi, btnAutoEco;
PImage[] fanPowerImgs = new PImage[5];
int fan_index = 0;

void mode_setBtn() {
    btnFanPow = new Button(width / 2 - 220, int(height / 2.5), 300, 300, 1, 0, "btn/fan_0.jpg");
    btnAutoEco = new Button(width / 2 + 220, height / 4, 200, 200, 1, 0, "btn/mode_eco.jpg");
    btnAutoHi = new Button(width / 2 + 220, int(1.8 * height) / 3, 200, 200, 1, 0, "btn/mode_high.jpg");

    for (int i = 0; i < fanPowerImgs.length; i++) {
      fanPowerImgs[i] = loadImage("btn/fan_" + str(i) + ".jpg");
    }
}

void screen_mode() {
    background(255);
    
    fan_index = (level - dimming) / 2;
    text_level = str(fan_index);
    btnFanPow.setImage(fanPowerImgs[fan_index]);
    btnFanPow.display();
    btnAutoHi.display();
    btnAutoEco.display();
    
    fill(128);
    textFont(font_bold);
    textSize(40);
    text("ECO", width / 2 + 220, height / 4 + 90);
    text("High Air Quality", width / 2 + 220, int(2.3 * height) / 3);
}

void controller() {
    if (btnAutoHi.hasReleased()) {
      println("Eco Mode: ESP On");
        text_mode = "AUTO";
        text_mode_post = "Hi";
        text_mode_color = color(255, 0, 0);
        // read pm value
        if (pm_inValue > 3 && pm_inValue < 9) {
            dimming = 7;
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
        }
        if (pm_inValue > 12) {
            dimming = 1;
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
        }
    }
    if (btnAutoEco.hasReleased()) {
        println("Eco Mode: ESP Off");
        text_mode = "AUTO";
        text_mode_post = "Eco";
        text_mode_color = color(0, 176, 80);
        // read pm value
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
    }
    if (btnFanPow.hasReleased()) {
        dimming -= 2;
        if (dimming < 1) dimming = 7;

        text_mode = "MANUAL";
        text_mode_post = "";
    }
    fan_index = (level - dimming) / 2;
    text_level = str(fan_index);
    println(text_mode, text_mode_post, "Fan Level:", text_level);
}
