Button btnHidden;

void filter_setBtn() {
    btnHidden = new Button(100, 50, 200, 100, 30, color(128));
    if (show_all_element) btnHidden.weight = 5;
}

void screen_filter() {
    background(255);
    image(icon_filter, width * 0.25, height * 0.5, 200, 200);
    fill(89);
    textFont(font_bold);
    textSize(25);
    text("Filter", width * 0.24, height * 0.59);

    fill(filter_percent_color);
    textAlign(RIGHT, CENTER);
    textSize(150);
    text(getFilterPercent() + " %", width * 0.6, height * 0.48);
    textAlign(CENTER, CENTER);

    if (filter_dirty || show_all_element) {
        btnAlert.setPosition(int(width * 0.75), int(height * 0.52));
        btnAlert.display();
    }
    btnHidden.display();
}  
