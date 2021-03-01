class SideButton implements ControllerView<Button> {
    Button button;
    float currentWidth;
    float showWidth;
    float hideWidth;

    SideButton(Button button, float showWidth) {
        this.button = button;
        this.currentWidth = showWidth;
        this.hideWidth = 0;
        this.showWidth = showWidth;
        // println(String.format("%s - (maxWidth: %f), (showWidth: %f), (direction: %d)", isForward ? "Forward" : "Back", maxWidth, this.showWidth, direction));
    }

    public void display(PGraphics theApplet, Button theButton) {
        theApplet.pushMatrix();

        // this.autoHide();
        this.setState();
        this.drawButton();
        this.drawLabel(this.button.getLabel());

        theApplet.popMatrix();
    }

    void autoHide() {
        if (mouseInShowZone()) {
            lerpWidth(this.showWidth);
        } else {
            lerpWidth(this.hideWidth);
        }
    }

    void lerpWidth(float target) {
        if (abs(target - this.currentWidth) > 2) {
            this.currentWidth = lerp(this.currentWidth, target, 0.1);
        } else {
            this.currentWidth = target;
        }
    }

    void setState() {
        if (this.button.isMouseOver()) {
            if (this.button.isPressed()) {
                appearanceOnClick();
            } else {
                appearanceOnMouseOver();
            }
        } else {
            appearanceIdle();
        }
    }

    void appearanceOnClick() {
        fill(70, 255);
        strokeWeight(2);
        stroke(255);
    }

    void appearanceOnMouseOver() {
        fill(70, 200);
        strokeWeight(2);
        stroke(37, 206, 255);
    }

    void appearanceIdle() {
        fill(50, 200);
        strokeWeight(2);
        stroke(27, 196, 245);
    }

    void drawButton() {
        ellipse(0, 0, currentWidth, this.button.getHeight());
    }

    void drawLabel(String label) {
    }

    boolean mouseInShowZone() {
        float[] position = this.button.getPosition();
        return dist(mouseX, mouseY, position[0], position[1]) < abs(this.showWidth*5);
    }
}

class BackButton extends SideButton {
    BackButton(Button button) {
        super(button, button.getWidth());
    }

    @Override
    void drawLabel(String label) {
        float pointX = this.currentWidth * (5./8.);
        float pointY = this.button.getHeight() * (1./2.);
        float topX = this.currentWidth * (7./8.);
        float topY = this.button.getHeight() * (2./5.);
        float bottomX = this.currentWidth * (7./8.);
        float bottomY = this.button.getHeight() * (3./5.);

        strokeWeight(4);
        stroke(255);
        line(pointX, pointY, topX, topY);
        line(pointX, pointY, bottomX, bottomY);
    }
}

class NextButton extends SideButton {
    NextButton(Button button) {
        super(button, button.getWidth());
    }

    @Override
    void drawLabel(String label) {
        float pointX = this.button.getWidth() * (3./8.);
        float pointY = this.button.getHeight() * (1./2.);
        float topX = this.button.getWidth() * (1./8.);
        float topY = this.button.getHeight() * (2./5.);
        float bottomX = this.button.getWidth() * (1./8.);
        float bottomY = this.button.getHeight() * (3./5.);

        strokeWeight(4);
        stroke(255);
        line(pointX, pointY, topX, topY);
        line(pointX, pointY, bottomX, bottomY);
    }
}
