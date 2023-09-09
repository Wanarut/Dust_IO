import deadpixel.command.*;

int pm_inValue = 0;
int pm_outValue = 0;
boolean esp_dirty = false;
boolean filter_dirty = false;

static final int filter_lifetime_max = 259200;
static final int decrease_step = 1;

static final String python_file_pms = "/home/pi/Dust_IO/TouchDust/pmsRead.py";
static final String python_cmd = "python3 ";

color filter_percent_color = color(128);

void readPMvalue() {
    String pythonPath = sketchPath(python_file_pms);
    Command cmd = new Command(python_cmd + pythonPath); 
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
    properties = loadJSONObject(properties_file);
    int filter_lifetime = properties.getInt(lifetime_key);
    int result = (filter_lifetime * 100) / filter_lifetime_max;
    filter_percent_color = color(128);
    if (result <= 20) filter_percent_color = color(237, 125, 49);
    if (result <= 10) filter_percent_color = color(255, 0, 0);
    if (result == 0) filter_dirty = true;
    return result;
}

void decreaseFilterLife() {
    int filter_lifetime = properties.getInt(lifetime_key);
    if (filter_lifetime > 0) {
        filter_lifetime -= decrease_step;
        properties.setInt(lifetime_key, filter_lifetime);
        saveJSONObject(properties, properties_file);
    }
}

void resetFilter() {
    properties.setInt(lifetime_key, filter_lifetime_max);
    saveJSONObject(properties, properties_file);
}