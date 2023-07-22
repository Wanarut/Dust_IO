Button add, del, set, clear;
int time_min;
boolean start_count = false;
static final int time_step = 900;
PImage sleep_timer_img;

static final String lead_zero_format = "%02d";
static final String colon = ":";
static final String time_label = "  HOURS                   MINUTES";

void timer_setBtn() {
    time_min = 0;
    // sleep timer logo
    sleep_timer_img = loadImage("logo/icon_sleep.jpg");
    // timmer increase & decrease btn
    add = new Button(width / 2 + 300, int(height * 0.4), 100, 100, 1, 0, "btn/plus.png");
    del = new Button(width / 2 - 300, int(height * 0.4), 100, 100, 1, 0, "btn/min.png");
    // set timmer & clear btn
    set = new Button(width / 2 - 130, int(height * 0.65), 150, 50, 30, color(0, 173, 73));
    set.text = "SET";
    set.weight = 5;
    clear = new Button(width / 2 + 130, int(height * 0.65), 150, 50, 30, color(122, 122, 122));
    clear.text = "CLEAR";
    clear.weight = 5;
}

void screen_timer() {
    background(255);
    // display logo
    image(sleep_timer_img, int(width * 0.9), int(height * 0.15), 152, 120);
    // display btns
    add.display();
    del.display();
    set.display();
    clear.display();
    // digit lead with zero
    String hour = String.format(lead_zero_format, time_min / 3600);
    String min = String.format(lead_zero_format, (time_min / 60) % 60);
    // display time
    fill(55, 179, 73);
    textFont(font_bold);
    text(hour, width / 2 - 128, int(height * 0.35));
    text(colon, width / 2, int(height * 0.35));
    text(min, width / 2 + 128, int(height * 0.35));
    // display labels
    fill(157);
    textFont(font_regu);
    textSize(30);
    text(time_label, width / 2, int(height * 0.47));
}

void calculatetime() {
    if (add.hasReleased()) {
        time_min += time_step;
    }
    if (del.hasReleased()) {
        time_min -= time_step;
        if (time_min < 0) time_min = 0;
    }
    if (set.hasReleased()) {
        start_count = true;
        counter_prev_mil = millis();
    }
    if (clear.hasReleased()) {
        start_count = false;
        time_min = 0;
    }
}
