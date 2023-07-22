PImage[] emoji = new PImage[5];
int gif_i = 0;

String text_mode = "AUTO";
String text_mode_post = "Hi";
color text_mode_color = color(255, 0, 0);
String text_level = "0";

PImage icon_mode, icon_filter, icon_fan;
Button btnShutdown;

void setupmain() {
    for (int i = 0; i < emoji.length; i++) {
        emoji[i] = loadImage("Emoji/emoji_lvl_" + str(i + 1) + ".jpg");
    }
    icon_mode = loadImage("logo/icon_mode.jpg");
    icon_filter = loadImage("logo/icon_filter.jpg");
    icon_fan = loadImage("logo/icon_fan.jpg");
    
    btnShutdown = new Button(int(width - 75), int(height - 75), 100, 100, 1, 0, "btn/icon_power.jpg");
}

void main_screen() {
    background(255);
    
    if (esp_dirty) {
        // image(emoji_5, width / 2, height * 0.4, 580, 435);
        // fill(255);
        // textSize(40); 
        // text("PLEASE\nCLEAN UP", width / 2, height * 0.4);
    } else if (filter_dirty) {
        // image(emoji_5, width / 2, height * 0.4, 580, 435);
        // fill(255);
        // textSize(40); 
        // text("PLEASE\nCLEAN UP", width / 2, height * 0.4);
    } else {
        select_emoji();
        image(emoji[gif_i], width / 2, height * 0.3, 300, 300);
    }
    
    fill(128);
    textFont(font_bold);
    textSize(60);
    text("   PM                μg/m\u00B3", width / 2, height * 0.62);
    textSize(30);
    text("2.5", width / 2 - 120, height * 0.66);
    fill(0);
    textSize(90);
    textAlign(RIGHT, CENTER);
    text(pm_inValue, width / 2 + 70, height * 0.6);
    textAlign(CENTER, CENTER);
    
    fill(128);
    textFont(font_regu);
    textSize(18);
    text("MODE : " + text_mode, width * 0.32, height * 0.85);
    
    textAlign(LEFT, CENTER);
    fill(text_mode_color);
    text(text_mode_post, width * 0.38, height * 0.85);
    textAlign(CENTER, CENTER);
    
    fill(128);
    text("Filter : " + filter_lifetime + " %", width / 2, height * 0.85);
    text("FAN LEVEL : " + text_level, width * 0.65, height * 0.85);
    
    image(icon_mode, width * 0.33, height * 0.77, 50, 50);
    image(icon_filter, width / 2, height * 0.77, 50, 50);
    image(icon_fan, width * 0.65, height * 0.77, 50, 50);
    
    btnShutdown.display();
}

void select_emoji() {
    gif_i = 0;
    if (pm_inValue > 12) {
        gif_i = 1;
    }
    if (pm_inValue > 35) {
        gif_i = 2;
    }
    if (pm_inValue > 55) {
        gif_i = 3;
    }
    if (pm_inValue > 250) {
        gif_i = 4;
    }
}
