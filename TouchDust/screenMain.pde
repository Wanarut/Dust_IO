PImage[] emoji = new PImage[5];
int gif_i = 0;
// fan state
String text_mode = "AUTO";
String text_mode_post = "Eco";
color text_mode_color = color(0, 176, 80);
// icon
PImage icon_mode, icon_filter, icon_fan;
Button btnShutdown, btnAlert;

void setupmain() {
    for (int i = 0; i < emoji.length; i++) {
        emoji[i] = loadImage("Emoji/emoji_lvl_" + str(i + 1) + ".jpg");
    }
    icon_mode = loadImage("logo/icon_mode.jpg");
    icon_filter = loadImage("logo/icon_filter.jpg");
    icon_fan = loadImage("logo/icon_fan.jpg");
    
    btnShutdown = new Button(int(width - 75), int(height - 75), 100, 100, 1, 0, "btn/icon_power.jpg");
    btnAlert = new Button(int(width - 75), int(height - 200), 100, 100, 1, 0, "btn/alert.png");
}

static final String label_pm = "  PM                μg/m\u00B3";
static final String label_25 = "2.5";
static final String label_mode = "MODE : ";
static final String label_filter = "Filter : ";
static final String label_fan = "FAN LEVEL : ";

void main_screen() {
    background(255);
    // display emoji
    select_emoji();
    image(emoji[gif_i], width / 2, height * 0.3, 400, 400);
    // display pm value
    fill(128);
    textFont(font_bold);
    textSize(60);
    text(label_pm, width / 2, height * 0.64);
    textSize(30);
    text(label_25, width / 2 - 120, height * 0.67);
    fill(0);
    textSize(90);
    textAlign(RIGHT, CENTER);
    text(pm_inValue, width / 2 + 70, height * 0.62);
    textAlign(CENTER, CENTER);
    // display mode
    fill(128);
    textFont(font_regu);
    textSize(24);
    text(label_mode + text_mode, width * 0.32, height * 0.83);
    textAlign(LEFT, CENTER);
    fill(text_mode_color);
    text(text_mode_post, width * 0.38, height * 0.83);
    textAlign(CENTER, CENTER);
    // display filter lifetime
    fill(128);
    text(label_filter, width / 2 - 24, height * 0.83);
    if (getFilterPercent() <= 10) fill(255, 0, 0);
    textAlign(RIGHT, CENTER);
    text(getFilterPercent() + " %", width / 2 + 75, height * 0.83);
    textAlign(CENTER, CENTER);
    // display fan speed
    fill(128);
    text(label_fan + str(fan_index), width * 0.65, height * 0.83);
    // debug filtered pm value
    fill(0);
    text("S2 = " + str(pm_outValue), width * 0.1, height * 0.9);
    // display icon
    image(icon_mode, width * 0.33, height * 0.77, 50, 50);
    image(icon_filter, width / 2, height * 0.77, 50, 50);
    image(icon_fan, width * 0.65, height * 0.77, 50, 50);
    // display button
    btnShutdown.display();
    if (filter_dirty) btnAlert.display();
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
