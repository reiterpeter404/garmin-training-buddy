import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;

/**
 * This class is responsible for handling the workout timer, which triggers the next lap of the workout.
 */
class WorkoutTimer {
    const TICK_COUNT = 100;
    const MILLISECONDS = 1000;
    const MS_IN_S = 1000;
    const S_IN_M = 60;
    const MS_IN_M = MS_IN_S * S_IN_M;

    var _duration as Number;    // total duration in ms
    var _remaining as Number;   // remaining time in ms
    var _timer as Timer.Timer;                 // Timer object
    var _callback;              // delegate callback

    /**
     * Create a new workout timer.
     * @param duration the duration of the timer in seconds
     * @param callback the callback method to get the timer finished event
     */
    function initialize(durationInSeconds as Number, callback) {
        _duration  = durationInSeconds * MILLISECONDS;
        _remaining = durationInSeconds * MILLISECONDS;
        _callback  = callback;
        _timer     = new Timer.Timer();
    }

    /**
     * Start the timer.
     */
    function start() as Void {
        _timer.start(method(:_tick), TICK_COUNT, true);
    }

    /**
     * Stop the timer.
     */
    function stop() as Void {
        _timer.stop();
    }

    /**
     * Reset the timer;
     */
    function reset() as Void {
        stop();
        _remaining = _duration;
    }

    /**
     * The timer callback function.
     */
    function _tick() as Void {
        _remaining -= TICK_COUNT;

        if (_remaining <= 0) {
            _remaining = 0;
            stop();

            if (_callback != null) {
                _callback.invoke();
            }
        }
    }

    /**
     * Get the remaining time in milliseconds.
     * @returns the remaining time as a Number
     */
    function getRemainingMs() as Number {
        return _remaining;
    }

    /**
     * Get the remaining time as String.
     * @returns the remaining time as a String.
     */
    function getRemainingTimeString() as String {
        var totalMs = _remaining;

        var minutes = (totalMs / MS_IN_M).toNumber();
        var seconds = ((totalMs % MS_IN_M) / MILLISECONDS).toNumber();
        var milliseconds = ((totalMs % MILLISECONDS) / TICK_COUNT).toNumber();

        return Lang.format("$1$:$2$:$3$",
            [minutes.format("%01d"),
             seconds.format("%02d"),
             milliseconds.format("%01d")]);
    }
}
