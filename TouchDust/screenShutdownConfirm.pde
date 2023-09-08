Button btnShutYes, btnShutNo;

void confirmShutdown_setBtn() {
    btnShutYes = new Button(width / 2 - 130, int(height * 0.65), 150, 50, 30, color(17, 181, 92));
    btnShutYes.text = "YES";
    btnShutYes.weight = 5;
    btnShutNo = new Button(width / 2 + 130, int(height * 0.65), 150, 50, 30, color(122));
    btnShutNo.text = "NO";
    btnShutNo.weight = 5;
}

static final String label_confirmshutdown = "Do you really want to “shut down”?";
static final String label_confirmshutdown_th = "คุณต้องการ \"ปิดเครื่อง\" จริงหรือไม่?";

void screen_confirmshutdown() {
    background(255);
    fill(100);
    textFont(font_regu);
    textSize(60);
    text(label_confirmshutdown, width / 2, height * 0.4);
    textFont(font_thai);
    text(label_confirmshutdown_th, width / 2, height * 0.5);
    btnShutYes.display();
    btnShutNo.display();
}
