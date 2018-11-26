import controlP5.*;
class HUD {
    PApplet sketch;
    ControlP5 control;
    Field field;
    float curHeight;
    int showHeight;
    int hideHeight;
    boolean vis;
    CallbackListener cb;
    Textlabel viewLabel;
    Textlabel algLabel;
    PFont font;
    Toggle predictToggle;
    Toggle pathToggle;
    Toggle followToggle;
    Toggle sideToggle;
    boolean Prediction;
    Button fieldStarter;
    Button resetView;
    Slider testSlider;

// TODO: Add program restart. Use redraw()

    HUD(PApplet sketch, ControlP5 control, Field field) {
        this.sketch = sketch;
        this.control = control;
        this.showHeight = 200;
        this.curHeight = height;
        this.field = field;

        this.vis = false;
        this.font = createFont("OpenSansCondensed-Light.ttf", 32);
        // Labels
        viewLabel = new Textlabel(control, "View", width/10, 10, 150,150);
        algLabel = new Textlabel(control, "Info", width/10*8, 10, 150,150);
        viewLabel.setFont(this.font);
        algLabel.setFont(this.font);
        // View Buttons
        Prediction = false;
        predictToggle = new Toggle(control, "Prediction");
        predictToggle.setSize(50,20);
        pathToggle = new Toggle(control, "Path");
        pathToggle.setSize(50, 20);
        followToggle = new Toggle(control, "Follow");
        followToggle.setSize(50, 20);
        resetView = new Button(control, "reset");
        resetView.setSize(50, 20);

        sideToggle = new Toggle(control, "Outside");
        sideToggle.setSize(50, 20);
        sideToggle.setMode(ControlP5.SWITCH);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(200, 100);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();

        testSlider = new Slider(control, "Speed");
        testSlider.setSize(200, 10);
        testSlider.setMin(0.5);
        testSlider.setMax(3.0);
    }



    void render() {
        pushMatrix();
        translate(0, this.curHeight);
        fill(255, 100);
        if (this.Prediction) {
            fill(255,0,0);
        }
        stroke(27, 196, 245);
        rect(0, 0, width-1, height/5+10, 10);
        viewLabel.draw(this.sketch);
        algLabel.draw(this.sketch);
        predictToggle.setPosition(width/20,curHeight+50);
        pathToggle.setPosition(width/20, curHeight+100);
        followToggle.setPosition(width/20, curHeight+150);
        resetView.setPosition(width/20 + width/10, curHeight + 100);
        sideToggle.setPosition(width/2-25, curHeight +  25);
        fieldStarter.setPosition(width/2-100, curHeight+50);
        testSlider.setPosition(width/2-100, curHeight);
        popMatrix();
    }

    void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, height/5*4, 0.2);
    }

    void hide() {
        this.vis = false;
        this.curHeight = lerp(this.curHeight, height+1, 0.1);
    }


}
