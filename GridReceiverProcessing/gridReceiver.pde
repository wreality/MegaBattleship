import processing.serial.*;
Serial serial;

int bigSpacer = 50;
int lilSpacer = 5;
int cols = 10;
int rows = 10;

int alpha;
int red = 0;
int green = 0;
int blue = 0;

String rout = "000";
String gout = "000";
String bout = "000";

color selColor = color(red,green,blue);

PImage colorCircle;

float selX = 1;
float selY = 1;
String[] label = {
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J"
};
Cell[][] board;
String[][] output = new String[10][10];
PFont f;

void setup() {
  size(cols*90, rows*60);
  //serial = new Serial(this, Serial.list()[8], 115200);
  println(Serial.list());
  colorChanger();
} 

void colorChanger() {
  //serial.write("CLEAR\n");
  board = new Cell[cols][rows];
  colorCircle = loadImage("colorCircle.jpg");
  f = createFont("Arial", 18, true);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      board[i][j] = new Cell(i*bigSpacer, j*bigSpacer, bigSpacer, bigSpacer, bigSpacer, bigSpacer);
      output[i][j] = "0,0,0";
    }
  }
}


void draw() {
  background(255);
  image(colorCircle, 600, 50, 250, 250);
  for (int i = 0; i < cols; i++) { 
    for (int j = 0; j < rows; j++) {
      board[i][j].display();
    }
  }
  textFont(f, 30);
  fill(0);
  stroke(0);
  rect(600,310,125,50);
  noFill();
  rect(725,310,125,50);
  noStroke();
  for (int i = 0; i < 10; i++) {
    if (i < 9) {
      text(i+1, 18+bigSpacer*(i+1), 40);
    }
    else {
      text(i+1, 8+bigSpacer*(i+1), 40);
    }
    text(label[i], 18, 40+bigSpacer*(i+1));
  }
  textFont(f, 20);
  text("Press 'x' to clear", 600, 430);
  text("Choose a color above", 600, 460);
  text("(black box = clear square)", 600, 490);
  text("Choose a square to the left", 600, 520);
}

void mousePressed() {
  if (overRect(600,310,125,50)) {
      red = 000;
      green = 000;
      blue = 000;
      rout = nf(red,3);
      gout = nf(green,3);
      bout = nf(blue,3);
  }
  else if (overRect(725,310,125,50)) {
      red = 255;
      green = 255;
      blue = 255;
      rout = nf(red,3);
      gout = nf(green,3);
      bout = nf(blue,3);
  }
  else if (overRect(50,50,500,500)) {
    int newX = round(mouseX/50)-1;
    int newY = round(mouseY/50)-1;
    if (newX >= 0 && newX < 10 && newY >= 0 && newY < 10) {
      if (color(red,green,blue) != board[newX][newY].fill) {
        String strOut = newY + "," + newX + "," + rout + "," + bout + "," + gout;
        println(strOut);
        //serial.write(strOut + "\n");
        board[newX][newY].fill = color(red,green,blue);
        output[newX][newY] = rout+","+gout+","+bout;
      }
    }
  }
  else if (overRect(600,50,250,250)) {
      selColor = get(mouseX,mouseY);
      red = (selColor>>16)&0xFF;
      green = (selColor>>8)&0xFF;
      blue = selColor&0xFF;
      rout = nf(red,3);
      gout = nf(green,3);
      bout = nf(blue,3);
      
    
  }
}

void exit() {
  //serial.write("CLEAR\n"); 
}

void keyPressed() {
  if (key == 'x') {
   colorChanger();
  }
  else if (key == ' ') {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        print(output[j][i] + " ");
      }
      println("");
    }
    println(""); 
  }
}

boolean overRect(float x, float y, float width, float height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } 
  else {
    return false;
  }
}

//cell constructor class for easy grid bs
class Cell {
  float x, y, w, h;
  color fill = color(0, 0, 0);
  int sx, sy;
  Cell(float _x, float _y, float _w, float _h, int _sx, int _sy) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    sx = _sx;
    sy = _sy;
  }
  void display() {
    stroke(125);
    fill(fill);
    rect(x+sx, y+sy, w, h);
    noFill();
  }
}

