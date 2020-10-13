class ControlPanel {
    ControlP5 cp5;
    HudView view;
    int windowSize;
    int showHeight;
    float curHeight;

    ControlPanel(ControlP5 cp5, int windowSize) {
        this.cp5 = cp5;
        this.windowSize = windowSize;
        this.showHeight = windowSize/5;
        this.curHeight = height;
    }

    void render() {
        mouseEvent();
        pushMatrix();
        translate(0, this.curHeight);
        drawPanel();
        if (this.view != null) {
            this.view.render(this.curHeight);
        }
        popMatrix();
    }

    void setView(ControlPanelLayout layout) {
        println("doin the view");
        this.view = pickCanvas(layout);
    }

    HudView pickCanvas(ControlPanelLayout layout) {
        switch(layout) {
            case DRAW_OR_LOAD:
                return new HudView(this.windowSize);
            default:
                return null;
        }
    }

    void drawPanel() {
        fill(255, 100);
        stroke(27, 196, 245);
        rect(0, 0, width-1, this.showHeight+10, 10);
    }

    void keyPressed() {
        if (key == '1') {
            setView(ControlPanelLayout.DRAW_OR_LOAD);
        }
    }

    void show() {
        this.curHeight = lerp(this.curHeight, height-this.showHeight, 0.2);
        if (this.view == null) {
            setView(ControlPanelLayout.DRAW_OR_LOAD);
        }
    }

    void hide() {
        this.curHeight = lerp(this.curHeight, height+1, 0.1);
    }

    void mouseEvent() {
        if (mouseY > (this.windowSize/10) * 9) {
            show();
        }
        else if (mouseY < (this.windowSize/10) * 7) {
            hide();
        }
    }


}
