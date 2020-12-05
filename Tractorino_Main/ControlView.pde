class ControlView {
    int windowSize;

    ControlPanel controlPanel;

    LayoutGrid layoutGrid;

    protected String[] startingControls;

    protected String[] drawingControls;

    public ControlPanelLayout currentLayout;

    private float verticalPosition;

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
        setLayoutGrid(ControlPanelLayout.DRAW_OR_LOAD);
        initializeControls();
    }

    public void setCurrentLayout(ControlPanelLayout newLayout) {
        if (this.currentLayout != null) {
            setLayoutVisibility(this.currentLayout, false);
        }
        setLayoutVisibility(newLayout, true);
        this.currentLayout = newLayout;
        setLayoutGrid(newLayout);
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
                this.layoutGrid = new LayoutGrid(this.windowSize, 2, 1);
                break;
            case FIELD_DRAWING:
                this.layoutGrid = new LayoutGrid(this.windowSize, 3, 1);
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
        initializeStartingControls();
        initializeDrawingControls();
    }

    private void initializeStartingControls() {
        this.startingControls = new String[2];

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
        PVector drawButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        PVector loadButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        this.uiDrawButton.setPosition(drawButtonPos.x,
                                      drawButtonPos.y + verticalPosition);
        this.uiLoadButton.setPosition(loadButtonPos.x,
                                      loadButtonPos.y + verticalPosition);
    }

    private void initializeDrawingControls() {
        this.drawingControls = new String[6];

        this.uiFieldButton = new Button(control, "Place Field")
                .hide()
                .setSwitch(true)
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
                .setSwitch(true)
                .setOff()
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESS):
                                println("Obstacle button doesn't work yet. ");
                                println(uiObstacleType.isOpen());
                        }
                    }
                    });
        this.drawingControls[1] = uiObstacleButton.getName();

        this.uiAgentButton = new Button(control, "Place Agent")
                .hide()
                .setSwitch(true)
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
                .setRange(1,10) // values can range from big to small as well
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

        renderDrawingControls();
    }

    private void renderDrawingControls() {
        float verticalPosition = this.verticalPosition;

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
}
