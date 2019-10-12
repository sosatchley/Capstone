import processing.serial.*;

float wheelSpeed;
float wheelRotate;
Wheel wheel;
SteeringWheel steeringWheel;
int mouseStart;
Serial serialPort;
int[] serialInArray = new int[3];
int serialCount = 0;
boolean firstContact = false;

void setup() {
    size(600,1000);
    this.wheel = new Wheel(width/2,height/4*3+25);
    this.steeringWheel = new SteeringWheel(width/2, height/4, 3);
    this.wheelSpeed = 0;
    this.wheelRotate = 0;
    this.mouseStart = 0;
    String portName = Serial.list()[0];
    serialPort = new Serial(this, portName, 9600);
}

void draw() {
    background(127,200,127);
    this.wheel.render();
    this.wheel.turn(this.wheelSpeed);
    this.steeringWheel.render();
    this.steeringWheel.turn(this.wheelRotate);
}

void serialEvent(Serial serialPort) {
    // println(serialPort.read());
    int inByte = serialPort.read();
    if (firstContact == false) {
        if (inByte == 'A') {
            serialPort.clear();
            firstContact = true;
            println("FirstContact");
            serialPort.write('A');

        }
    } else {
        serialInArray[serialCount] = inByte;
        serialCount++;
        if (serialCount > 0) {
            this.wheelRotate = lerp(this.wheelRotate, map(serialInArray[0], 0, 255, radians(-720), radians(720)), .05);
            // wheelSpeed = radians(serialInArray[1]);
            // println(serialInArray[0] + "\t" + serialInArray[1]);
            // println(serialInArray[0] + "\t" + serialInArray[1] + "\t" + serialInArray[2]);
            println(serialInArray[0] + "\t" + degrees(this.wheelRotate));
            serialPort.write('A');
            serialCount = 0;
        }
    }
}

void mousePressed() {
    this.mouseStart = mouseX;
    if (mouseY > 500) {
        if (mouseButton == LEFT) {
            this.wheelSpeed = (radians(2.0));
        } else { //1
            this.wheelSpeed = (radians(-1.0));
        }
    } else {
        if (mouseButton == LEFT) {
            // this.wheelRotate += (radians(1.0));
        } else {
            // this.wheelRotate -= (radians(1.0));
        }
    }
}

void mouseReleased() {
    this.wheelSpeed = (radians(0.0));
    // this.wheelRotate = 0;
}

void mouseDragged() {
    if (mouseY < 500) {
        this.wheelRotate = radians(-1*(mouseX - this.mouseStart));
    }
}

//-----------------------------------------------------------------

class Wheel {
    float speed;
    float rotation;
    float x;
    float y;

    Wheel(float x, float y) {
        this.speed = 0;
        this.rotation = 0;
        this.x = x;
        this.y = y;
    }

    void turn(float angle) {
        this.speed = lerp(this.speed, angle, 0.04);
        this.rotation += this.speed;
        // println(this.rotation);
    }

    void render() {
        pushMatrix();
        translate(this.x, this.y);
        rotate(this.rotation);
        int shadowWidth = 5;
        int gradStart = 235;
        int gradStop = 175;
        int gradWidth = (gradStart-gradStop)/10;

        // Main Tire
        stroke(0);
        strokeWeight(1);
        fill(0);
        ellipse(0,0,500,500);

        // Outer Wheel
        fill(200);
        ellipse(0,0,300,300);

        // Wheel Gap (Outside of Octogon)
        fill(20);
        ellipse(0,0,250,250);

        // Middle Wheel (Octogon)
        fill(200);
        polygon(0,0,130,8);

        // Shadow/Inner Wheel
        for (int i = 0; i <= 10; i++) {
            int gradSize = gradStart-i*gradWidth;
            strokeWeight(gradWidth);
            stroke(0,0+i*10);
            ellipse(0,0,gradSize,gradSize);
        }

        // Lug Ring
        fill(200);
        stroke(20);
        strokeWeight(1);
        ellipse(0,0,100,100);

        // Axle
        fill(0,0,150);
        ellipse(0,0,50,50);

        // Lug nuts
        fill(200);
        stroke(20);
        for(int i = 0; i < 8; i ++) {
            pushMatrix();
            rotate(i*radians(360/8));
            translate(0,-37);
            ellipse(0,0,16,16);
            popMatrix();
        }

        // Tire Tread
        fill(20);
        for(int i = 0; i < 24; i++) {
            pushMatrix();
            rotate(i*radians(360/24));
            translate(0,-250);
            beginShape();
            vertex(0,0);
            vertex(10,-10);
            vertex(25,-10);
            vertex(25,5);
            endShape();
            popMatrix();
        }
        popMatrix();
    }

    void polygon(float x, float y, float radius, int npoints) {
        float angle = TWO_PI / npoints;
        beginShape();
        for (float a = 0; a < TWO_PI; a += angle) {
            float sx = x + cos(a) * radius;
            float sy = y + sin(a) * radius;
            vertex(sx, sy);
        }
        endShape(CLOSE);
    }
}

//-----------------------------------------------------------------

class SteeringWheel {
    float rotation;
    float x;
    float y;
    int bars;

    SteeringWheel(float x, float y, int bars) {
        this.rotation = 0;
        this.x = x;
        this.y = y;
        this.bars = bars;
    }

    void turn(float angle) {
        this.rotation = angle;
        // println(rotation);
    }

    void render() {
        pushMatrix();
        translate(this.x, this.y);
        rotate(this.rotation);
        // Outer Ring
        stroke(0);
        strokeWeight(1);
        fill(0);
        ellipse(0,0,500,500);

        // Fake background
        strokeWeight(1);
        fill(127,200,127);
        ellipse(0,0,450,450);

        // Supports
        fill(50);
        noStroke();
        for(int i = 0; i < this.bars; i++) {
            pushMatrix();
            rotate(i*radians(360/this.bars));
            translate(0, -225);
            beginShape();
            vertex(10,0);
            vertex(7,10);
            vertex(7,100);
            vertex(10,150);
            vertex(15,200);
            vertex(20,225);

            vertex(-20,225);
            vertex(-15,200);
            vertex(-10,150);
            vertex(-7,100);
            vertex(-7,10);
            vertex(-10,0);
            endShape();
            popMatrix();
        }

        // Center Column
        fill(0);
        strokeWeight(1);
        ellipse(0,0,75,75);
        popMatrix();
    }

}
