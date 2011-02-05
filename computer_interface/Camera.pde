class Camera {
  float cameraX = -100;
  float cameraY = -100;
  float cameraZ = -100;
  float focusX = 100;
  float focusY = 100;
  float focusZ = 100;
  PVector initialCamera;
  PVector initialFocus;
  
  Camera() {
    initialCamera = new PVector(cameraX, cameraY, cameraZ);
    initialFocus = new PVector(focusX, focusY, focusZ);
    cameraX = initialCamera.x;
    cameraY = initialCamera.y;
    cameraZ = initialCamera.z;
    focusX = initialFocus.x;
    focusY = initialFocus.y;
    focusZ = initialFocus.z;
  }
  
  void draw() {
    camera(cameraX, cameraY, cameraZ, focusX, focusY, focusZ, 0, 0, 1);
  }
  
  void keyTyped() {
    if (key == 'q') {
      cameraY++;
      focusY++;
    } else if (key == 'a') {
      cameraX--;
      focusX--;
    } else if (key == 'w') {
      cameraZ--;
      focusZ--;
    } else if (key == 'd') {
      cameraY--;
      focusY--;
    } else if (key == 'e') {
      cameraX++;
      focusX++;
    } else if (key == 's') {
      cameraZ++;
      focusZ++;
    } else if (key == '7') {
      cameraY++;
    } else if (key == '4') {
      cameraX--;
    } else if (key == '8') {
      cameraZ--;
    } else if (key == '6') {
      cameraY--;
    } else if (key == '9') {
      cameraX++;
    } else if (key == '5') {
      cameraZ++;
    } else if (key == '0') {
      cameraX = initialCamera.x;
      cameraY = initialCamera.y;
      cameraZ = initialCamera.z;
      focusX = initialFocus.x;
      focusY = initialFocus.y;
      focusZ = initialFocus.z;
    }
  }
}
