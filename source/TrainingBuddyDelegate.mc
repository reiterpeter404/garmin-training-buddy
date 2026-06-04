import Toybox.Lang;
import Toybox.Timer;
import Toybox.ActivityRecording;
import Toybox.WatchUi;

using Toybox.Time.Gregorian;

const TIMER_INTERVAL = 100;
const MS_TO_S = 1000.0;
const PREPARATION_DURATION_IN_SECONDS = 30;
const TRAINING_INTERVAL_DURATION_IN_SECONDS = 180;


class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {
    private var view;
    private var selectedActivity = Activity.SPORT_TRAINING;
    private var activityRunning = false;
    private var updateViewTimer = new Timer.Timer();
    private var currentStep = START;
    private var _session as Session? = null;

    private var repetitions = new Repetitions(3, 4);

    // the total time of the workout
    private var trainingStopwatch = new Stopwatch();
    // the timer to trigger the next lap
    private var workoutTimer;

    /**
     * Construct a new object.
     *
     * @param view the reference to the UI
     */
    public function initialize(watchUi as TrainingBuddyView) {
        BehaviorDelegate.initialize();
        view = watchUi;

        workoutTimer = new WorkoutTimer(PREPARATION_DURATION_IN_SECONDS, method(:workoutTimerCallback));

        updateViewTimer.start(method(:timerCallback), TIMER_INTERVAL, true);
        updateView();
    }

    /**
     * Update the UI, if the timer event is triggered.
     */
    function timerCallback() as Void {
        updateView();
    }

    function workoutTimerCallback() as Void {
        switch(currentStep) {
            case PREPARE:
                onPreparationDone();
                break;
            case EXERCISE:
                currentStep = PAUSE;
                // no break;
            default:
                pressLapButton();
        }
    }

    /**
     * Update all fields of the UI.
     */
    private function updateView() {
        view.updateTrainingDuration(trainingStopwatch.toString());

        switch(currentStep) {
            case START:
                view.updateIntervalTimer("Press START");
                break;
            case WARMUP:
            case COOLDOWN:
                view.updateIntervalTimer("Press LAP");
                break;
            default:
                view.updateIntervalTimer(workoutTimer.getRemainingTimeString());
        }
        view.updateCurrentStep(currentStep.toString());

        view.updateLapCounter(repetitions.getLapView());
        view.updateSetCounter(repetitions.getSetView());
    }

    /**
     * A key event was triggered.
     *
     * @returns true, if the button press was implemented. False otherwise.
     */
    public function onKey(keyEvent) as Boolean {
        switch(keyEvent.getKey()) {
            // Start/stop button
            case KEY_ENTER:
                System.println("Start/stop button registered");
                pressStartButton();
                handleStartStop();
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
    private function pressStartButton() as Void {
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
            startTimers();
        } else {
            stopTimers();
        }
        updateView();
    }

    function stopTimers() as Void {
        trainingStopwatch.stop();
        workoutTimer.stop();
    }

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
     * Implementation for the lap button press.
     */
    private function pressLapButton() as Void {
        if (!exitAppOnBack()) {
            System.println("Back button pressed with no activity. Closing app.");
            closeApp();
            return;
        }

        if (!activityRunning) {
            System.println("Lap button pressed but no activity is running. Ignoring.");
            return;
        }

        System.println("Lap button pressed. Current step = " + currentStep);

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

    // Handles the physical BACK button
    function exitAppOnBack() as Boolean {
        System.println("Back button pressed.");
        if (_session == null) {
            // If no activity is running/created, let the system close the app
            return false; 
        }
        // If an activity exists, intercept the back button so it doesn't accidentally close
        return true; 
    }

    private function handleStartStop() as Void {
        if (_session == null) {
            // Create and start the activity
            _session = ActivityRecording.createSession({
                :name => "Strength Training",
                :sport => selectedActivity
            });
            _session.start();
            // view.updateMessage("Recording...");
        } else if (_session.isRecording()) {
            // Pause the activity and immediately open the pause menu
            _session.stop();
            // view.updateMessage("Paused");
            pushPauseMenu();
        }
    }

    private function pushPauseMenu() as Void {
        var menu = new WatchUi.Menu2({:title => "Activity Paused"});
        menu.addItem(new WatchUi.MenuItem("Resume", null, "resume", null));
        menu.addItem(new WatchUi.MenuItem("Save", null, "save", null));
        menu.addItem(new WatchUi.MenuItem("Discard", null, "discard", null));
        
        WatchUi.pushView(menu, new PauseMenuDelegate(self), WatchUi.SLIDE_UP);
    }

    // Callbacks from the menus
    function resumeActivity() as Void {
        if (_session != null) {
            _session.start();
            // _view.updateMessage("Recording...");
        }
        pressStartButton();
    }

    function saveActivity() as Void {
        if (_session != null) {
            _session.save();
            _session = null;
            closeApp();
            // _view.updateMessage("Saved!\nPress START");
        }
    }

    function discardActivity() as Void {
        if (_session != null) {
            _session.discard();
            _session = null;
            closeApp();
            // _view.updateMessage("Discarded.\nPress START");
        }
    }

    function closeApp() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}
