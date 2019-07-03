// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain

// Neuro-Evolution Flappy Bird

// Part 1: https://youtu.be/c6y21FkaUqw
// Part 2: https://youtu.be/tRA6tqgJBc
// Part 3: https://youtu.be/3lvj9jvERvs
// Part 4: https://youtu.be/HrvNpbnjEG8
// Part 5: https://youtu.be/U9wiMM3BqLU

const TOTAL = 50;
//let birds = [];
//let savedBirds = [];
//let pipes = [];
let counter = 0;
let slider;
let bF = 0;

let game;
let scl;

function keyPressed() {
  if (key === 'S') {
    let bird = birds[0];
    saveJSON(bird.brain, 'bird.json');
  }
}

function setup() {
  createCanvas(270, 601);
  //frameRate(20);
  scl = floor(width / 9);
  slider = createSlider(1, 10, 1);
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
    //counter = 0;
    game.nextGeneration();
    game.enemy = [];
  }


  /*
  for (let n = 0; n < slider.value(); n++) {
    if (counter % 75 == 0) {
      pipes.push(new Pipe());
    }
    counter++;

    for (let i = pipes.length - 1; i >= 0; i--) {
      pipes[i].update();

      for (let j = birds.length - 1; j >= 0; j--) {
        if (pipes[i].hits(birds[j])) {
          savedBirds.push(birds.splice(j, 1)[0]);
        }
      }

      if (pipes[i].offscreen()) {
        pipes.splice(i, 1);
      }
    }

    for (let i = birds.length - 1; i >= 0; i--) {
      if (birds[i].offScreen()) {
        savedBirds.push(birds.splice(i, 1)[0]);
      }
    }

    for (let bird of birds) {
      bird.think(pipes);
      bird.update();
    }

    if (birds.length === 0) {
      counter = 0;
      nextGeneration();
      pipes = [];
    }

    */
  }

  // All the drawing stuff
  

  /*
  for (let bird of birds) {
    bird.show();
  }

  for (let pipe of pipes) {
    pipe.show();
  }
  */


// function keyPressed() {
//   if (key == ' ') {
//     bird.up();
//     //console.log("SPACE");
//   }
// }
