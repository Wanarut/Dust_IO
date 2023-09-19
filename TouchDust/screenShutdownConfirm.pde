Button btnShutYes, btnShutNo;

void confirmShutdown_setBtn() {
    btnShutYes = new Button(width / 2 - 200, int(height * 0.7), 280, 100, 60, color(17, 181, 92));
    btnShutYes.text = "YES";
    btnShutYes.weight = 10;
    btnShutNo = new Button(width / 2 + 200, int(height * 0.7), 280, 100, 60, color(122));
    btnShutNo.text = "NO";
    btnShutNo.weight = 10;
}

static final String label_confirmshutdown = "Do you really want to “shut down”?";
static final String label_confirmshutdown_th = "คุณต้องการ \"ปิดเครื่อง\" จริงหรือไม่?";
static final String label_contact_th = "ติดต่อเจ้าหน้าที่สำหรับรับบริการ : ฝ่ายลูกค้าสัมพันธ์ 086 688 3698 หรือ 02 178 2222";

void screen_confirmshutdown() {
    background(255);
    fill(68, 114, 196);
    textFont(font_regu);
    textSize(80);
    text(label_confirmshutdown, width / 2, height * 0.4);
    textFont(font_thai);
    text(label_confirmshutdown_th, width / 2, height * 0.5);
    textAlign(RIGHT);
    text(label_contact_th, width * 0.98, height * 0.97);
    textAlign(CENTER, CENTER);
    btnShutYes.display();
    btnShutNo.display();
}
