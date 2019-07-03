class Car {
  PVector pos;
  boolean isPlayer;
  PVector vel;
  int currentSide;
  int[] sides = {-1, 0, 1};
  int score;
  float fitness;
  NeuralNetwork brain;

  Car(int side, boolean isPlayer) {
    this(side, isPlayer, new NeuralNetwork(3, 8, 2));
  }

  Car(int side, boolean isPlayer, NeuralNetwork brain) {
    float x = 0;
    if (side == 0) {
      x = width/2;
    } else if (side == -1) { 
      x = scl + (scl / 2);
    } else if (side == 1) { 
      x = width - (scl + (scl / 2));
    }
    this.isPlayer = isPlayer;
    if (isPlayer) {
      this.pos = new PVector(x, height - scl*4 + scl / 2);
    } else {
      this.pos = new PVector(x, 10);
    }
    this.vel = new PVector(0, 20);
    this.currentSide = side;
    this.score = 0;
    this.fitness = 0;
    this.brain = brain;
  }

  void mutate() {
    this.brain.mutate(0.1);
  }

  void think(ArrayList<Car> cars) {
    // Find the closest pipe
    int index = 0;
    for (int i = 0; i < cars.size(); i++) {
      Car tempCar = cars.get(i);

      if (tempCar.currentSide == this.currentSide) {
        ellipse(tempCar.pos.x, tempCar.pos.y, 50, 50);
        index = i;
        break;
      }
    }

    double[] inputs = new double[3];
    inputs[0] = map(this.currentSide, -1, 1, 0, 1);
    inputs[1] = map(PVector.dist(this.pos, cars.get(index).pos), 0, height, 0, 1);
    inputs[2] = map(cars.get(0).currentSide, -1, 1, 0, 1);

    double[] outputs = this.brain.guess(inputs);
    //if (output[0] > output[1] && this.velocity >= 0) {
    if (outputs[0] > outputs[1]) {
      this.controlCar("RIGHT_ARROW");
    } else {
      this.controlCar("LEFT_ARROW");
    }
  }

  void controlCar(String name) {
    if (name == "RIGHT_ARROW") {
      if (!(this.currentSide == 1)) {
        this.currentSide++;
      }
    } else if (name == "LEFT_ARROW") {
      if (!(this.currentSide == -1)) {
        this.currentSide--;
      }
    }
  }

  void controlCar(char keyCode) {
    if (keyCode == 'd') {
      if (!(this.currentSide == 1)) {
        this.currentSide++;
      }
    } else if (keyCode == 'a') {
      if (!(this.currentSide == -1)) {
        this.currentSide--;
      }
    }
  }

  void render() {
    this.drawCar(this.pos.x, this.pos.y, this.isPlayer);
  }

  void update() {
    float x = 0;
    this.score++;
    if (this.currentSide == 0) {
      x = width/2;
    } else if (this.currentSide == -1) { 
      x = scl + (scl / 2);
    } else if (this.currentSide == 1) { 
      x = width - (scl + (scl / 2));
    }
    this.pos.x = x;
    if (!this.isPlayer) {
      this.pos.add(this.vel);
    }
  }

  boolean checkCar(PVector playerPos, int playerSide) {
    float d = dist(playerPos.x, playerPos.y, this.pos.x, this.pos.y);
    return d < 3 || (playerPos.y < this.pos.y + scl * 4 && this.currentSide == playerSide);
  }

  boolean offScreen() {
    return this.pos.y > height;
  }

  void drawCar(float x, float y, boolean bool) {
    drawRect(x, y, bool);
    drawRect(x, y+scl, bool);
    drawRect(x-scl, y+scl, bool);
    drawRect(x+scl, y+scl, bool);
    drawRect(x, y+scl*2, bool);
    drawRect(x, y+scl*3, bool);
    drawRect(x-scl, y+scl*3, bool);
    drawRect(x+scl, y+scl*3, bool);
  }
}
