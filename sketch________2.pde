int click = 0;
int surfaceVariant = 0; 
int steps = 15; 

PVector[][] vertexSets = {
  {
    new PVector(-60.0, 7.0, 40.0),
    new PVector(58.0, -96.0, -40.0),
    new PVector(-50.0, 9.0, -50.0),
    new PVector(83.0, 23.0, 30.0)
  },
  {
    new PVector(-40.0, 20.0, 50.0),
    new PVector(40.0, -50.0, -20.0),
    new PVector(-30.0, 15.0, -30.0),
    new PVector(60.0, 25.0, 40.0)
  },
  {
    new PVector(-30.0, 10.0, 60.0),
    new PVector(30.0, -70.0, -50.0),
    new PVector(-20.0, 5.0, -40.0),
    new PVector(50.0, 30.0, 20.0)
  }
};

PVector[][] surface = new PVector[steps + 1][steps + 1];

PVector kuns_surface(float u, float v) {
  PVector[] vertexes = vertexSets[surfaceVariant];
  
  float x = (1 - u) * (1 - v) * vertexes[0].x +
            (1 - u) * v * vertexes[1].x +
            u * (1 - v) * vertexes[2].x +
            u * v * vertexes[3].x;

  float y = (1 - u) * (1 - v) * vertexes[0].y +
            (1 - u) * v * vertexes[1].y +
            u * (1 - v) * vertexes[2].y +
            u * v * vertexes[3].y;

  float z = (1 - u) * (1 - v) * vertexes[0].z +
            (1 - u) * v * vertexes[1].z +
            u * (1 - v) * vertexes[2].z +
            u * v * vertexes[3].z;

  return new PVector(x, y, z);
}

void setup() {
  size(800, 800, P3D);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    click = (click + 1) % 4; // режим проекції
  } else if (mouseButton == RIGHT) {
    surfaceVariant = (surfaceVariant + 1) % vertexSets.length; // поверхні
  }
}

void draw() {
  background(255);
  
  if (click == 0) {
    camera(mouseX, mouseY, (height / 2) / tan(PI / 6), width / 2, height / 2, 0, 0, 1, 0);
  } else {
    camera(height / 2, width / 2, (height / 2) / tan(PI / 6), width / 2, height / 2, 0, 0, 1, 0);
  }
  
  translate(width / 2, height / 2);
  rotateX(PI / 2);
  scale(3);

  for (int u = 0; u <= steps; u++) {
    for (int v = 0; v <= steps; v++) {
      surface[u][v] = kuns_surface((float)u / steps, (float)v / steps);
    }
  }

  for (int u = 0; u < steps; u++) {
    stroke(0);
    strokeWeight(1);
    
    if (click == 0) {
      beginShape(QUAD_STRIP);
      for (int v = 0; v <= steps; v++) {
        fill(150, 150, 250);
        vertex(surface[u][v].x, surface[u][v].y, surface[u][v].z);
        vertex(surface[u + 1][v].x, surface[u + 1][v].y, surface[u + 1][v].z);
      }
      endShape();
    } else {
      // Проекції
      beginShape(LINES);
      for (int v = 0; v <= steps; v++) {
        if (click == 1) { 
          vertex(0, surface[u][v].y, surface[u][v].z);
          vertex(0, surface[u + 1][v].y, surface[u + 1][v].z);
        } else if (click == 2) { 
          vertex(surface[u][v].x, 0, surface[u][v].z);
          vertex(surface[u + 1][v].x, 0, surface[u + 1][v].z);
        } else if (click == 3) { 
          vertex(surface[u][v].x, surface[u][v].y, 0);
          vertex(surface[u + 1][v].x, surface[u + 1][v].y, 0);
        }
      }
      endShape();
    }
  }

  drawAxes();
}

void drawAxes() {
  stroke(0);
  strokeWeight(0.5);
  
  line(-100, 0, 0, 100, 0, 0);
  line(0, -100, 0, 0, 100, 0);
  line(0, 0, -100, 0, 0, 100);
}
