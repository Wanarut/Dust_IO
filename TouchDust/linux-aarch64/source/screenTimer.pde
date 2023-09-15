Button add, del, set, clear;
// countdown time in second (max 2,147,483,647 sec = ~68 years)
int time_min;
boolean start_count = false;
// increase countdown time by 15 min per step
static final int time_step = 900;
PImage sleep_timer_img;

static final String lead_zero_format = "%02d";
static final String colon = ":";
static final String time_label = "  HOURS                   MINUTES";
static final String label_timer = "Timer";

String timer_hour = "00";
String timer_min = "00";

void timer_setBtn() {
    time_min = 0;
    // sleep timer logo
    sleep_timer_img = loadImage("logo/icon_sleep.jpg");
    // timer increase & decrease btn
    add = new Button(width / 2 + 350, int(height * 0.45), 120, 120, 1, 0, "btn/plus.png");
    del = new Button(width / 2 - 350, int(height * 0.45), 120, 120, 1, 0, "btn/min.png");
    // set timer & clear btn
    set = new Button(width / 2 - 200, int(height * 0.7), 280, 100, 60, color(0, 173, 73));
    set.text = "SET";
    set.weight = 10;
    clear = new Button(width / 2 + 200, int(height * 0.7), 280, 100, 60, color(122, 122, 122));
    clear.text = "CLEAR";
    clear.weight = 10;
}

void screen_timer() {
    background(255);
    // display logo
    image(sleep_timer_img, int(width * 0.93), int(height * 0.12), 120, 120);
    fill(89);
    textFont(font_bold);
    textSize(30);
    text(label_timer, int(width * 0.87), int(height * 0.12));
    // display btns
    add.display();
    del.display();
    set.display();
    clear.display();
    // digit lead with zero
    timer_hour = String.format(lead_zero_format, time_min / 3600);
    timer_min = String.format(lead_zero_format, (time_min / 60) % 60);
    // display time
    fill(55, 179, 73);
    textFont(font_bold);
    textSize(180);
    text(timer_hour, width / 2 - 138, int(height * 0.4));
    text(colon, width / 2, int(height * 0.385));
    text(timer_min, width / 2 + 138, int(height * 0.4));
    // display labels
    fill(157);
    textFont(font_regu);
    textSize(30);
    text(time_label, width / 2, int(height * 0.52));
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
