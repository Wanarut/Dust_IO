Button btnHidden;
PImage filter_img;

void filter_setBtn() {
    filter_img = loadImage("btn/btn_filter.png");
    btnHidden = new Button(100, 50, 200, 100, 30, color(128));
    if (show_all_element) btnHidden.weight = 5;
}

void screen_filter() {
    background(255);
    image(filter_img, width * 0.23, height * 0.4, 400, 300);
    fill(89);
    textFont(font_bold);
    textSize(40);
    text("Filter", width * 0.2, height * 0.6);

    fill(filter_percent_color);
    textAlign(RIGHT, CENTER);
    textSize(200);
    text(getFilterPercent() + " %", width * 0.72, height * 0.41);
    textAlign(CENTER, CENTER);

    if (filter_dirty || show_all_element) {
        btnAlert.setPosition(int(width * 0.83), int(height * 0.45));
        btnAlert.display();
    }
    btnHidden.display();
}  
