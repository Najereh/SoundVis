class Model {

  JSONObject config;
  JSONObject media;
  JSONObject timecodes;
  JSONObject sensors;

  color[] colors;
  boolean isFullScreen;
  //Data from sensors
  Table   table;

  int timeCodes[];

  int currentIndex = 0;

  Model() {

    config = loadJSONObject("config.json");

    JSONObject setup = config.getJSONObject("setup");

    isFullScreen = setup.getBoolean("fullscreen");

    int mediaIndex = setup.getInt("media");
    media = config.getJSONArray("media").getJSONObject(mediaIndex);

    int sensorIndex = setup.getInt("sensors");
    sensors = config.getJSONArray("sensors").getJSONObject(sensorIndex);

    int timecodeIndex = setup.getInt("timecodes");
    timecodes = config.getJSONArray("timecodes").getJSONObject(timecodeIndex);

    //SENSORDATA
    int dataIndex = setup.getInt("data");
    JSONObject data = config.getJSONArray("data").getJSONObject(dataIndex);
    String src = data.getString("src");
    table = loadTable(src, "header");

    setupTable();

    setupColors();
  }

  void setupColors() {

    JSONArray colors = sensors.getJSONArray("colors");
    this.colors = new color[colors.size()];
    for (int i = 0; i < colors.size(); i ++) {
      String c = colors.getString(i);
      c = c.substring(1);
      color col = unhex(c);
      this.colors[i] = col;
    }
  }

  void setupTable() {

    int start = getTimecodeStart();
    int end = getTimecodeEnd();
    println("===SETUP TIMECODES===");
    println("total num : " + table.getRowCount());

    //remove all rows before start
    int timecode = table.getInt(0, 1);
    while (timecode != start) {
      table.removeRow(0);
      timecode = table.getInt(0, 0);
    }

    //remove all rows after end
    timecode = table.getInt(table.getRowCount() -1, 0);
    while (timecode != end) {
      table.removeRow(table.getRowCount() - 1);
      timecode = table.getInt(table.getRowCount() -1, 0);
    }

    //add timecodes to array
    int duration = table.getRowCount() - 1;
    timeCodes = new int[duration];
    int count = 0;
    for (TableRow row : table.rows()) {
      if (count > 0) {
        timeCodes[count - 1] = row.getInt(0);
      }
      count ++;
    }

    String hours =  "0" + str(duration / 3600);
    duration = duration - (duration / 3600)*3600;
    hours = hours.substring(hours.length() - 2);
    String minutes = "0" + str(duration/60);
    minutes = minutes.substring(minutes.length() - 2);
    println("FINAL :: " + hours + ":" + minutes);
  }

  color getColorByIndex(int id){
    int index = floor(colors.length * (float)id / NUM_PERSONS);
    println(index, id, max);
    return colors[index];
  }
  
  
  float[] getValuesByPerson(int id) {
    int numRows = getNumRows();
    float[] values = new float[numRows - 1];
    int count = 0;
    for (TableRow row : table.rows()) {
      if (count > 0) {
        float value = row.getFloat(id + 1)/ MAX_VALUE;
        values[count - 1] = value;
      }

      count ++;
    }

    return values;
  }

  float[] getAverageValues() {
    int numRows = getNumRows();
    float a[] = new float[numRows];

    //assign values
    int count =0;
    float averageCount = 0;
    for (TableRow row : table.rows()) {
      int valueCounter = 0;
      for (int i = 0; i < NUM_PERSONS; i ++) {
        float value = row.getFloat(i + 1) / MAX_VALUE;
        //only add if value valid
        if (value > 0) {
          averageCount = averageCount+value;
          valueCounter++;
        }
      }

      averageCount = averageCount/valueCounter;
      a[count] = averageCount;
      // println(averageCount);

      //increase count
      count ++;
    }

    return a;
  }

  boolean setCurrentIndex(int value) {
    if (value >= 0 && value < timeCodes.length) {
      if (currentIndex != value) {
        currentIndex = value;
        return true;
      }
    }
    return false;
  }

  int getCurrentIndex() {
    return currentIndex;
  }

  boolean getIsFullScreen() {
    return isFullScreen;
  }

  int getNumRows() {
    return table.getRowCount();
  }

  int getCurrentTimecode() {
    return timeCodes[currentIndex];
  }

  int getTimecodeStart() {
    return timecodes.getInt("start");
  }

  int getTimecodeEnd() {
    return timecodes.getInt("end");
  }

  String getMediaVideoSource () {
    return media.getString("videoSrc");
  }

  String getMediaAudioSource () {
    return media.getString("audioSrc");
  }


  String getMediaType () {
    return media.getString("type");
  }
}