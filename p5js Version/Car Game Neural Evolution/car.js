class Car {
  
  constructor(si, p, brain) {
    let x = 0;
    if(si == 0) {x = width/2;}
    else if(si == -1) { x = scl + (scl / 2);}
    else if(si == 1) { x = width - (scl + (scl / 2));}
    this.player = p;
    if(this.player) {this.pos = createVector(x, height - scl*4 + scl / 2);}
    else{this.pos = createVector(x, 10);}
    this.vel = createVector(0, 20);
    this.currentSide = si;
    this.side = [-1, 0, 1];
    this.score = 0;
    this.fitness = 0;
    if (brain) {
      this.brain = brain.copy();
    } else {
      this.brain = new NeuralNetwork(3, 8, 2);
    }
  }

  mutate() {
    this.brain.mutate(0.1);
  }

  think(cars) {

    // Find the closest pipe
    let index = 0;
    for(let i = 0; i < cars.length; i++) {
      if(cars[i].currentSide == this.currentSide) {
        ellipse(cars[i].pos.x, cars[i].pos.y, 50, 50);
        index = i;
        break;
      }
    }

    let inputs = [];
    inputs[0] = map(this.currentSide, -1, 1, 0, 1);
    inputs[1] = map(p5.Vector.dist(this.pos, cars[index].pos), 0 , height, 0, 1);
    inputs[2] = map(cars[0].currentSide, -1, 1, 0, 1);

    let output = this.brain.predict(inputs);
    //if (output[0] > output[1] && this.velocity >= 0) {
    if (output[0] > output[1]) {
      this.controlCar(RIGHT_ARROW);
    }else {
      this.controlCar(LEFT_ARROW);
    }

  }

  controlCar(keyCode) {
    if(keyCode == RIGHT_ARROW) {
      if(!(this.currentSide == 1)) {
        this.currentSide++;
      } 
    }else if(keyCode == LEFT_ARROW) {
      if(!(this.currentSide == -1)) {
        this.currentSide--;
      } 
    }
  }
  
 	render() {
    this.drawCar(this.pos.x, this.pos.y, this.player);
  }
  
  update() {
    let x = 0;
    this.score++;
    if(this.currentSide == 0) {x = width/2;}
    else if(this.currentSide == -1) { x = scl + (scl / 2);}
    else if(this.currentSide == 1) { x = width - (scl + (scl / 2));}
    this.pos.x = x;
    if(!this.player) {this.pos.add(this.vel);}
  }
  
  checkCar( playerPos, playerSide) {
    let d = dist(playerPos.x, playerPos.y, this.pos.x, this.pos.y);
    return d < 3 || (playerPos.y < this.pos.y + scl * 4 && this.currentSide == playerSide);
  }
  
  offScreen() {
    return this.pos.y > height;
  }

  drawCar(x, y, bool) {
    drawRect(x    , y, bool);
    drawRect(x    , y+scl, bool);
    drawRect(x-scl, y+scl, bool);
    drawRect(x+scl, y+scl, bool);
    drawRect(x    , y+scl*2, bool);
    drawRect(x    , y+scl*3, bool);
    drawRect(x-scl, y+scl*3, bool);
    drawRect(x+scl, y+scl*3, bool);
  }
}