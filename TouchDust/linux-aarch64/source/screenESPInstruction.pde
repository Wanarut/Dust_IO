PImage instuction2;

void cleanESP_setBtn() {
    instuction2 = loadImage("logo/esp.png");
}

static final String label_cleanESP = "Please clean the ESP";
static final String label_cleanESP_th = "กรุณาทำความสะอาดชุด ESP";

void screen_cleanESP() {
    background(255);
    // image(instuction2, width / 2, height / 2 + 50, 500, 400);
    fill(62, 109, 194);
    textFont(font_regu);
    // textSize(50);
    // text(label_cleanESP, width / 2, height * 0.1);
    textSize(100);
    text(label_cleanESP, width / 2, height * 0.4);
    textFont(font_thai);
    // text(label_cleanESP_th, width / 2, height * 0.18);
    text(label_cleanESP_th, width / 2, height * 0.5);
    textAlign(RIGHT);
    text(label_contact_th, width * 0.98, height * 0.97);
    textAlign(CENTER, CENTER);
}
