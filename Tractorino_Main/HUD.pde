import controlP5.*;
class HUD {
    int windowSize;
    ControlP5 control;

    float curHeight;
    int showHeight;
    int hideHeight;

    ViewMode currentView;
    boolean vis;

    Slider speedSlider;
    Toggle sideToggle;
    Toggle controllerToggle;
    Button fieldStarter;
    Button viewButton;
    Button saveFieldButton;
    Button loadFieldButton;
    Button newFieldButton;

// TODO: Add program restart. Use redraw()
//      This is not a use case of redraw()
//
// TODO: Remove 'Prediction'
// TODO: Remove 'Reset Program'
// TODO: Replace 'Vertices', 'controllerToggle (AutoSteer)' with button switches

    HUD(int windowSize, ControlP5 control) {
        this.windowSize = windowSize;
        this.control = control;
        this.showHeight = windowSize/5;
        this.curHeight = height;
        this.currentView = ViewMode.FOLLOW;
        this.vis = false;

        int controlWidth = showHeight/4;
        int controlHeight = showHeight/10;
        ControlFont controlFont = new ControlFont(createFont("Arial",controlHeight/2));

        sideToggle = new Toggle(control, "Outside");
        sideToggle.setSize(controlWidth, controlHeight);
        sideToggle.setMode(ControlP5.SWITCH);
        sideToggle.setFont(controlFont);

        controllerToggle = new Toggle(control, "Controller");
        controllerToggle.setSize(controlWidth, controlHeight);
        controllerToggle.setMode(ControlP5.SWITCH);
        controllerToggle.setValue(false);
        controllerToggle.setFont(controlFont);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(controlWidth, controlHeight);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();
        fieldStarter.setFont(controlFont);

        speedSlider = new Slider(control, "Speed");
        speedSlider.setSize(showHeight, controlHeight/2);
        speedSlider.setMin(0.5);
        speedSlider.setMax(3.0);
        speedSlider.setFont(controlFont);

        viewButton = new Button(control, "Center");
        viewButton.setSize(controlWidth,controlHeight);
        viewButton.setLock(true);
        viewButton.setFont(controlFont);
        viewButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):viewButtonPressed();
                }
            }
        });

        saveFieldButton = new Button(control, "Save");
        saveFieldButton.setSize(controlWidth,controlHeight);
        saveFieldButton.setFont(controlFont);
        saveFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):saveButtonPressed();
                }
            }
        });

        loadFieldButton = new Button(control, "Load");
        loadFieldButton.setSize(controlWidth,controlHeight);
        loadFieldButton.setFont(controlFont);
        loadFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):loadButtonPressed();
                }
            }
        });

        newFieldButton = new Button(control, "New");
        newFieldButton.setSize(controlWidth,controlHeight);
        newFieldButton.setFont(controlFont);
        newFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):newButtonPressed();
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
        rect(0, 0, width-1, showHeight+10, 10);
    }

    void drawControls() {
        speedSlider.setPosition(hudColumn(0), hudRow(0));
        viewButton.setPosition(hudColumn(0), hudRow(1));
        newFieldButton.setPosition(hudColumn(1), hudRow(1));
        loadFieldButton.setPosition(hudColumn(1), hudRow(2));
        saveFieldButton.setPosition(hudColumn(1), hudRow(3));
        sideToggle.setPosition(hudColumn(2), hudRow(1));
        fieldStarter.setPosition(hudColumn(2), hudRow(2));
        controllerToggle.setPosition(hudColumn(2), hudRow(3));
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

    void newButtonPressed() {

    }

    void loadButtonPressed() {

    }

    void saveButtonPressed() {

    }

    float hudColumn(float columnNumber) {
        float xPosition = ((this.windowSize/100) + (columnNumber * (this.windowSize/10)));
        return xPosition;
    }

    float hudRow(int rowNumber) {
        float yPosition = ((this.windowSize/100) + (curHeight + (rowNumber*(this.windowSize/20))));
        return yPosition;
    }

    void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, height-this.showHeight, 0.2);
    }

    void hide() {
        this.vis = false;
        this.curHeight = lerp(this.curHeight, height+1, 0.1);
    }


}
