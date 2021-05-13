import deadpixel.command.*;

int pm_inValue = 21;
int pm_outValue = 21;
int filter_lifetime = 100;
boolean dirty = false;

void readPMvalue() {
  String pythonPath = sketchPath("pmsRead.py");
  Command cmd = new Command("python3 " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    String[] value = output[0].split(" ");
    if (value[0] != '-1') pm_inValue = int(value[0]);
    if (value[1] != '-1') pm_outValue = int(value[1]);
  }
}
