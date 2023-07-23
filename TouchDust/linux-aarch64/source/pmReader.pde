import deadpixel.command.*;

int pm_inValue = 0;
int pm_outValue = 0;
static final int filter_lifetime_max = 259200;
boolean esp_dirty = false;
boolean filter_dirty = false;
int decrease_step = 1;

void readPMvalue() {
    String pythonPath = sketchPath("/home/pi/Dust_IO/TouchDust/pmsRead.py");
    Command cmd = new Command("python3 " + pythonPath); 
    if (cmd.run() == true) {
        // peachy
        String[] output = cmd.getOutput();
        println(output);
        String[] value = output[0].split(" ");
        if (!value[0].equals("-1")) pm_inValue = int(value[0]);
        if (!value[1].equals("-1")) pm_outValue = int(value[1]);
    }
}

boolean isESPdirty() {
    if (pm_inValue > 20) {
        int diff = (pm_inValue - pm_outValue);
        int percent = (diff * 100) / pm_inValue;
        if (percent < 30) {
            esp_dirty = true;
        }else{
            esp_dirty = false;
        }
    }
    println("ESPdirty:", esp_dirty);
    return esp_dirty;
}

int getFilterPercent() {
    // load data from properties file
    properties = loadJSONObject("data/properties.json");
    int filter_lifetime = properties.getInt("filter_lifetime");
    int result = (filter_lifetime * 100) / filter_lifetime_max;
    if (result == 0) filter_dirty = true;
    return result;
}

void decreaseFilterLife() {
    int filter_lifetime = properties.getInt("filter_lifetime");
    if (filter_lifetime > 0) {
        filter_lifetime -= decrease_step;
        properties.setInt("filter_lifetime", filter_lifetime);
        saveJSONObject(properties, "data/properties.json");
    }
}

void resetFilter() {
    properties.setInt("filter_lifetime", filter_lifetime_max);
    saveJSONObject(properties, "data/properties.json");
}
