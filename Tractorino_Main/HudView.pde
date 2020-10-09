class HudView {

  Button fieldStarter;
  float x;
  public float y;

  HudView(float x, float y) {
      this.x = x;
      this.y = y;
  }

  public void setup(PGraphics p) {
      fieldStarter = new Button(control, "Start");
      fieldStarter.setSize(200, 200);
      fieldStarter.setSwitch(true);
      fieldStarter.setOff();
  }
  public void draw(PGraphics p) {
      pushMatrix();
      translate(this.x, this.y);
      fieldStarter.setPosition(0,0);
      popMatrix();
  }

  public void move(float y) {
      this.y = y;
  }
}
