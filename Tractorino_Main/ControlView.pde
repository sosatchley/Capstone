import java.util.HashMap;

class ControlView {
    int windowSize;

    ControlPanel controlPanel;

    LayoutGrid layoutGrid;

    protected String[] startingControls;

    protected String[] drawingControls;

    public ControlPanelLayout currentLayout;

    private ControlPanelLayout previousLayout;

    private float verticalPosition;

    private Button uiBackButton;

    private Button uiForwardButton;

// Starting controls
    Button uiDrawButton;
    Button uiLoadButton;

// Drawing controls
    Button uiFieldButton;
    Button uiObstacleButton;
    Button uiAgentButton;

    Slider uiResolutionSlider;
    Slider uiRotationSlider;

    ScrollableList uiObstacleType;
    ScrollableList uiCutterType;

    ControlView(ControlPanel panel) {
        this.controlPanel = panel;
        this.windowSize = verticalResolution;
        initializeControls();
        setCurrentLayout(ControlPanelLayout.DRAW_OR_LOAD);
    }

    public void setCurrentLayout(ControlPanelLayout newLayout) {
        if (this.currentLayout != null) {
            setLayoutVisibility(this.currentLayout, false);
        }
        setLayoutVisibility(newLayout, true);
        this.previousLayout = this.currentLayout;
        this.currentLayout = newLayout;
        setLayoutGrid(newLayout);
    }

    public void showPreviousLayout() {
        if (this.previousLayout != null) {
            setCurrentLayout(this.previousLayout);
        }
    }

    public ControlPanelLayout getCurrentLayout() {
        return this.currentLayout;
    }

    private void setLayoutVisibility(ControlPanelLayout layout, boolean flag) {
        String[] controls = getControlSet(layout);
        for (int i = 0; i < controls.length; i++) {
            // control.getController(controls[i]).setVisible(flag);
            if (flag) {
                control.getController(controls[i]).show();
            } else {
                control.getController(controls[i]).hide();
            }

        }
    }

    public Controller[] getCurrentControlSet() {
        String[] controlNames = getControlSet(this.getCurrentLayout());
        Controller[] controls = new Controller[controlNames.length];
        for (int i = 0; i < controlNames.length; i++) {
            controls[i] = control.getController(controlNames[i]);
        }
        return controls;
    }

    private String[] getControlSet(ControlPanelLayout layout) {
        switch(layout) {
            case DRAW_OR_LOAD:
            return this.startingControls;
            case FIELD_DRAWING:
            return this.drawingControls;
            default:
                return null;
        }
    }

    private void setLayoutGrid(ControlPanelLayout layout) {
        switch(layout) {
            case DRAW_OR_LOAD:
                this.layoutGrid = new LayoutGrid(2, 1);
                break;
            case FIELD_DRAWING:
                this.layoutGrid = new LayoutGrid(3, 1);
                break;
        }
    }

    void render(float verticalPosition) {
        this.verticalPosition = verticalPosition;
        renderCurrentLayout();
    }

    private void renderCurrentLayout() {
        switch(this.currentLayout) {
            case DRAW_OR_LOAD:
                renderStartingControls();
                break;
            case FIELD_DRAWING:
                renderDrawingControls();
                break;
        }
    }

    private void initializeControls() {
        this.uiBackButton = initializeBackButton().hide();
        this.uiForwardButton = initializeForwardButton().hide();
        initializeStartingControls();
        initializeDrawingControls();
    }

    private void initializeStartingControls() {
        this.startingControls = new String[2];
        setLayoutGrid(ControlPanelLayout.DRAW_OR_LOAD);

        uiDrawButton = new Button(control, "Draw")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(false)
                .setOff()
                .hide()
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESSED):
                                drawButtonPressed();
                        }
                    }
                    });
        this.startingControls[0] = uiDrawButton.getName();

        uiLoadButton = new Button(control, "Load")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(false)
                .setOff()
                .hide()
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESSED):
                                println("This button doesn't work yet. ");
                        }
                    }
                    });
        this.startingControls[1] = uiLoadButton.getName();

        renderStartingControls();
    }

    private void renderStartingControls() {
        float verticalPosition = this.verticalPosition;

        // drawBackButton(verticalPosition);
        PVector drawButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        PVector loadButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        this.uiDrawButton.setPosition(drawButtonPos.x,
                                      drawButtonPos.y + verticalPosition);
        this.uiLoadButton.setPosition(loadButtonPos.x,
                                      loadButtonPos.y + verticalPosition);
    }

    private void initializeDrawingControls() {
        this.drawingControls = new String[8];
        setLayoutGrid(ControlPanelLayout.FIELD_DRAWING);

        this.uiFieldButton = new Button(control, "Place Field")
                .hide()
                .setSwitch(false)
                .setOff()
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESS):
                                fieldButtonPressed();

                        }
                    }
                    });
        this.drawingControls[0] = uiFieldButton.getName();

        this.uiObstacleButton = new Button(control, "Place Obstacle")
                .hide()
                .setSwitch(false)
                .setOff()
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESS):
                                println("Obstacle button doesn't work yet. ");
                        }
                    }
                    });
        this.drawingControls[1] = uiObstacleButton.getName();

        this.uiAgentButton = new Button(control, "Place Agent")
                .hide()
                .setSwitch(false)
                .setOff()
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESS):
                                agentButtonPressed();
                        }
                    }
                    });
        this.drawingControls[2] = uiAgentButton.getName();

        this.uiObstacleType = new ScrollableList(control, "Obstacle Type")
                .hide()
                .close()
                .setWidth(layoutGrid.getControlWidth(ButtonSize.LARGE))
                .setBarHeight(layoutGrid.getControlHeight(ButtonSize.SMALL));
        this.drawingControls[3] = uiObstacleType.getName();

        this.uiCutterType = new ScrollableList(control, "Cutter Type")
                .hide()
                .close()
                .setWidth(layoutGrid.getControlWidth(ButtonSize.LARGE))
                .setBarHeight(layoutGrid.getControlHeight(ButtonSize.SMALL));
        this.drawingControls[4] = uiCutterType.getName();

        this.uiResolutionSlider = new Slider(control, "fieldResolution")
                .hide()
                .setRange(1,10)
                .setValue(1)
                .setNumberOfTickMarks(10)
                .setSliderMode(Slider.FLEXIBLE)
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.SMALL))
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent theEvent) {
                        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
                            resolutionSliderPressed(theEvent.getController().getValue());
                        }
                    }
                });
        this.drawingControls[5] = uiResolutionSlider.getName();
        this.drawingControls[6] = uiBackButton.getName();
        this.drawingControls[7] = uiForwardButton.getName();

        renderDrawingControls();
    }

    private void renderDrawingControls() {
        float verticalPosition = this.verticalPosition;
        drawBackButton(verticalPosition);
        drawForwardButton(verticalPosition);

        PVector fieldButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        this.uiFieldButton.setPosition(fieldButtonPos.x,
                                       fieldButtonPos.y + verticalPosition);
        PVector obstacleButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        this.uiObstacleButton.setPosition(obstacleButtonPos.x,
                                          obstacleButtonPos.y + verticalPosition);
        PVector agentButtonPos = layoutGrid.getCoords(2, 0, ButtonSize.LARGE);
        this.uiAgentButton.setPosition(agentButtonPos.x,
                                       agentButtonPos.y + verticalPosition);
        PVector obstacleDropdownPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        this.uiObstacleType.setPosition(obstacleDropdownPos.x,
                                        obstacleDropdownPos.y - layoutGrid.getControlHeight(ButtonSize.SMALL) + verticalPosition);
        PVector cutterDropdownPos = layoutGrid.getCoords(2, 0, ButtonSize.LARGE);
        this.uiCutterType.setPosition(cutterDropdownPos.x,
                                      cutterDropdownPos.y - layoutGrid.getControlHeight(ButtonSize.SMALL) + verticalPosition);
        PVector resolutionSliderPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        this.uiResolutionSlider.setPosition(resolutionSliderPos.x,
                                           (resolutionSliderPos.y - layoutGrid.getControlHeight(ButtonSize.SMALL)) + verticalPosition);
        }

    private void drawButtonPressed() {
        setCurrentLayout(ControlPanelLayout.FIELD_DRAWING);
        if (field == null) {
            this.uiResolutionSlider.hide();
        }
        this.controlPanel.setLock(ControlPanelLock.SHOW);
    }

    private void fieldButtonPressed() {
        this.controlPanel.setLock(ControlPanelLock.HIDE);
        this.controlPanel.initializeField();
    }

    private void agentButtonPressed() {
        this.controlPanel.setLock(ControlPanelLock.HIDE);
        this.controlPanel.initializeAgent();
    }

    private void resolutionSliderPressed(float value) {
        this.controlPanel.changeFieldResolution((int)value);
    }

    void resetFieldButton() {
        this.uiFieldButton.setOff();
        this.uiResolutionSlider.show();
        this.controlPanel.setLock(ControlPanelLock.SHOW);
    }

    void resetAgentButton() {
        this.uiAgentButton.setOff();
        this.controlPanel.setLock(ControlPanelLock.SHOW);
    }

    Button initializeBackButton() {
        setLayoutGrid(ControlPanelLayout.FIELD_DRAWING);
        Button backButton;
        PVector buttonSize = layoutGrid.backButtonSize();
        backButton = new Button(control, "back")
                        .setSize(floor(buttonSize.x), floor(buttonSize.y))
                        .addCallback(new CallbackListener() {
                            public void controlEvent(CallbackEvent e) {
                                switch(e.getAction()) {
                                    case(ControlP5.ACTION_RELEASED):
                                        showPreviousLayout();
                                }
                            }
                            });
        backButton.setView(new BackButton(backButton));
        return backButton;
    }

    Button initializeForwardButton() {
        setLayoutGrid(ControlPanelLayout.FIELD_DRAWING);
        Button forwardButton;
        PVector buttonSize = layoutGrid.backButtonSize();
        forwardButton = new Button(control, "forward")
                        .setSize(floor(buttonSize.x), floor(buttonSize.y))
                        .addCallback(new CallbackListener() {
                            public void controlEvent(CallbackEvent e) {
                                switch(e.getAction()) {
                                    case(ControlP5.ACTION_RELEASED):
                                }
                            }
                            });
        forwardButton.setView(new NextButton(forwardButton));
        return forwardButton;
    }

    void drawBackButton(float verticalPosition) {
        PVector pos = layoutGrid.backButtonPosition();
        uiBackButton.setPosition(pos.x, pos.y + verticalPosition);
    }

    void drawForwardButton(float verticalPosition) {
        PVector pos = layoutGrid.forwardButtonPosition();
        uiForwardButton.setPosition(pos.x, pos.y + verticalPosition);
    }
}
