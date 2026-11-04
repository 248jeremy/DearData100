// DearData100 Train Passengers
// Each shape is one passenger from the spreadsheet

String[] data = {
  "Standing,Book,None,Floor",
  "Sitting,Makeup,Wireless Earbuds,Lap",
  "Sitting,Phone,Wired Earphones,Floor",
  "Sitting,Gaming,None,Floor",
  "Standing,Listening,Wireless Headphones,Back",
  "Standing,Phone,Wired Earphones,Back",
  "Sitting,Book,None,Lap",
  "Sitting,Makeup,None,Seat",
  "Sitting,Phone,Wireless Headphones,Lap",
  "Sitting,Phone,Wireless Earbuds,Lap",
  "Sitting,Phone,Wired Headphones,Floor",
  "Sitting,Listening,Wireless Earbuds,None",
  "Sitting,Newspaper,None,Floor",
  "Sitting,Listening,Wireless Earphones,Floor",
  "Standing,Listening,Wireless Headphones,Back",
  "Standing,Phone,Wireless Earphones,Shoulder",
  "Standing,Listening,Wireless Earbuds,Shoulder",
  "Standing,None,None,Back",
  "Standing,Phone,None,Shoulder",
  "Standing,Book,None,Shoulder",
  "Standing,Talking,None,Shoulder",
  "Standing,Talking,None,Shoulder",
  "Sitting,Book,None,Floor",
  "Sitting,Listening,Wireless Headphones,Lap",
  "Sitting,Phone,Wireless Earphones,Lap",
  "Sitting,Phone,Wireless Earphones,Lap",
  "Sitting,Phone,Wired Earphones,Floor",
  "Sitting,Talking,Wireless Earphones,Lap",
  "Sitting,Phone,Wireless Headphones,Floor"
};

// the order activities are grouped in (also used for the key)
String[] activities = { "Phone", "Listening", "Book", "Talking", "Makeup", "Gaming", "Newspaper", "None" };

void setup() {
  size(1000, 660);
  rectMode(CENTER);
  noStroke();
  sortData();   // REARRANGE: group passengers by activity
  noLoop();     // the picture is static, so draw it once
}

void draw() {
  background(30);

  int cols = 6;
  int spacing = 100;

  for (int i = 0; i < data.length; i++) {
    String[] p = split(data[i], ',');
    String position = p[0];
    String activity = p[1];
    String audio = p[2];
    String bag = p[3];

    float x = 70 + (i % cols) * spacing;
    float y = 70 + (i / cols) * spacing;

    // MODIFY: the size of the shape depends on the audio device
    float s = audioSize(audio);
    float edge = s / 2 + 7;   // distance from the centre to the edge of the shape

    // shape = standing or sitting, colour = activity
    fill(activityColour(activity));
    if (position.equals("Standing")) {
      ellipse(x, y, s, s);
    } else {
      rect(x, y, s, s);
    }

    // audio connection: line = wired, dot = wireless
    stroke(255);
    fill(255);
    if (audio.startsWith("Wired")) {
      line(x - 10, y, x + 10, y);
    } else if (audio.startsWith("Wireless")) {
      ellipse(x, y, 10, 10);
    }
    noStroke();

    // bag position (orange dot)
    fill(255, 140, 0);
    if (bag.equals("Floor")) ellipse(x, y + edge, 12, 12);
    if (bag.equals("Lap")) ellipse(x, y + s * 0.25, 12, 12);
    if (bag.equals("Back")) ellipse(x - edge, y, 12, 12);
    if (bag.equals("Shoulder")) ellipse(x, y - edge, 12, 12);
    if (bag.equals("Seat")) ellipse(x + edge, y, 12, 12);
  }

  drawKey();
}

// ---------- SORTING (Rearrange) ----------

// gives each passenger a number: activity order first, standing before sitting
int sortKey(String line) {
  String[] p = split(line, ',');
  int k = 0;
  for (int i = 0; i < activities.length; i++) {
    if (activities[i].equals(p[1])) k = i * 10;
  }
  if (p[0].equals("Sitting")) k += 1;
  return k;
}

// simple bubble sort
void sortData() {
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data.length - i - 1; j++) {
      if (sortKey(data[j]) > sortKey(data[j + 1])) {
        String temp = data[j];
        data[j] = data[j + 1];
        data[j + 1] = temp;
      }
    }
  }
}

// ---------- HELPERS ----------

float audioSize(String audio) {
  if (audio.endsWith("Headphones")) return 64;
  if (audio.endsWith("Earphones")) return 56;
  if (audio.endsWith("Earbuds")) return 48;
  return 40;   // no audio
}

color activityColour(String a) {
  if (a.equals("Phone")) return color(80, 180, 255);
  if (a.equals("Listening")) return color(100, 220, 150);
  if (a.equals("Book")) return color(240, 200, 80);
  if (a.equals("Talking")) return color(255, 90, 100);
  if (a.equals("Makeup")) return color(240, 120, 190);
  if (a.equals("Gaming")) return color(170, 130, 255);
  if (a.equals("Newspaper")) return color(200, 180, 150);
  return color(130); // None
}

void heading(String s, float x, float y) {
  fill(120);
  textSize(11);
  textAlign(LEFT, CENTER);
  text(s.toUpperCase(), x, y);
}

void label(String s, float x, float y) {
  fill(255);
  textSize(12);
  textAlign(LEFT, CENTER);
  text(s, x, y);
}

// ---------- KEY ----------

void drawKey() {
  // vertical divider between grid and key
  stroke(80);
  line(660, 30, 660, height - 30);
  noStroke();

  // ---------- column 1 ----------
  float kx = 690;
  float y = 40;

  heading("Position", kx, y);
  y += 30;
  fill(150);
  ellipse(kx + 13, y, 26, 26);
  label("Standing", kx + 40, y);
  y += 34;
  fill(150);
  rect(kx + 13, y, 26, 26);
  label("Sitting", kx + 40, y);

  y += 50;
  heading("Audio connection", kx, y);
  y += 30;
  fill(150);
  rect(kx + 13, y, 26, 26);
  stroke(255);
  line(kx + 8, y, kx + 18, y);
  noStroke();
  label("Wired", kx + 40, y);
  y += 34;
  fill(150);
  rect(kx + 13, y, 26, 26);
  fill(255);
  ellipse(kx + 13, y, 8, 8);
  label("Wireless", kx + 40, y);

  y += 50;
  heading("Bag position", kx, y);
  y += 30;
  String[] bagNames = { "Floor", "Lap", "Back", "Shoulder", "Seat" };
  for (int i = 0; i < bagNames.length; i++) {
    float cx = kx + 13;
    fill(150);
    rect(cx, y, 26, 26);
    fill(255, 140, 0);
    if (i == 0) ellipse(cx, y + 18, 7, 7);    // floor
    if (i == 1) ellipse(cx, y + 6, 7, 7);     // lap
    if (i == 2) ellipse(cx - 18, y, 7, 7);    // back
    if (i == 3) ellipse(cx, y - 18, 7, 7);    // shoulder
    if (i == 4) ellipse(cx + 18, y, 7, 7);    // seat
    label(bagNames[i], kx + 40, y);
    y += 34;
  }

  // ---------- column 2: activity colours ----------
  float ax = 850;
  y = 40;
  heading("Activity (grouped in this order)", ax, y);
  y += 30;
  for (int i = 0; i < activities.length; i++) {
    fill(activityColour(activities[i]));
    rect(ax + 10, y, 20, 20);
    label(activities[i], ax + 30, y);
    y += 34;
  }

  // ---------- bottom: size = audio device ----------
  heading("Size = audio device", kx, 485);
  String[] sizeNames = { "None", "Earbuds", "Earphones", "Headphones" };
  float[] sizeX = { 710, 790, 875, 960 };
  float[] sizeVal = { 40, 48, 56, 64 };
  for (int i = 0; i < 4; i++) {
    fill(150);
    rect(sizeX[i], 545, sizeVal[i], sizeVal[i]);
    fill(255);
    textSize(11);
    textAlign(CENTER, CENTER);
    text(sizeNames[i], sizeX[i], 595);
  }
}
