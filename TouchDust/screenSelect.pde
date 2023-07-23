Button btnMode, btnTimer;

void select_setBtn() {
    btnMode = new Button(width / 2 - 280, height / 2, 300, 300, 1, 0, "btn/btn_mode.jpg");
    btnTimer = new Button(width / 2 + 280, height / 2, 300, 300, 1, 0, "btn/btn_timer.jpg");
}

void screen_select() {
    background(255);
    btnMode.display();
    btnTimer.display();
}  
