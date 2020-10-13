class DrawingControls implements ControlView{
    int windowSize;
    LayoutGrid layoutGrid;

    ControlPanel controlPanel;

    Button uiDrawButton;
    Button uiLoadButton;


    DrawingControls(int windowSize) {
        this.windowSize = windowSize;
        this.layoutGrid = new LayoutGrid(this.windowSize, 2, 1);

        uiDrawButton = new Button(control, "Draw")
                .setSize(layoutGrid.getControlWidth(ButtonSize.SMALL),
                         layoutGrid.getControlHeight(ButtonSize.SMALL))
                .setSwitch(true)
                .setOff();

        uiLoadButton = new Button(control, "Load")
                .setSize(layoutGrid.getControlWidth(ButtonSize.SMALL),
                         layoutGrid.getControlHeight(ButtonSize.SMALL))
                .setSwitch(true)
                .setOff();
    }


    public void render(float verticalPosition) {
        drawControls(verticalPosition);

    }

    void drawControls(float verticalPosition) {
        PVector drawButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.SMALL);
        PVector loadButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.SMALL);
        uiDrawButton.setPosition(drawButtonPos.x,
                                 drawButtonPos.y + verticalPosition);
        uiLoadButton.setPosition(loadButtonPos.x,
                                 loadButtonPos.y + verticalPosition);
    }

    ControlPanel getControlPanel() {
        return this.controlPanel;
    }

    void setControlPanel(ControlPanel cp) {
        this.controlPanel = cp;
    }
}
