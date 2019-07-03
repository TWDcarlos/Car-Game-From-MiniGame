final int PLAYING = 0;
final int GAMEOVER = 1;

class Game {
  ArrayList<Car> cars = new ArrayList<Car>();
  ArrayList<Car> enemys = new ArrayList<Car>();
  ArrayList<Car> savedCars = new ArrayList<Car>();
  int state;
  float speed;
  int score;
  
  Game() {
    //Player and Enemy cars
    for(int i = 0; i < TOTAL; i++) {
      this.cars.add(new Car(0, true));
    }
    
    //add new enemy car
    this.enemys.add(new Car(0, false)); 

    //Keep track
    //9 because each car has 3x3 of space
    this.speed = 10;  //Speed of the game
    this.score = 0;  //Score of the game
    this.state = PLAYING; //State, start as playing

    //Animation of Game Over
    //this.time = 12;  //Time the animation of gameOver
    //this.index = null; //index of the blinking car along with the player
    //this.pos = createVector(scl/2, scl/2);
    //this.posInicial = createVector(scl/2, scl/2 + scl);
    //this.posFinal = createVector(width - scl / 2, height - scl / 2 - 1);
    //this.incX = scl;
    //this.incY = 0;

    //this.path = [];  //All square of the animation
  }


  //=====  GAME FUNCTIONS  ========
  //Add more speed over time to the game
  void controlSpeed() {
    //frameRate(this.speed);

    //Adds less speed over time
    if(this.speed > 9 && this.speed < 13) {
      this.speed += 0.01;
    }else if(this.speed > 13 && this.speed < 16) {
      this.speed += 0.009;
    }else if(this.speed > 16 && this.speed < 20) {
      this.speed += 0.0010;
    }else if(this.speed > 20) {
      this.speed += 0.00001;
    }
  }

  //Run all player related functions
  void runCars() {
    for(Car car : this.cars) {
      car.render(); 
      car.update();
      if(this.enemys.size() > 0) {
        car.think(this.enemys);
      }
    }
  }

  void nextGeneration() {
    println("Next Generation");
    this.score = 0;
    counter++;
    this.calculateFitness();
    this.cars.clear();
    for (int i = 0; i < TOTAL; i++) {
      this.cars.add(this.pickOne());
    }
    this.savedCars.clear();
  }
  
  Car pickOne() {
    int index = 0;
    float r = random(1);
    while (r > 0) {
      r = r - this.savedCars.get(index).fitness;
      index++;
    }
    index--;
    Car car = this.savedCars.get(index);
    Car child = new Car(0, true, car.brain);
    child.mutate();
    return child;
  }
  
  void calculateFitness() {
    float sum = 0;

    for (Car car : this.savedCars) {
      sum += car.score;
    }

    for (Car car : this.savedCars) {
      car.fitness = car.score / sum;

      if(car.fitness > bestFitness) {
        bestFitness = car.fitness;
      }
    }
  }


  //Reset the game
  //void resetGame(char key) {
  //  if(key == ' ') {
  //    if(this.state != PLAYING) {
  //      this.state = PLAYING;
  //      this.player.currentSide = 0;
  //      this.enemy = [];
  //      this.score = 0;
  //      this.speed = 10;
  //      this.reset();
  //    }
  //  }
  //}

  //Run all the enemy cars and Check if the player hit an enemy car
  void runEnemys() {
    
    for(int i = this.enemys.size() - 1; i >= 0; i--) {
      Car tempEnemy = this.enemys.get(i);
      
      tempEnemy.render();  //Render enemy car
      tempEnemy.update();  //Update enemy car

      //Check if the enemy car hits the player
      for(int j = this.cars.size() -1; j >= 0; j--) {
        if(tempEnemy.checkCar(this.cars.get(j).pos, this.cars.get(j).currentSide)) {
          //If did the state is now gameOver and index receive the index of this car
          
          this.savedCars.add(this.cars.get(j));
          this.cars.remove(j);
        }
      }

      //Check if the enemy car is off the screen
      if(tempEnemy.offScreen()) {
        //If did Just remove it and increase score
        this.enemys.remove(i);
        this.score++;
      }
    }
  }

  //Do the animation when game is over
  //void closeScreen() {
  //    if(this.path.length < 180) {
  //      this.path.push(createVector(this.pos.x, this.pos.y));
  //    }

  //    if (this.pos.x == this.posFinal.x && this.incX > 0) {
  //      this.incX = 0;
  //      this.incY = scl;
  //      this.posFinal.x -= scl;
  //    }
  //    if (this.pos.y == this.posFinal.y && this.incY > 0) {
  //      this.incX = -scl;
  //      this.incY = 0;
  //      this.posFinal.y -= scl;
  //    }
  //    if (this.pos.x == this.posInicial.x && this.incX < 0) {
  //      this.incX = 0;
  //      this.incY = -scl;
  //      this.posInicial.x += scl;
  //    }
  //    if (this.pos.y == this.posInicial.y && this.incY < 0) {
  //      this.incX = scl;
  //      this.incY = 0;
  //      this.posInicial.y += scl;
  //    }
      
  //    if(this.pos.x > width/2 - 100 && this.pos.x < width/2 + 100) {
  //      if(this.pos.y > height/2 - 50 &&  this.pos.y < height/2 + 30) {
  //        this.path.splice(this.path.length -1, 1);
  //      }
  //    }

  //    this.pos.x += this.incX;
  //    this.pos.y += this.incY;
      
  
  
  //    for(let i = 0; i < this.path.length-1; i++) {
  //      drawRect(this.path[i].x, this.path[i].y);
  //    }
  //}

  //Reset the animations
  //reset() {
  //  this.posInicial.x = scl / 2;
  //  this.posInicial.y = scl / 2 + scl;
  
  //  this.pos.x = scl / 2;
  //  this.pos.y = scl / 2;
  
  //  this.posFinal.x = width - scl / 2;
  //  this.posFinal.y = height - scl / 2 - 1;
  
  //  this.incX = scl;
  //  this.incY = 0;
  
  //  this.path = [];
  
  //  this.time = 12;
  //}

  //====  Utility functions  =====
  //Add new enemy car randomly to the game
  void addCars() {
    if(frameCount % 12 == 1) {
      boolean pickCar = random(1) < 0.3;
      int side = floor(random(-1, 2));
      if(this.cars.size() > 0) {
        if(pickCar) {
          int index = floor(random(this.cars.size()));
          this.enemys.add(new Car(this.cars.get(index).currentSide, false));
        }else {
          this.enemys.add(new Car(side, false));
        }
      }else {
        this.enemys.add(new Car(side, false));
      }
    }
  }

  //Display how to reset The Game
  void displayHTP() {
    noStroke();
    fill(255);
    strokeWeight(1);
    textAlign(CENTER);
    textSize(32);
    text("Game Over", width/2, height/2 - 15);
    textSize(13);
    text("Press Space Bar to try again", width/2, height/2);
  }

  //Draw the borders of the window
  void drawBorders() {
    push ();
    noFill();
    strokeWeight(1);
    stroke(0);
    rectMode(CORNER);
    rect(0, 0, width-2, height-2);
    pop ();
  }

  boolean isPlaying() {
    return this.state == PLAYING;
  }

  void displayScore() {
    text(this.score, width / 2, 20);
    text("Generations: " + counter, 10, 20);
    text("Best Fit: " + nf(bestFitness, 1, 2), width / 2 + 50, 20);
  }

  //void blinkCars() {
  //  if(this.time % 4 == 0) {
  //    this.enemy[this.index].render();
  //    this.player.render();
  //  }
  //}

  //hasTime() {
  //  if(this.time > 0) {
  //    this.time --;
  //    return true;
  //  }else {
  //    return false;
  //  }
  //}
}

void drawRect(float x, float y, boolean bool) {
  rectMode(CENTER);
  strokeWeight(3);
  stroke(0);
  noFill();
  rect(x, y, scl, scl);
  if(bool) {
    fill(50);
  }else {
    fill(0);
  }
  noStroke();
  rect(x, y, scl- 10, scl- 10);
}
