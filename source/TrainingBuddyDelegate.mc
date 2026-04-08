import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

const TIMER_INTERVAL = 100;
const MS_TO_S = 1000.0;
const TRAINING_INTERVAL_DURATION_IN_SECONDS = 180;


class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {
    private var trainingBuddyView;
    private var selectedActivity;
    private var trainingTimerCounter = 0;
    private var activityRunning = false;
    private var timer = new Timer.Timer();
    private var intervalTimer = new Timer.Timer();
    private var currentStep = "WAITING";
    
    private var trainingDuration = Duration;

    /**
     * Construct a new object.
     *
     * @param view the reference to the UI
     */
    public function initialize(view) {
        BehaviorDelegate.initialize();
        trainingBuddyView = view;
        selectedActivity = Activity.SPORT_TRAINING;
    }

    public function onKey(keyEvent) {
        switch(keyEvent.getKey()) {
            // Start/stop button
            case KEY_ENTER:
                System.println("Start/stop button registered");
                pressStartButton();
                break;
            // Back/lap key
            case KEY_ESC:
                System.println("Back/lap key registered");
                pressLapButton();
                break;
            // Menu event
            case KEY_MENU:
                System.println("Menu press registered");
                break;
            // down key
            case KEY_DOWN:
                System.println("Key down registered");
                break;
            // up key
            case KEY_UP:
                System.println("Key up registered");
                break;
            // unimplemented key event
            default: 
                System.print("Unregistered key event: Key = ");
                System.print(keyEvent.getKey());  // e.g. KEY_MENU = 7
                System.print(" - Type = ");
                System.println(keyEvent.getType()); // e.g. PRESS_TYPE_DOWN = 0
                return false;
        }
        return true;
    }
    
    /**
     * Increase the timer counter and update the UI.
     */
    public function timerCallback() {
        trainingTimerCounter += 1;
        trainingDuration.updateTimer( trainingTimerCounter , TIMER_INTERVAL );

        if (trainingBuddyView != null) {
            trainingBuddyView.updateTrainingDuration(
                trainingDuration.toString()
            );
        } else {
            System.println("View is null");
        }
    }

    /**
     * Implementation for the start button press.
     */
    private function pressStartButton() {
        activityRunning = !activityRunning;

        if (activityRunning) {
            timer.start(method(:timerCallback), TIMER_INTERVAL, true);
        } else {
            timer.stop();
        }
    }

    /**
     * Implementation for the lap button press.
     */
    private function pressLapButton() {
        
    }

}