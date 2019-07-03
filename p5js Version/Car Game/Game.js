const PLAYING = 0;
const GAMEOVER = 1;

class Game {
  constructor() {

    //Player and Enemy cars
    this.player = new Car(0, true);
    this.enemy = [];
    this.enemy.push(new Car(0, false)); //add new enemy car

    //Keep track
    //9 because each car has 3x3 of space
    this.speed = 10;  //Speed of the game
    this.score = 0;  //Score of the game
    this.state = PLAYING; //State, start as playing

    //Animation of Game Over
    this.time = 12;  //Time the animation of gameOver
    this.index = null; //index of the blinking car along with the player
    this.pos = createVector(scl/2, scl/2);
    this.posInicial = createVector(scl/2, scl/2 + scl);
    this.posFinal = createVector(width - scl / 2, height - scl / 2 - 1);
    this.incX = scl;
    this.incY = 0;

    this.path = [];  //All square of the animation
  }


  //=====  GAME FUNCTIONS  ========
  //Add more speed over time to the game
  controlSpeed() {
    frameRate(this.speed);

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
  runPlayer() {
    this.player.render(); 
    this.player.update();
  }

  //Constrol the player
  controlPlayer(keyCode) {
    if(keyCode == RIGHT_ARROW) {
      if(!(this.player.currentSide == 1)) {
        this.player.currentSide++;
      } 
    }else if(keyCode == LEFT_ARROW) {
      if(!(this.player.currentSide == -1)) {
        this.player.currentSide--;
      } 
    }
  }

  //Reset the game
  resetGame(key) {
    if(key == ' ') {
      if(this.state != PLAYING) {
        this.state = PLAYING;
        this.player.currentSide = 0;
        this.enemy = [];
        this.score = 0;
        this.speed = 10;
        this.reset();
      }
    }
  }

  //Run all the enemy cars and Check if the player hit an enemy car
  runCars() {
    for(let i = this.enemy.length - 1; i > 0; i--) {
      this.enemy[i].render();  //Render enemy car
      this.enemy[i].update();  //Update enemy car

      //Check if the enemy car hits the player
      if(this.enemy[i].checkCar(this.player.pos, this.player.currentSide)) {
        //If did the state is now gameOver and index receive the index of this car
        this.state = GAMEOVER;
        this.index = i;
      }

      //Check if the enemy car is off the screen
      if(this.enemy[i].offScreen()) {
        //If did Just remove it and increase score
        this.enemy.splice(i, 1);
        this.score++;
      }
    }
  }

  //Do the animation when game is over
  closeScreen() {
      if(this.path.length < 180) {
        this.path.push(createVector(this.pos.x, this.pos.y));
      }

      if (this.pos.x == this.posFinal.x && this.incX > 0) {
        this.incX = 0;
        this.incY = scl;
        this.posFinal.x -= scl;
      }
      if (this.pos.y == this.posFinal.y && this.incY > 0) {
        this.incX = -scl;
        this.incY = 0;
        this.posFinal.y -= scl;
      }
      if (this.pos.x == this.posInicial.x && this.incX < 0) {
        this.incX = 0;
        this.incY = -scl;
        this.posInicial.x += scl;
      }
      if (this.pos.y == this.posInicial.y && this.incY < 0) {
        this.incX = scl;
        this.incY = 0;
        this.posInicial.y += scl;
      }
      
      if(this.pos.x > width/2 - 100 && this.pos.x < width/2 + 100) {
        if(this.pos.y > height/2 - 50 &&  this.pos.y < height/2 + 30) {
          this.path.splice(this.path.length -1, 1);
        }
      }

      this.pos.x += this.incX;
      this.pos.y += this.incY;
      
  
  
      for(let i = 0; i < this.path.length-1; i++) {
        drawRect(this.path[i].x, this.path[i].y);
      }
  }

  //Reset the animations
  reset() {
    this.posInicial.x = scl / 2;
    this.posInicial.y = scl / 2 + scl;
  
    this.pos.x = scl / 2;
    this.pos.y = scl / 2;
  
    this.posFinal.x = width - scl / 2;
    this.posFinal.y = height - scl / 2 - 1;
  
    this.incX = scl;
    this.incY = 0;
  
    this.path = [];
  
    this.time = 12;
  }

  //====  Utility functions  =====
  //Add new enemy car randomly to the game
  addCars() {
    if(frameCount % 15 == 1) {
      let side = floor(random(-1, 3));
			if(side == 2) {
				this.enemy.push(new Car(this.player.currentSide, false));
			}else {
      	this.enemy.push(new Car(side, false));
			}
    }
  }

  //Display how to reset The Game
  displayHTP() {
		noStroke();
		fill(255);
		strokeWeight(1);
		textAlign(CENTER);
		textSize(32);
		text('Game Over', width/2, height/2 - 15);
		textSize(13);
		text('Press Space Bar to try again', width/2, height/2);
  }

  //Draw the borders of the window
  drawBorders() {
    push ();
    noFill();
    strokeWeight(1);
    stroke(0);
    rectMode(CORNER);
    rect(0, 0, width-2, height-2);
    pop ();
  }

  isPlaying() {
    return this.state == PLAYING;
  }

  displayScore() {
    text(this.score, width / 2, 20);
  }

  blinkCars() {
    if(this.time % 4 == 0) {
      this.enemy[this.index].render();
      this.player.render();
    }
  }

  hasTime() {
    if(this.time > 0) {
      this.time --;
      return true;
    }else {
      return false;
    }
  }
}

function drawRect(x, y) {
  rectMode(CENTER);
  strokeWeight(3);
  stroke(0);
  noFill();
  rect(x, y, scl, scl);
  fill(0);
  noStroke();
  rect(x, y, scl- 10, scl- 10);
}