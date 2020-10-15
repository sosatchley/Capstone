class StartingControls extends ControlView{

    Button uiDrawButton;
    Button uiLoadButton;

    StartingControls(int windowSize) {
        this.windowSize = windowSize;
        this.layoutGrid = new LayoutGrid(this.windowSize, 2, 1);
        this.controls = new String[2];

        uiDrawButton = new Button(control, "Draw")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(true)
                .setOff()
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESSED):
                                drawButtonPressed();
                        }
                    }
                    });
        this.controls[0] = uiDrawButton.getName();

        uiLoadButton = new Button(control, "Load")
                .setSize(layoutGrid.getControlWidth(ButtonSize.LARGE),
                         layoutGrid.getControlHeight(ButtonSize.LARGE))
                .setSwitch(true)
                .setOff()
                .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent e) {
                        switch(e.getAction()) {
                            case(ControlP5.ACTION_PRESSED):
                                loadButtonPressed();
                        }
                    }
                    });
        this.controls[1] = uiLoadButton.getName();
    }


    public void render(float verticalPosition) {
        drawControls(verticalPosition);

    }

    void drawControls(float verticalPosition) {
        PVector drawButtonPos = layoutGrid.getCoords(0, 0, ButtonSize.LARGE);
        PVector loadButtonPos = layoutGrid.getCoords(1, 0, ButtonSize.LARGE);
        uiDrawButton.setPosition(drawButtonPos.x,
                                 drawButtonPos.y + verticalPosition);
        uiLoadButton.setPosition(loadButtonPos.x,
                                 loadButtonPos.y + verticalPosition);
    }

    void drawButtonPressed() {
        this.controlPanel.setView(ControlPanelLayout.FIELD_DRAWING);
    }

    void loadButtonPressed() {

    }
}
