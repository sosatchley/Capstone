class Agent {
  PVector pos;
  int x;
  int y;
  int r;
  float angle;
  float rotation;
  PVector vel;
  
  Agent() {
    this.pos = new PVector(width/2, height/2);
    this.x = width/2;
    this.y = height/2;
    this.r = 10;
    this.angle = 0;
    this.rotation = 0;
    this.vel = new PVector(0,0);
  }
  
  void update() {
    this.pos.add(this.vel);
  }
  
  void throttle() {
    PVector f = PVector.fromAngle(this.angle);
    this.vel.add(f);
  }
  
  void display() {
    noFill();
    stroke(0,255,0);
    translate(this.pos.x, this.pos.y);
    rotate(this.angle + PI/2);
    triangle(-10, 10, 10, 10, 0, -10);
    
    float x = width/2;
    float y = height/2;
    float dx = this.pos.x - x;
    float dy = this.pos.y - y;
    float angle1 = atan2(dy,dx) - PI/2;
    x = this.pos.x - (cos(angle1) * 50);
    y = this.pos.y - (sin(angle1) * 50);
    impl(x,y,angle1);
    ellipse(x,y,20,20);
  }
  
  void impl(float x, float y, float a) {
    pushMatrix();
    translate(x,y);
    //popMatrix();
    //pushMatrix();
    rotate(a + PI/2);
    //popMatrix();
    //pushMatrix();
    line(0,0,50,0);
    popMatrix();
  }
  
  void setRotation(float a) {
    this.rotation = a;
  }
  
  void turn() {
    this.angle += this.rotation;
  }
}