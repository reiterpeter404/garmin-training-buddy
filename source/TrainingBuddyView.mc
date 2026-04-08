import Toybox.Graphics;
import Toybox.WatchUi;

class TrainingBuddyView extends WatchUi.View {
    private var _trainingDuration = "00:00:0";
    private var _intervalTimer = "0:00";
    private var _lapCounter = "0 / 3";
    private var _setCounter = "0 / 4";
    private var _currentStep = "START";

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
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

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    public function updateTrainingDuration(trainingDuration) {
        _trainingDuration = trainingDuration;
        WatchUi.requestUpdate();
    }

    public function updateIntervalTimer(intervalTimer) {
        _intervalTimer = intervalTimer;
        WatchUi.requestUpdate();
    }

    public function updateLapCounter(lapCounter) {
        _lapCounter = lapCounter;
        WatchUi.requestUpdate();
    }

    public function updateSetCounter(setCounter) {
        _setCounter = setCounter;
        WatchUi.requestUpdate();
    }

    public function updateCurrentStep(currentStep) {
        _currentStep = currentStep;
        WatchUi.requestUpdate();
    }

}
