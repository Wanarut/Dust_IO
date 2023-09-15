Button btnMode, btnTimer, btnFilter;

void select_setBtn() {
    btnMode = new Button(int(width * 0.2), int(height * 0.4), 400, 400, 1, 0, "btn/btn_mode.jpg");
    btnTimer = new Button(int(width * 0.5), int(height * 0.4), 400, 400, 1, 0, "btn/btn_timer.jpg");
    btnFilter = new Button(int(width * 0.8), int(height * 0.4), 400, 300, 1, 0, "btn/btn_filter.png");
}

void screen_select() {
    background(255);
    btnMode.display();
    btnTimer.display();
    btnFilter.display();
    fill(89);
    textFont(font_bold);
    textSize(40);
    text("Mode", width * 0.2, height * 0.6);
    text("Timer", width * 0.5, height * 0.6);
    text("Filter", width * 0.78, height * 0.6);
}  
