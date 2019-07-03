final int PLAYING = 0;
final int GAMEOVER = 1;

class Game {
  Car player;
  ArrayList<Car> enemys = new ArrayList<Car>();
  ArrayList<PVector> path = new ArrayList<PVector>(); //All square of the animation
  int state;
  float speed;
  int score;

  //Animations
  int time;
  int index;
  PVector pos;
  PVector posInicial;
  PVector posFinal;
  int incX, incY;

  Game() {
    //Player and Enemy cars
    this.player = new Car(0, true);

    //add new enemy car
    this.enemys.add(new Car(0, false)); 

    //Keep track
    //9 because each car has 3x3 of space
    this.speed = 10;  //Speed of the game
    this.score = 0;  //Score of the game
    this.state = PLAYING; //State, start as playing

    //Animation of Game Over
    this.time = 12;  //Time the animation of gameOver
    this.index = -1; //index of the blinking car along with the player
    this.pos = new PVector(scl/2, scl/2);
    this.posInicial = new PVector(scl/2, scl/2 + scl);
    this.posFinal = new PVector(width - scl / 2, height - scl / 2 - 1);
    this.incX = floor(scl);
    this.incY = 0;
  }
  
  void controlPlayer(char key) {
    player.controlCar(key);
  }

  //=====  GAME FUNCTIONS  ========
  //Add more speed over time to the game
  void controlSpeed() {
    frameRate(this.speed);

    //Adds less speed over time
    if (this.speed > 9 && this.speed < 13) {
      this.speed += 0.01;
    } else if (this.speed > 13 && this.speed < 16) {
      this.speed += 0.009;
    } else if (this.speed > 16 && this.speed < 20) {
      this.speed += 0.0010;
    } else if (this.speed > 20) {
      this.speed += 0.00001;
    }
  }

  //Run all player related functions
  void runCars() {
    player.render(); 
    player.update();
  }

  //Reset the game
  void resetGame(char key) {
    if (key == ' ') {
      if (this.state != PLAYING) {
        this.state = PLAYING;
        this.player.currentSide = 0;
        this.enemys.clear();
        this.score = 0;
        this.speed = 10;
        this.reset();
      }
    }
  }

  //Run all the enemy cars and Check if the player hit an enemy car
  void runEnemys() {

    for (int i = this.enemys.size() - 1; i >= 0; i--) {
      Car tempEnemy = this.enemys.get(i);

      tempEnemy.render();  //Render enemy car
      tempEnemy.update();  //Update enemy car

      //Check if the enemy car hits the player
      if (tempEnemy.checkCar(this.player.pos, this.player.currentSide)) {
        //If did the state is now gameOver and index receive the index of this car
        this.state = GAMEOVER;
        this.index = i;
      }

      //Check if the enemy car is off the screen
      if (tempEnemy.offScreen()) {
        //If did Just remove it and increase score
        this.enemys.remove(i);
        this.score++;
      }
    }
  }

  //Do the animation when game is over
  void closeScreen() {
    if (this.path.size() < 180) {
      this.path.add(new PVector(this.pos.x, this.pos.y));
    }

    if (this.pos.x == this.posFinal.x && this.incX > 0) {
      this.incX = 0;
      this.incY = floor(scl);
      this.posFinal.x -= scl;
    }
    if (this.pos.y == this.posFinal.y && this.incY > 0) {
      this.incX = -floor(scl);
      this.incY = 0;
      this.posFinal.y -= scl;
    }
    if (this.pos.x == this.posInicial.x && this.incX < 0) {
      this.incX = 0;
      this.incY = -floor(scl);
      this.posInicial.x += scl;
    }
    if (this.pos.y == this.posInicial.y && this.incY < 0) {
      this.incX = floor(scl);
      this.incY = 0;
      this.posInicial.y += scl;
    }

    if (this.pos.x > width/2 - 100 && this.pos.x < width/2 + 100) {
      if (this.pos.y > height/2 - 50 &&  this.pos.y < height/2 + 30) {
        this.path.remove(this.path.size() -1);
      }
    }

    this.pos.x += this.incX;
    this.pos.y += this.incY;



    for (int i = 0; i < this.path.size() - 1; i++) {
      drawRect(this.path.get(i).x, this.path.get(i).y, false);
    }
  }

  //Reset the animations
  void reset() {
    this.posInicial.x = scl / 2;
    this.posInicial.y = scl / 2 + scl;

    this.pos.x = scl / 2;
    this.pos.y = scl / 2;

    this.posFinal.x = width - scl / 2;
    this.posFinal.y = height - scl / 2 - 1;

    this.incX = floor(scl);
    this.incY = 0;

    this.path.clear();

    this.time = 12;
  }

  //====  Utility functions  =====
  //Add new enemy car randomly to the game
  void addCars() {
    if (frameCount % 14 == 1) {
      boolean pickCar = random(1) < 0.3;
      int side = floor(random(-1, 2));
      if (pickCar) {
        this.enemys.add(new Car(player.currentSide, false));
      } else {
        this.enemys.add(new Car(side, false));
      }
    } else {
      //this.enemys.add(new Car(side, false));
    }
  }

  //Display how to reset The Game
  void displayHTP() {
    noStroke();
    fill(0);
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
  }

  void blinkCars() {
    if(this.time % 4 == 0) {
      this.enemys.get(this.index).render();
      this.player.render();
    }
  }

  boolean hasTime() {
    if(this.time > 0) {
      this.time --;
      return true;
    }else {
      return false;
    }
  }
}

void drawRect(float x, float y, boolean bool) {
  rectMode(CENTER);
  strokeWeight(3);
  stroke(0);
  noFill();
  rect(x, y, scl, scl);
  if (bool) {
    fill(50);
  } else {
    fill(0);
  }
  noStroke();
  rect(x, y, scl- 10, scl- 10);
}
