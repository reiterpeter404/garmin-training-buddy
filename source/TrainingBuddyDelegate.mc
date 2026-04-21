import Toybox.Activity;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

const TIMER_INTERVAL = 100;
const MS_TO_S = 1000.0;
const TRAINING_INTERVAL_DURATION_IN_SECONDS = 180;


class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {
    // timer
    private var activityRunning = false;
    // timer to update the view periodicly
    private var updateViewTimer = new Timer.Timer();
    private var intervalTimer = new Timer.Timer();

    // activity
    private var session = null;
    private var repetitions = new Repetitions(3, 4);
    private var currentStep = START;
    private var nextExerciseAttention = new Attention.VibeProfile(50, 2000);
    private var pauseAttention = new Attention.VibeProfile(25, 2000);

    // UI
    private var view;
    private var trainingStopwatch = new Stopwatch();


    /**
     * Construct a new object.
     *
     * @param view the reference to the UI
     */
    public function initialize(watchUi) {
        BehaviorDelegate.initialize();
        view = watchUi;

        updateViewTimer.start(method(:timerCallback), TIMER_INTERVAL, true);
        updateView();
    }

    /**
     * use the select Start/Stop or touch for recording
     */
    function onSelect() {
        pressStartButton();
        System.println("onSelect executed");
        if (Toybox has :ActivityRecording) {                         // check device for activity recording
            if ((session == null) || (session.isRecording() == false)) {
                session = ActivityRecording.createSession({          // set up recording session
                        :sport=>Activity.SPORT_TRAINING,                  // set sport type
                        :subSport=>Activity.SUB_SPORT_STRENGTH_TRAINING,  // set sub sport type
                        :name=>"Interval Training"                        // set session name
                });
                session.start();                                     // call start session
            }
            else if ((session != null) && session.isRecording()) {
                session.stop();                                      // stop the session
                session.save();                                      // save the session
                session = null;                                      // set session control variable to null
            }

        }
        return true;                                                 // return true for onSelect function
    }

    /**
     * Update all fields of the UI.
     */
    private function updateView() {
        view.updateTrainingDuration(trainingStopwatch.toString());

        view.updateIntervalTimer("unset");
        view.updateCurrentStep(currentStep.toString());

        view.updateLapCounter(repetitions.getLapView());
        view.updateSetCounter(repetitions.getSetView());
    }

    /**
     * Update the UI, if the timer event is triggered.
     */
    function timerCallback() {
        updateView();
    }

    function intervalTimerCallback() {
        nextExercise();
    }

    function startIntervalTimer() {
        intervalTimer.start(method(:intervalTimerCallback), TRAINING_INTERVAL_DURATION_IN_SECONDS * 1000, true);
    }

    /**
     * A key event was triggered.
     *
     * @returns true, if the button press was implemented. False otherwise.
     */
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
                startIntervalTimer();
                repetitions.increaseLaps();
                currentStep = EXERCISE;
                break;

            case EXERCISE:
                startRest();
                break;

            case PAUSE:
                nextExercise();
                break;

            case COOLDOWN:

                break;

            default:
                System.println("Invalid step: " + currentStep);
        }
    }

    function nextExercise() {
        session.addLap();

        // start cooldown, if training is finished
        if (repetitions.trainingFinished()) {
            intervalTimer.stop();
            currentStep = COOLDOWN;
        } else {
            startIntervalTimer();
            repetitions.increaseLaps();
            currentStep = EXERCISE;
        }
    }

    function startRest() {
        currentStep = PAUSE;
    }
}
