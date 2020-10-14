class DrawingControls extends ControlView{
    int windowSize;
    LayoutGrid layoutGrid;

    ControlPanel controlPanel;

    Button uiFieldButton;
    Button uiObstacleButton;
    Button uiAgentButton;

    Slider uiResolutionSlider;
    Slider uiRotationSlider;

    DropdownList uiObstacleType;
    DropdownList uiCutterType;


    DrawingControls(int windowSize) {
        this.windowSize = windowSize;
        this.layoutGrid = new LayoutGrid(this.windowSize, 3, 1);

        uiFieldButton = new Button(control, "Place Field")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(true)
                .setOff();

        uiObstacleButton = new Button(control, "Place Obstacle")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(true)
                .setOff();

        uiAgentButton = new Button(control, "Place Agent")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(true)
                .setOff();

    }


    public void render(float verticalPosition) {
        drawControls(verticalPosition);

    }

    void drawControls(float verticalPosition) {
        PVector fieldButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        uiFieldButton.setPosition(fieldButtonPos.x,
                                  fieldButtonPos.y + verticalPosition);
        PVector obstacleButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        uiObstacleButton.setPosition(obstacleButtonPos.x,
                                     obstacleButtonPos.y + verticalPosition);
        PVector agentButtonPos = layoutGrid.getCoords(2, 0, ButtonSize.LARGE);
        uiAgentButton.setPosition(agentButtonPos.x,
                                  agentButtonPos.y + verticalPosition);
    }

    ControlPanel getControlPanel() {
        return this.controlPanel;
    }

    void setControlPanel(ControlPanel cp) {
        this.controlPanel = cp;
    }

    void release() {
    }
}
