class Blob {
  PVector pos;
  float r;
  PVector vel;
  
  //added
  float updatedR;
  //
  
  Blob(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.mult(random(0, 0));
    
    // new r
    r = 0;
    //
  }

  void update() {
    pos.add(vel); 
    if (pos.x > width || pos.x < 0) {
      vel.x *= -1;
    }

    if (pos.y > height || pos.y < 0) {
      vel.y *= -1;
    }
  }
  
  // gets the updated radius
  void updateR(float newRadius){
    r = newRadius;
  }

  void show() {
    noFill();
    stroke(0);
    strokeWeight(3);
    ellipse(pos.x, pos.y, r*2, r*2);
  }
  
  void reset(){
    r = 0;
    updatedR = 0;
  }
  
}
