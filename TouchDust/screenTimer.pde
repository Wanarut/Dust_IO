Button add, del, set, clear, menu, cancel;
int time_min;
boolean start_count = false;
int time_step = 900;
PFont font_bold;
PFont font_regu;
PImage sleep_timer_img;

void timer_setBtn() {
    time_min = 0;
    font_bold = createFont("Fira_Sans/FiraSans-Bold.ttf", 100);
    font_regu = createFont("Fira_Sans/FiraSans-Regular.ttf", 100);

    sleep_timer_img = loadImage("logo/icon_sleep.jpg");
    
    add = new Button(width / 2 - 300, int(height * 0.4), 100, 100, 1, 0, "btn/plus.png");
    del = new Button(width / 2 + 300, int(height * 0.4), 100, 100, 1, 0, "btn/min.png");

    set = new Button(width / 2 - 130, int(height * 0.65), 150, 50, 30, color(0, 173, 73));
    set.text = "SET";
    set.weight = 5;
    clear = new Button(width / 2 + 130, int(height * 0.65), 150, 50, 30, color(122, 122, 122));
    clear.text = "CLEAR";
    clear.weight = 5;

    menu = new Button(width / 7, int(height * 0.85), 150, 150, 1, 0, "btn/btn_back.jpg");
    cancel = new Button(width / 2, int(height * 0.85), 100, 100, 1, 0, "btn/logo.jpg");
}

void screen_timer() {
    background(255);

    image(sleep_timer_img, int(width * 0.9), int(height * 0.15), 152, 120);

    add.display();
    del.display();
    set.display();
    clear.display();
    menu.display();
    cancel.display();
    
    String hour = String.format("%02d", time_min / 3600);
    String min = String.format("%02d", (time_min / 60) % 60);

    fill(55, 179, 73);
    textFont(font_bold);
    text(hour, width / 2 - 128, int(height * 0.35));
    text(":", width / 2, int(height * 0.35));
    text(min, width / 2 + 128, int(height * 0.35));

    fill(157);
    textFont(font_regu);
    textSize(30);
    text("  HOURS                   MINUTES", width / 2, int(height * 0.47));
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
    if (menu.hasReleased()) {
        cur_screen = 1;
    }
    if (cancel.hasReleased()) {
        cur_screen = 0;
    }
}
