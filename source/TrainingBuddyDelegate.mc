import Toybox.ActivityRecording;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

using Toybox.Time.Gregorian;

const TIMER_INTERVAL = 100;
const MS_TO_S = 1000.0;
const PREPARATION_DURATION_IN_SECONDS = 30;
const TRAINING_INTERVAL_DURATION_IN_SECONDS = 180;

/**
 * The main application for handling the workout session, timers and the UI updates.
 */
class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {
    private var view as TrainingBuddyView;

    // workout parameters
    private var trainingName = "Strength Training";
    private var selectedActivity = Activity.SPORT_TRAINING;
    private var repetitions = new Repetitions(3, 4);

    // internal workout states
    private var updateViewTimer = new Timer.Timer();
    private var currentStep = START;
    private var session as Session? = null;

    // menu
    private var menuDelegate as MenuDelegate;

    // the total time of the workout
    private var trainingStopwatch = new Stopwatch();

    // the timer to trigger the next lap
    private var workoutTimer as WorkoutTimer;

    /**
     * Construct a new object.
     *
     * @param view the reference to the UI
     */
    public function initialize(watchUi as TrainingBuddyView) {
        BehaviorDelegate.initialize();
        menuDelegate = new MenuDelegate(self);

        view = watchUi;

        workoutTimer = new WorkoutTimer(PREPARATION_DURATION_IN_SECONDS, method(:workoutTimerCallback));

        updateViewTimer.start(method(:timerCallback), TIMER_INTERVAL, true);
        updateView();
    }

    /**
     * Get the current session.
     */
    public function getSession() as Session? {
        return session;
    }

    /**
     * Set the current session.
     */
    public function setSession(session as Session?) as Void {
        session = session;
    }

    /**
     * Update the UI, if the timer event is triggered.
     */
    function timerCallback() as Void {
        updateView();
    }

    /**
     * The callback function for the workout timer to trigger the next step of the workout.
     */
    function workoutTimerCallback() as Void {
        VibrationProfiles.vibrateStrong();
        switch(currentStep) {
            case PREPARE:
                onPreparationDone();
                break;
            case EXERCISE:
                currentStep = PAUSE;
                // no break;
            default:
                onBack();
        }
    }

    /**
     * Update all fields of the UI.
     */
    private function updateView() as Void {
        view.updateTrainingDuration(trainingStopwatch.toString());

        switch(currentStep) {
            case START:
                view.updateIntervalTimer("Press START");
                break;
            case WARMUP:
                view.updateIntervalTimer("Press LAP");
                break;
            case COOLDOWN:
                view.updateIntervalTimer("Press STOP");
                break;
            default:
                view.updateIntervalTimer(workoutTimer.getRemainingTimeString());
        }
        view.updateCurrentStep(currentStep.toString());

        view.updateLapCounter(repetitions.getLapView());
        view.updateSetCounter(repetitions.getSetView());
    }

    /**
     * Implementation for the start button press.
     */
    public function pressStartButton() as Void {
        switch (currentStep) {
            case START:
                System.println("CHANGE TO WARMUP");
                currentStep = WARMUP;
                break;
            default:
                System.println("current step = " + currentStep);
        }

        if (session == null) {
            return;
        }

        if (session.isRecording()) {
            startTimers();
        } else {
            stopTimers();
        }
        updateView();
    }

    /**
     * Stop all timers.
     */
    function stopTimers() as Void {
        trainingStopwatch.stop();
        workoutTimer.stop();
    }

    /**
     * Start all timers.
     */
    function startTimers() as Void {
        trainingStopwatch.start();
        switch(currentStep) {
            case START:
            case WARMUP:
            case COOLDOWN:
                break;
            default:
                workoutTimer.start();
        }
    }

    /**
     * Implementation of the start/stop button press.
     *
     * @returns true, after handling the button press.
     */
    function onSelect() as Boolean {
        VibrationProfiles.vibrateStrong();
        handleStartStop();
        pressStartButton();
        return true;
    }

    /**
     * Implementation for the lap button press.
     *
     * @returns true, after handling the button press according to the app state.
     */
    function onBack() as Boolean {
        // exit the app if no session was created yet
        if (!exitAppOnBack()) {
            VibrationProfiles.vibrateMed();
            menuDelegate.closeApp();
            return true;
        }

        if (!session.isRecording()) {
            System.println("Lap button pressed but no activity is running. Ignoring.");
            return true;
        }

        VibrationProfiles.vibrateStrong();

        switch(currentStep) {
            case START:
                currentStep = WARMUP;
                break;

            case WARMUP:
                currentStep = PREPARE;
                workoutTimer.start();
                break;

            case PREPARE:
                onPreparationDone();
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
                    currentStep = EXERCISE;
                    workoutTimer.reset();
                    workoutTimer.start();
                    workoutTimer.start();
                }

                break;

            case COOLDOWN:

                break;

            default:
                System.println("Invalid step: " + currentStep);
        }

        return true;
    }

    /**
     * Changes the duration of the timer and starts the workout.
     */
    function onPreparationDone() as Void {
        workoutTimer.stop();
        workoutTimer = new WorkoutTimer(TRAINING_INTERVAL_DURATION_IN_SECONDS, method(:workoutTimerCallback));

        repetitions.increaseLaps();
        currentStep = EXERCISE;
        workoutTimer.reset();
        workoutTimer.start();
    }

    /**
     * Handle the back button.
     *
     * @returns true, if the activity is started and the button is used as a lap button. False if no activity is running
     *          and the back button should close the app.
     */
    function exitAppOnBack() as Boolean {
        System.println("Back button pressed.");
        if (session == null) {
            // If no activity is running/created, let the system close the app
            return false; 
        }
        // If an activity exists, intercept the back button so it doesn't close
        return true; 
    }

    /**
     * Handle the start/stop button press based on the current state of the activity. If no activity was created, create
     * and start it. If an activity is running, pause it and open the pause menu.
     */
    private function handleStartStop() as Void {
        if (session == null) {
            // Create and start the activity
            session = ActivityRecording.createSession({
                :name => trainingName,
                :sport => selectedActivity
            });
            session.start();
        } else if (session.isRecording()) {
            // Pause the activity and immediately open the pause menu
            session.stop();
            menuDelegate.pushPauseMenu();
        }
    }
}
