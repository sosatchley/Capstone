interface ControlView {
    // int windowSize;
    // LayoutGrid layoutGrid;

    void render(float verticalPosition);

    void drawControls(float verticalPosition);

    ControlPanel getControlPanel();

    void setControlPanel(ControlPanel cp);
}
