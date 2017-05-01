class Triangle {

  PVector v1, v2, v3;
  PVector slope;

  Triangle(PVector _v1, PVector _v2, PVector _v3) {
    v1 = _v1.copy();
    v2 = _v2.copy();
    v3 = _v3.copy();
  }
  
  void setSlope(PVector s) {
    slope = s.copy();
  }

  Triangle[] breakUp() {
    // generate 9 points internal to triangle defined by (v1, v2, v3)

    // v1 triangle
    PVector v4 = v2.copy().add(v1).div(2);
    PVector v5 = v3.copy().add(v2).div(2);
    PVector v6 = v1.copy().add(v3).div(2);

    Triangle[] news = { new Triangle(v1, v4, v6), new Triangle (v4, v2, v5), new Triangle (v3, v5, v6), new Triangle(v4, v5, v6) };
    return news;
  }

  void drawMe() {
    beginShape(TRIANGLES);
    vertex(v1.x, v1.y);
    vertex(v2.x, v2.y);
    vertex(v3.x, v3.y);
    endShape();
  }
}

Triangle[] original_tessellation;
Triangle[][] shattered;

void setup() {
  size(500, 500);
  noStroke();

  original_tessellation = new Triangle[6];
  shattered = new Triangle[6][4];

  PVector v1, v2, v3;
  v1 = new PVector(0, 0);
  v2 = new PVector(0, 0);
  v3 = new PVector(0, 0);

  for (int i = 0; i < 6; i++) {
    v1.x = 0;
    v1.y = 0;
    v2.x = cos(PI / 3 * i);
    v2.y = sin(PI / 3 * i);
    v3.x = cos(PI / 3 * (i + 1));
    v3.y = sin(PI / 3 * (i + 1));
    original_tessellation[i] = new Triangle(v1, v2, v3);
  }
}

void draw() {
  background(255);
  
  translate(250,250);
  scale(50);
  if (frameCount < 100) {
    for (int i = 0; i < 6; i++) {
      original_tessellation[i].drawMe();
      fill(30 * i);
    }
  }
  else if (frameCount % 100 == 0) { // shatter time
    for (int i = 0; i < 6; i++) {
      shattered[i] = original_tessellation[i].breakUp();
      shattered[i][0].setSlope(PVector.random2D());
      shattered[i][1].setSlope(PVector.random2D());
      shattered[i][2].setSlope(PVector.random2D());
      shattered[i][3].setSlope(PVector.random2D());
    }
  }
  else {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 4; j++) {
        pushMatrix();
        PVector trans = shattered[i][j].slope.copy().mult((sin(lerp(0, PI, frameCount / 100.))) * 2);
        translate(trans.x, trans.y);
        shattered[i][j].drawMe();
        popMatrix();
      }
    }
  }
}