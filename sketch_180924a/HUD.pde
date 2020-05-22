import controlP5.*;
class HUD {
    PApplet sketch;
    ControlP5 control;
    Field field;
    float curHeight;
    int showHeight;
    int hideHeight;
    boolean vis;
    Toggle sideToggle;
    Toggle controller;
    Button fieldStarter;
    Button viewButton;
    Slider speedSlider;
    ViewMode currentView;

// TODO: Add program restart. Use redraw()
//      This is not a use case of redraw()
//
// TODO: Remove 'Prediction'
// TODO: Remove 'Reset Program'
// TODO: Replace 'Vertices', 'Controller (AutoSteer)' with button switches

    HUD(PApplet sketch, ControlP5 control, Field field) {
        this.sketch = sketch;
        this.control = control;
        this.showHeight = 200;
        this.curHeight = height;
        this.field = field;
        this.currentView = ViewMode.FOLLOW;
        this.vis = false;

        sideToggle = new Toggle(control, "Outside");
        sideToggle.setSize(50, 20);
        sideToggle.setMode(ControlP5.SWITCH);

        controller = new Toggle(control, "Controller");
        controller.setSize(50, 20);
        controller.setMode(ControlP5.SWITCH);
        controller.setValue(false);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(50, 20);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();

        speedSlider = new Slider(control, "Speed");
        speedSlider.setSize(200, 10);
        speedSlider.setMin(0.5);
        speedSlider.setMax(3.0);

        viewButton = new Button(control, "Center");
        viewButton.setSize(50,20);
        viewButton.setLock(true);
        viewButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):viewButtonPressed();
                }
            }
            });
    }

    void render() {
        pushMatrix();
        translate(0, this.curHeight);
        drawPanel();
        drawControls();
        popMatrix();
    }

    void drawPanel() {
        fill(255, 100);
        stroke(27, 196, 245);
        rect(0, 0, width-1, height/5+10, 10);
    }

    void drawControls() {
        controller.setPosition(hudColumn(2), hudRow(3));
        sideToggle.setPosition(hudColumn(3), hudRow(3));
        fieldStarter.setPosition(hudColumn(4), hudRow(3));
        speedSlider.setPosition(hudColumn(5), hudRow(0));
        viewButton.setPosition(hudColumn(0), hudRow(1));
    }

    void viewButtonPressed() {
        switch(this.currentView) {
            case FOLLOW :
                viewButton.setLabel("Follow");
                this.currentView = ViewMode.CENTER;
                break;
            case CENTER :
                viewButton.setLabel("Center");
                this.currentView = ViewMode.FOLLOW;
                break;
            case PAN :
                viewButton.setLabel("Center");
                this.currentView = ViewMode.FOLLOW;
                break;
        }
    }

    float hudColumn(float columnNumber) {
        float xPosition = (10 + (columnNumber * (width/10)));
        return xPosition;
    }

    float hudRow(int rowNumber) {
        float yPosition = (10 + (curHeight + (rowNumber*50)));
        return yPosition;
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
