import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

/**
 * This class is responsible for displaying the workout information on the screen. It provides methods to update the
 * different UI elements based on the current state of the workout.
 */
class TrainingBuddyView extends WatchUi.View {
    private var _trainingDuration = "";
    private var _intervalTimer = "";
    private var _lapCounter = "";
    private var _setCounter = "";
    private var _currentStep = "";

    function initialize() {
        View.initialize();
    }

    /**
     * Set the layout for this view.
     */
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    /**
     * Called when this View is brought to the foreground. Restore
     * the state of this View and prepare it to be shown. This includes
     * loading resources into memory.
     */
    function onShow() as Void {
    }

    /**
     * Update the view.
     */
    function onUpdate(dc as Dc) as Void {
        var trainingDurationLabel = View.findDrawableById("TimerLabel") as Text;
        trainingDurationLabel.setText(_trainingDuration.toString());

        var intervalTimerLabel = View.findDrawableById("IntervalTimer") as Text;
        intervalTimerLabel.setText(_intervalTimer);

        var lapCounterLabel = View.findDrawableById("LapCounter") as Text;
        lapCounterLabel.setText(_lapCounter);

        var setCounterLabel = View.findDrawableById("SetCounter") as Text;
        setCounterLabel.setText(_setCounter);

        var currentStep = View.findDrawableById("CurrentStep") as Text;
        currentStep.setText(_currentStep);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    /**
     * Called when this View is removed from the screen. Save the
     * state of this View here. This includes freeing resources from
     * memory.
     */
    function onHide() as Void {
    }

    /**
     * Update the training duration displayed on the UI.
     */
    public function updateTrainingDuration(trainingDuration as String) as Void {
        _trainingDuration = trainingDuration;
        WatchUi.requestUpdate();
    }

    /**
     * Update the interval timer displayed on the UI.
     */
    public function updateIntervalTimer(intervalTimer as String) as Void {
        _intervalTimer = intervalTimer;
        WatchUi.requestUpdate();
    }

    /**
     * Update the lap counter displayed on the UI.
     */
    public function updateLapCounter(lapCounter as String) as Void {
        _lapCounter = lapCounter;
        WatchUi.requestUpdate();
    }

    /**
     * Update the set counter displayed on the UI.
     */
    public function updateSetCounter(setCounter as String) as Void {
        _setCounter = setCounter;
        WatchUi.requestUpdate();
    }

    /**
     * Update the current step displayed on the UI.
     */
    public function updateCurrentStep(currentStep as String) as Void {
        _currentStep = currentStep;
        WatchUi.requestUpdate();
    }
}
