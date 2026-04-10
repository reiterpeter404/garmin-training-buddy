import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

const TIMER_INTERVAL = 100;
const MS_TO_S = 1000.0;
const TRAINING_INTERVAL_DURATION_IN_SECONDS = 180;


class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {
    private var view;
    private var selectedActivity = Activity.SPORT_TRAINING;
    private var trainingTimerCounter = 0;
    private var activityRunning = false;
    private var updateViewTimer = new Timer.Timer();
    private var intervalTimer = new Timer.Timer();
    private var currentStep = START;
    
    private var trainingStopwatch = new Stopwatch();
    private var repetitions = new Repetitions(3, 4);

    /**
     * Construct a new object.
     *
     * @param view the reference to the UI
     */
    public function initialize(watchUi) {
        BehaviorDelegate.initialize();
        view = watchUi;

        updateViewTimer.start(method(:timerCallback), TIMER_INTERVAL, true);


        view.updateLapCounter(repetitions.getLapView());
        view.updateSetCounter(repetitions.getSetView());

        updateView();
    }

    private function updateView() {
        view.updateTrainingDuration(trainingStopwatch.toString());
    }

    function timerCallback() {
        updateView();
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
     * Implementation for the start button press.
     */
    private function pressStartButton() {
        switch (currentStep) {
            case START:
                System.println("CHANGE TO WARMUP");
                currentStep = WARMUP;
                view.updateCurrentStep("WARMUP");
                break;
            default:
                System.println("current step = " + currentStep);
        }

        activityRunning = !activityRunning;

        if (activityRunning) {
            trainingStopwatch.start();
        } else {
            trainingStopwatch.stop();
        }
        updateView();
    }

    /**
     * Implementation for the lap button press.
     */
    private function pressLapButton() {
        if (!activityRunning) {
            return;
        }

        switch(currentStep) {
            case START:
                currentStep = WARMUP;
                break;

            case WARMUP:
                currentStep = PREPARE;
                break;

            case PREPARE:
                repetitions.increaseLaps();
                    view.updateLapCounter(repetitions.getLapView());
                    view.updateSetCounter(repetitions.getSetView());
                currentStep = EXERCISE;
                break;

            case EXERCISE:

                currentStep = PAUSE;
                break;

            case PAUSE:
                // 
                if (repetitions.trainingFinished()) {
                    currentStep = COOLDOWN;
                } else {
                    repetitions.increaseLaps();
                    view.updateLapCounter(repetitions.getLapView());
                    view.updateSetCounter(repetitions.getSetView());
                    currentStep = EXERCISE;
                }

                break;

            case COOLDOWN:

                break;

            default:
                System.println("Invalid step: " + currentStep);
        }

        view.updateCurrentStep(currentStep.toString());
    }

}