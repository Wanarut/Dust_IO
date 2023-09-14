PImage[] emoji = new PImage[5];
int gif_i = 0;
// fan state
String text_mode = "AUTO";
String text_mode_post = "Eco";
color text_mode_color = color(0, 176, 80);
color text_pm_color = color(0, 176, 80);
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
    
    btnShutdown = new Button(int(width * 0.94), int(height * 0.9), 100, 100, 1, 0, "btn/icon_power.jpg");
    btnAlert = new Button(int(width * 0.94), int(height * 0.75), 100, 100, 1, 0, "btn/alert.png");
}

static final String label_pm = "PM                                   μg/m\u00B3";
static final String label_25 = "2.5";
static final String label_mode = "MODE : ";
static final String label_filter = "Filter : ";
static final String label_fan = "FAN LEVEL : ";

void main_screen() {
    background(255);
    // display emoji
    select_emoji();
    image(emoji[gif_i], width / 2, height * 0.35, height * 0.7, height * 0.7);
    // display pm value
    fill(128);
    textFont(font_bold);
    textSize(35);
    text(label_pm, width / 2, height * 0.78);
    textSize(20);
    text(label_25, width * 0.404, height * 0.795);
    textSize(110);
    textAlign(RIGHT, CENTER);
    int pos_x = int(width * 0.542);
    int pos_y = int(height * 0.745);
    fill(0);
    // stroke pm value
    for(int x = -1; x < 2; x++){
        text(pm_inValue, pos_x + x, pos_y);
        text(pm_inValue, pos_x, pos_y + x);
    }
    fill(text_pm_color);
    text(pm_inValue, pos_x, pos_y);

    textAlign(CENTER, CENTER);
    // display mode
    fill(128);
    textFont(font_regu);
    textSize(24);
    text(label_mode, width * 0.32, height * 0.931);
    textAlign(LEFT, CENTER);
    fill(text_mode_color);
    text(text_mode, width * 0.355, height * 0.931);
    textAlign(CENTER, CENTER);
    // display filter lifetime
    fill(128);
    text(label_filter, width / 2 - 24, height * 0.931);
    fill(filter_percent_color);
    textAlign(RIGHT, CENTER);
    text(getFilterPercent() + " %", width / 2 + 75, height * 0.931);
    textAlign(CENTER, CENTER);
    // display fan speed
    fill(128);
    text(label_fan + str(fan_index), width * 0.65, height * 0.931);
    // display icon
    image(icon_mode, width * 0.33, height * 0.89, 50, 50);
    image(icon_filter, width / 2, height * 0.89, 50, 50);
    image(icon_fan, width * 0.65, height * 0.89, 50, 50);
    // display button
    btnShutdown.display();
    if (filter_dirty || show_all_element) {
        btnAlert.setPosition(int(width * 0.94), int(height * 0.75));
        btnAlert.display();
    }

    if (start_count || show_all_element) {
        // display logo
        image(sleep_timer_img, int(width * 0.93), int(height * 0.12), 120, 120);
        fill(89);
        textFont(font_bold);
        textSize(20);
        text(label_timer, int(width * 0.93), int(height * 0.17));
        // digit lead with zero
        timer_hour = String.format(lead_zero_format, time_min / 3600);
        timer_min = String.format(lead_zero_format, (time_min / 60) % 60);
        // display time
        fill(55, 179, 73);
        textFont(font_bold);
        textSize(30);
        text(timer_hour, width * 0.86, int(height * 0.12));
        text(colon, width * 0.875, int(height * 0.12));
        text(timer_min, width * 0.89, int(height * 0.12));
    }
}

void select_emoji() {
    gif_i = 0;
    text_pm_color = color(0, 176, 80);
    if (pm_inValue > 12) {
        gif_i = 1;
        text_pm_color = color(255, 192, 0);
    }
    if (pm_inValue > 35) {
        gif_i = 2;
        text_pm_color = color(237, 125, 49);
    }
    if (pm_inValue > 55) {
        gif_i = 3;
        text_pm_color = color(255, 0, 0);
    }
    if (pm_inValue > 150) {
        text_pm_color = color(112, 48, 160);
    }
    if (pm_inValue > 250) {
        gif_i = 4;
        text_pm_color = color(165, 0, 33);
    }
}
