Button btnYes, btnNo;

void confirmfilter_setBtn() {
    btnYes = new Button(width / 2 - 130, int(height * 0.65), 150, 50, 30, color(17, 181, 92));
    btnYes.text = "YES";
    btnYes.weight = 5;
    btnNo = new Button(width / 2 + 130, int(height * 0.65), 150, 50, 30, color(122));
    btnNo.text = "NO";
    btnNo.weight = 5;
}

static final String label_confirmfilter = "Have you changed the air filter?";
static final String label_confirmfilter_th = "คุณเปลี่ยนไส้กรองอากาศแล้วใช่หรือไม่";

void screen_confirmfilter() {
    background(255);
    fill(100);
    textFont(font_regu);
    textSize(60);
    text(label_confirmfilter, width / 2, height * 0.4);
    textFont(font_thai);
    text(label_confirmfilter_th, width / 2, height * 0.5);
    btnYes.display();
    btnNo.display();
    
    // debug filtered pm value
    fill(0);
    textAlign(LEFT, CENTER);
    text("S1 = " + str(pm_inValue), width * 0.1, height * 0.9);
    text("S2 = " + str(pm_outValue), width * 0.1, height * 0.94);
    textAlign(CENTER, CENTER);
}  