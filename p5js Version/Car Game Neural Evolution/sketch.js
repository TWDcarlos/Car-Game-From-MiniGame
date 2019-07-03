const TOTAL = 50;
let counter = 0;
let bF = 0;

let game;
let scl;

function setup() {
  createCanvas(270, 601);
  scl = floor(width / 9);
  game = new Game();
}

function draw() {
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
  game.ruEnemys();

  //Control the speed of the game over time
  game.controlSpeed();


  if (game.cars.length == 0) {
    game.nextGeneration();
    game.enemy = [];
  }
}
