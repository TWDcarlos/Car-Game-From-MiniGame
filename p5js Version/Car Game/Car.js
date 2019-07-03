class Car {
  
  constructor(si, p) {
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
  }
  
 	render() {
    this.drawCar(this.pos.x, this.pos.y);
  }
  
  update() {
    let x = 0;
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

  drawCar(x, y) {
    drawRect(x    , y);
    drawRect(x    , y+scl);
    drawRect(x-scl, y+scl);
    drawRect(x+scl, y+scl);
    drawRect(x    , y+scl*2);
    drawRect(x    , y+scl*3);
    drawRect(x-scl, y+scl*3);
    drawRect(x+scl, y+scl*3);
  }
}