let game;
let scl;

function setup() {
	createCanvas(270, 601);
  frameRate(10);
  scl = floor(width / 9);  //Resolution of the each square
  game = new Game();
}


function draw() {
  background(120, 200);

  //If game is playing
  if(game.isPlaying()) {
    
    //Draw the borders of the window
    game.drawBorders();

    //Display score
    game.displayScore();

    //Player functions
    game.runPlayer();

    //Add new car randomly
    game.addCars();

    //Performs all car-related functions
    game.runCars();

    //Control the speed of the game over time
    game.controlSpeed();
  }else {

    //Count little time for the cars to blink
    if(game.hasTime()) {

      //If has time blink it
      game.blinkCars();

    }else {

      //Just speeds the animation
      for(let i = 0; i < 4; i++) {
        game.closeScreen();

        //shows the player how to play
        game.displayHTP();
      }
    }
  }
}

function keyPressed() {
  //Control the player with arrows
  game.controlPlayer(keyCode);

  //If the space bar is press and the state is game over reset the game
  game.resetGame(key);
}