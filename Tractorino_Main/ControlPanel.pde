class ControlPanel {
    HUD hud;
    ControlView view;
    int windowSize;
    int showHeight;
    float curHeight;
    ControlPanelLock lock;

    ControlPanel(HUD hud) {
        this.hud = hud;
        this.windowSize = verticalResolution;
        this.showHeight = windowSize/5;
        this.curHeight = height;
        this.view = new ControlView(this);
        this.lock = ControlPanelLock.NONE;
    }

    void render() {
        mouseEvent();
        keyPressed();
        pushMatrix();
        translate(0, this.curHeight);
        drawPanel();
        if (this.view.currentLayout != null) {
            this.view.render(this.curHeight);
        }
        popMatrix();
    }

    void setView(ControlPanelLayout layout) {
        this.view.setCurrentLayout(layout);
    }

    void drawPanel() {
        fill(255, 100);
        stroke(27, 196, 245);
        rect(0, 0, width-1, this.showHeight+10, 10);
    }

    void keyPressed() {
        if (keyCode == DOWN) {
            println("View 1");
            setView(ControlPanelLayout.DRAW_OR_LOAD);
        } else if (keyCode == UP) {
            println("View 2");
            setView(ControlPanelLayout.FIELD_DRAWING);
        }
    }

    void setLock(ControlPanelLock lock) {
        this.lock = lock;
    }

    boolean isLocked() {
        if (this.lock == ControlPanelLock.HIDE) {
            hide();
            return true;
        } else if (this.lock == ControlPanelLock.SHOW) {
            show();
            return true;
        }
        return false;
    }

    void show() {
        this.curHeight = lerp(this.curHeight, height-this.showHeight, 0.2);
        if (this.view.currentLayout == null) {
            setView(ControlPanelLayout.DRAW_OR_LOAD);
        }
    }

    void hide() {
        this.curHeight = lerp(this.curHeight, height+1, 0.1);
    }

    void mouseEvent() {
        if (isLocked()) {
            return;
        } else {
            if (mouseY > (this.windowSize/10) * 9) {
                show();
            }
            else if (mouseY < (this.windowSize/10) * 7) {
                hide();
            }
        }
    }

    void initializeField() {
        field = new Field();
    }

    void initializeAgent() {
        agent = new Agent();
    }

    void fieldReady() {
        view.resetFieldButton();
    }

    void agentReady() {
        view.resetAgentButton();
    }

    void changeFieldResolution(int value) {
        field.reduceShapeResolutionByFactor(value);
    }

}
