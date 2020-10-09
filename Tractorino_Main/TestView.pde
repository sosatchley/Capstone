// class TestView implements HudView {
//     Slider speedSlider;
//     Toggle sideToggle;
//     Toggle controllerToggle;
//     Button fieldStarter;
//     Button viewButton;
//     Button saveFieldButton;
//     Button loadFieldButton;
//     Button newFieldButton;
//
//
//     TestView() {
//         this.windowSize = windowSize;
//         this.control = control;
//         this.showHeight = windowSize/5;
//         this.curHeight = height;
//         this.currentView = ViewMode.FOLLOW;
//         this.vis = false;
//
//         int controlWidth = showHeight/4;
//         int controlHeight = showHeight/10;
//         ControlFont controlFont = new ControlFont(createFont("Arial",controlHeight/2));
//
//         sideToggle = new Toggle(control, "Outside");
//         sideToggle.setSize(controlWidth, controlHeight);
//         sideToggle.setMode(ControlP5.SWITCH);
//         sideToggle.setFont(controlFont);
//
//         controllerToggle = new Toggle(control, "Controller");
//         controllerToggle.setSize(controlWidth, controlHeight);
//         controllerToggle.setMode(ControlP5.SWITCH);
//         controllerToggle.setValue(false);
//         controllerToggle.setFont(controlFont);
//
//         fieldStarter = new Button(control, "Start");
//         fieldStarter.setSize(controlWidth, controlHeight);
//         fieldStarter.setSwitch(true);
//         fieldStarter.setOff();
//         fieldStarter.setFont(controlFont);
//
//         speedSlider = new Slider(control, "Speed");
//         speedSlider.setSize(showHeight, controlHeight/2);
//         speedSlider.setMin(0.5);
//         speedSlider.setMax(3.0);
//         speedSlider.setFont(controlFont);
//
//         viewButton = new Button(control, "Center");
//         viewButton.setSize(controlWidth,controlHeight);
//         viewButton.setLock(true);
//         viewButton.setFont(controlFont);
//         viewButton.addCallback(new CallbackListener() {
//             public void controlEvent(CallbackEvent e) {
//                 switch(e.getAction()) {
//                     case(ControlP5.ACTION_PRESSED):viewButtonPressed();
//                 }
//             }
//         });
//
//         saveFieldButton = new Button(control, "Save");
//         saveFieldButton.setSize(controlWidth,controlHeight);
//         saveFieldButton.setFont(controlFont);
//         saveFieldButton.addCallback(new CallbackListener() {
//             public void controlEvent(CallbackEvent e) {
//                 switch(e.getAction()) {
//                     case(ControlP5.ACTION_PRESSED):saveButtonPressed();
//                 }
//             }
//         });
//
//         loadFieldButton = new Button(control, "Load");
//         loadFieldButton.setSize(controlWidth,controlHeight);
//         loadFieldButton.setFont(controlFont);
//         loadFieldButton.addCallback(new CallbackListener() {
//             public void controlEvent(CallbackEvent e) {
//                 switch(e.getAction()) {
//                     case(ControlP5.ACTION_PRESSED):loadButtonPressed();
//                 }
//             }
//         });
//
//         newFieldButton = new Button(control, "New");
//         newFieldButton.setSize(controlWidth,controlHeight);
//         newFieldButton.setFont(controlFont);
//         newFieldButton.addCallback(new CallbackListener() {
//             public void controlEvent(CallbackEvent e) {
//                 switch(e.getAction()) {
//                     case(ControlP5.ACTION_PRESSED):newButtonPressed();
//                 }
//             }
//         });
//     }
//
//     void display() {
//
//     }
//
//     void initialize() {
//
//     }
// }
