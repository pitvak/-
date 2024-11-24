float step = 0.1;
float min = -TWO_PI;
float max = TWO_PI;
float prevX1, prevY1, prevX2, prevY2;
boolean firstPoint = true;

void setup() {
  size(800, 800);
  noFill();
  strokeWeight(2);
  
  // Перебір значень x та z у заданому діапазоні
  for (float x = min; x <= max; x += step) {
    for (float z = min; z <= max; z += step) {
      // Обчислення координат поверхні для першої функції (y1)
      float y1 = F1(x, z);
      // Обчислення координат поверхні для другої функції (y2)
      float y2 = F2(x, z);
      
      // Поворот на 35 градусів навколо осі X для обох функцій
      float[] rotated1 = rotateX(x, y1, z, 35);
      float[] rotated2 = rotateX(x, y2, z, 35);

      float rotX1 = rotated1[0];
      float rotY1 = rotated1[1];
      float rotZ1 = rotated1[2];

      float rotX2 = rotated2[0];
      float rotY2 = rotated2[1];
      float rotZ2 = rotated2[2];

      // Поворот на 5 градусів навколо осі Y для обох функцій
      rotated1 = rotateY(rotX1, rotY1, rotZ1, 5);
      rotated2 = rotateY(rotX2, rotY2, rotZ2, 5);

      // Проекція на площину z=0 для першої функції
      float projX1 = rotated1[0];
      float projY1 = rotated1[1];

      // Проекція на площину z=0 для другої функції
      float projX2 = rotated2[0];
      float projY2 = rotated2[1];
      
      // Якщо це не перша точка, з'єднуємо лінією з попередньою точкою
      if (!firstPoint) {
        // Лінія для першої функції
        stroke(255, 0, 0); // Червоний колір для y1
        line(prevX1, prevY1, projX1 * 100 + width / 2, projY1 * 100 + height / 2);
        
        // Лінія для другої функції
        stroke(0, 0, 255); // Синій колір для y2
        line(prevX2, prevY2, projX2 * 100 + width / 2, projY2 * 100 + height / 2);
      }

      // Зберігаємо поточні координати як попередні
      prevX1 = projX1 * 100 + width / 2;
      prevY1 = projY1 * 100 + height / 2;
      prevX2 = projX2 * 100 + width / 2;
      prevY2 = projY2 * 100 + height / 2;

      firstPoint = false; // Після першої точки, починаємо малювати лінії
    }
  }
}

float F1(float x, float z) {
  float R = sqrt(x * x + z * z);
  return 8 * cos(1.2 * R) / (R + 1);
}

float F2(float x, float z) {
  float R = sqrt(x * x + z * z);
  return 16 * (sin(1.2 * R) + cos(1.5 * R)) / (R + 1);
}

float[] rotateX(float x, float y, float z, float angle) {
  float radians = radians(angle);
  float newY = y * cos(radians) - z * sin(radians);
  float newZ = y * sin(radians) + z * cos(radians);
  return new float[] {x, newY, newZ};
}

float[] rotateY(float x, float y, float z, float angle) {
  float radians = radians(angle);
  float newX = x * cos(radians) + z * sin(radians);
  float newZ = -x * sin(radians) + z * cos(radians);
  return new float[] {newX, y, newZ};
}
