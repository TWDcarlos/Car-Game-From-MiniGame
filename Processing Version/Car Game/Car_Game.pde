int counter = 0;

Game game;

int animationSpeed = 3;

//Scale for Drawing the graphics
float scl;

void setup() {
  size(270, 601);
  //frameRate(20);
  scl = floor(width / 9);
  game = new Game();
}

void draw() {
  background(200);

  //Draw the borders of the window
  game.drawBorders();
  
  if(game.state == PLAYING) {
    //Display score
    game.displayScore();
  
    //Player functions
    game.runCars();
  
    //Add new car randomly
    game.addCars();
  
    //Performs all car-related functions
    game.runEnemys();
  
    //Control the speed of the game over time
    game.controlSpeed();
  }else {
    if(game.hasTime()) {
      game.blinkCars();
    }else {
      for(int i = 0; i < animationSpeed; i++) {
        game.closeScreen();
        game.displayHTP();
      }
    }
  }
}

void keyPressed() {
  game.controlPlayer(key);
  game.resetGame(key);
}
