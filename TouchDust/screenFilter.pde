Button btnHidden;

void filter_setBtn() {
    btnHidden = new Button(100, 50, 200, 100, 30, color(128));
    // btnHidden.weight = 5;
}

void screen_filter() {
    background(255);
    image(icon_filter, width * 0.29, height * 0.5, 200, 200);
    fill(89);
    textFont(font_bold);
    textSize(25);
    text("Filter", width * 0.28, height * 0.61);

    fill(filter_percent_color);
    textAlign(RIGHT, CENTER);
    textSize(150);
    text(getFilterPercent() + " %", width * 0.7, height * 0.48);
    textAlign(CENTER, CENTER);
    if (filter_dirty) {
        btnAlert.setPosition(int(width * 0.8), int(height * 0.52));
        btnAlert.display();
    }
    btnHidden.display();
}  
