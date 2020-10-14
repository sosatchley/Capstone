abstract class ControlView {
    // int windowSize;
    // LayoutGrid layoutGrid;
    protected String[] controls;

    abstract void render(float verticalPosition);

    abstract void drawControls(float verticalPosition);

    abstract ControlPanel getControlPanel();

    abstract void setControlPanel(ControlPanel cp);

    void release() {
        println(controls.length);
        for (int i = 0; i <= controls.length; i++) {
            control.remove(controls[i]);
        }
    }
}
