//Total Player Cars of The Game
final int TOTAL = 50;

int counter = 0;

float bestFitness = 0;

Game game;

//Scale for Drawing the graphics
float scl;

void setup() {
  size(270, 601);
  //frameRate(20);
  scl = floor(width / 9);
  game = new Game();
}

void draw() {
  background(255);

  //Draw the borders of the window
  game.drawBorders();

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
  
  if (game.cars.size() == 0) {
    //counter = 0;
    game.nextGeneration();
    game.enemys.clear();
  }
}
