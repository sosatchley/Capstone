abstract class ControlView {

    int windowSize;

    ControlPanel controlPanel;

    LayoutGrid layoutGrid;

    protected String[] controls;

    protected Button uiBackButton;

    abstract void render(float verticalPosition);

    abstract void drawControls(float verticalPosition);

    void release() {
        for (int i = 0; i < controls.length; i++) {
            control.remove(controls[i]);
        }
        control.remove("<");
    }

    ControlPanel getControlPanel() {
        return this.controlPanel;
    }

    void setControlPanel(ControlPanel cp) {
        this.controlPanel = cp;
    }

    Button setupBackButton() {
        Button backButton;
        PVector buttonSize = this.layoutGrid.backButtonSize();
        backButton = new Button(control, "<")
                        .setSize(floor(buttonSize.x), floor(buttonSize.y))
                        .setView(new BackButton())
                        .addCallback(new CallbackListener() {
                            public void controlEvent(CallbackEvent e) {
                                switch(e.getAction()) {
                                    case(ControlP5.ACTION_PRESSED):
                                        backButtonPressed();
                                }
                            }
                            });
        return backButton;
    }

    void drawBackButton(float verticalPosition) {
        PVector pos = this.layoutGrid.backButtonPosition();
        uiBackButton.setPosition(pos.x, pos.y + verticalPosition);
    }

    void backButtonPressed() {
        this.controlPanel.setView(ControlPanelLayout.DRAW_OR_LOAD);
    }
}

class BackButton implements ControllerView<Button> {

    public void display(PGraphics theApplet, Button theButton) {
        theApplet.pushMatrix();
        if (theButton.isInside()) {
            // if (theButton.isPressed()) { // button is pressed
            //     println("Back Pressed");
            //     theApplet.fill(70, 255);
            //     theApplet.strokeWeight(2);
            //     theApplet.stroke(255);
            //
            // } else { // mouse hovers the button
                theApplet.fill(70, 200);
                theApplet.strokeWeight(2);
                theApplet.stroke(37, 206, 255);
            // }
        } else { // the mouse is located outside the button area
            theApplet.fill(50, 200);
            theApplet.stroke(27, 196, 245);
        }

        theApplet.ellipse(0, 0, theButton.getWidth(), theButton.getHeight());

        // center the caption label
        int x = theButton.getWidth();//*(3/4);// - theButton.getCaptionLabel().getWidth()/4;
        int y = theButton.getHeight()/2;// - theButton.getCaptionLabel().getHeight()/2;
        float pointX = theButton.getWidth() * (5./8.);
        float pointY = theButton.getHeight() * (1./2.);
        float topX = theButton.getWidth() * (7./8.);
        float topY = theButton.getHeight() * (2./5.);
        float bottomX = theButton.getWidth() * (7./8.);
        float bottomY = theButton.getHeight() * (3./5.);

        // translate(x, y);
        // theButton.getCaptionLabel().draw(theApplet);
        strokeWeight(4);
        stroke(255);
        line(pointX, pointY, topX, topY);
        line(pointX, pointY, bottomX, bottomY);

        theApplet.popMatrix();
    }
}
