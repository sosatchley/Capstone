class HudView {
    int windowSize;

    Button uiDrawButton;
    Button uiLoadButton;

    HudView(int windowSize) {
        this.windowSize = windowSize;

        uiDrawButton = new Button(control, "Draw")
                            .setSize(150, 150)
                            .setSwitch(true)
                            .setOff();

        uiLoadButton = new Button(control, "Load")
                            .setSize(150, 150)
                            .setSwitch(true)
                            .setOff();
    }


    public void render(float verticalPosition) {
        drawControls(verticalPosition);

    }

    void drawControls(float verticalPosition) {
        uiDrawButton.setPosition(50, verticalPosition);
        uiLoadButton.setPosition(250,verticalPosition);
    }

    float hudColumn(float columnNumber) {
        float xPosition = ((this.windowSize/100) + (columnNumber * (this.windowSize/10)));
        return xPosition;
    }

    float hudRow(int rowNumber) {
        float yPosition = ((this.windowSize/100) + (curHeight + (rowNumber*(this.windowSize/20))));
        return yPosition;
    }
}
