import deadpixel.command.*;

int pm_inValue = 0;
int pm_outValue = 0;
int filter_lifetime = 100;
boolean dirty = false;

void readPMvalue() {
  String pythonPath = sketchPath("/home/pi/Dust_IO/TouchDust/pmsRead.py");
  Command cmd = new Command("python3 " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput();
    println(output);
    String[] value = output[0].split(" ");
    if (!value[0].equals("-1")) pm_inValue = int(value[0]);
    if (!value[1].equals("-1")) pm_outValue = int(value[1]);
  }
}

void shutdown_now() {
  if(os.equals("Linux")) dimming = 9;
  if(os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
  Command cmd = new Command("shutdown now");
  if ( cmd.run() == true ) {
    String[] output = cmd.getOutput();
    println(output);
  }
}
