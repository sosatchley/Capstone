class HUD {
    int windowSize;
    PApplet sketch;
    ControlPanel panel;

    float curHeight;
    int showHeight;
    int hideHeight;

    ViewMode currentView;
    boolean vis;

    HUD(PApplet sketch) {
        this.sketch = sketch;
        this.windowSize = verticalResolution;
        this.panel = new ControlPanel(this);
        this.showHeight = this.windowSize/5;
        this.curHeight = height;
        this.currentView = ViewMode.FOLLOW;
        this.vis = false;
    }

    void render() {
        panel.render();
    }

    boolean isMouseOver() {
        return panel.isMouseOver();
    }

    void drawControls() {
        // speedSlider.setPosition(hudColumn(0), hudRow(0));
        // viewButton.setPosition(hudColumn(0), hudRow(1));
        // newFieldButton.setPosition(hudColumn(1), hudRow(1));
        // loadFieldButton.setPosition(hudColumn(1), hudRow(2));
        // saveFieldButton.setPosition(hudColumn(1), hudRow(3));
        // sideToggle.setPosition(hudColumn(2), hudRow(1));
        // fieldStarter.setPosition(hudColumn(2), hudRow(2));
        // controllerToggle.setPosition(hudColumn(2), hudRow(3));
    }

    void viewButtonPressed() {
        // switch(this.currentView) {
        //     case FOLLOW :
        //         viewButton.setLabel("Follow");
        //         this.currentView = ViewMode.CENTER;
        //         break;
        //     case CENTER :
        //         viewButton.setLabel("Center");
        //         this.currentView = ViewMode.FOLLOW;
        //         break;
        //     case PAN :
        //         viewButton.setLabel("Center");
        //         this.currentView = ViewMode.FOLLOW;
        //         break;
        // }
    }

    void newButtonPressed() {

    }

    void loadButtonPressed() {

    }

    void saveButtonPressed() {

    }

    void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, height-this.showHeight, 0.2);
        println("Layout: " + this.panel.view.currentLayout);
        if (this.panel.view.currentLayout == null) {
            panel.setView(ControlPanelLayout.DRAW_OR_LOAD);
        }
    }

    void hide() {
        this.vis = false;
        this.curHeight = lerp(this.curHeight, height+1, 0.1);
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
