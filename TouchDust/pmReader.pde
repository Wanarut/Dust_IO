import deadpixel.command.*;

int pm_inValue = 300;
int pm_outValue = 0;
int filter_lifetime = 100;
boolean dirty = false;

void readPMvalue() {
  String pythonPath = sketchPath("pmsRead.py");
  Command cmd = new Command("python3 " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    String[] value = output[0].split(" ");
    pm_inValue = int(value[0]);
    pm_outValue = int(value[1]);
  }
}
