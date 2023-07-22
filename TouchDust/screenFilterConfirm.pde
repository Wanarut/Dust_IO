Button btnYes, btnNo;

void confirmfilter_setBtn() {
    btnYes = new Button(width / 2 - 130, int(height * 0.65), 150, 50, 30, color(17, 181, 92));
    btnYes.text = "YES";
    btnYes.weight = 5;
    btnNo = new Button(width / 2 + 130, int(height * 0.65), 150, 50, 30, color(122));
    btnNo.text = "NO";
    btnNo.weight = 5;
}

void screen_confirmfilter() {
    background(255);
    fill(100);
    textSize(50);
    text("Have you changed the air filter?", width / 2, height * 0.4);
    textFont(font_thai);
    text("คุณเปลี่ยนไส้กรองอากาศแล้วใช่หรือไม่", width / 2, height * 0.48);
    btnYes.display();
    btnNo.display();
}  
