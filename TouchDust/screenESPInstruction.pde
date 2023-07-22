PImage instuction2;

void cleanESP_setBtn() {
    instuction2 = loadImage("logo/esp.png");
}

void screen_cleanESP() {
    background(255);
    image(instuction2, width / 2, height / 2 + 50, 500, 400);
    fill(62, 109, 194);
    textFont(font_regu);
    textSize(50);
    text("Please clean the ESP", width / 2, height * 0.1);
    textFont(font_thai);
    text("กรุณาทำความสะอาดชุด ESP", width / 2, height * 0.18);
}
