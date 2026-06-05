import Toybox.Lang;

using Toybox.Time.Gregorian;

/**
 * This class is responsible for tracking the duration of the workout.
 */
class Stopwatch extends Lang.Object {
    const SECOND_IN_MILLIS = 1000;
    const TIMER_INTERVAL = 100;

    private var timer = new Timer.Timer();
    private var timerCount = 0l;

    var _hours = 0;
    var _minutes = 0;
    var _seconds = 0;
    var _milliseconds = 0;

    /**
     * Create a new object of the Duration class.
     */
    function initialize() {
    }

    /**
     * Start the stopwatch.
     */
    function start() as Void {
        timer.start(method(:timerCallback), TIMER_INTERVAL, true);
    }

    /**
     * Stop the stopwatch.
     */
    function stop() as Void {
        timer.stop();
    }

    /**
     * The callback function for the timer to increase the timer count and update the time values.
     */
    function timerCallback() as Void {
        timerCount += 1;
        updateTimer( timerCount , TIMER_INTERVAL );
    }

    /**
     * Update the time from the given timer values.
     *
     * @param counter              the current counter of the timer
     * @param counterIntervalsInMs the interval of the counter
     */
    function updateTimer(counter as Number, counterIntervalInMs as Number) as Void {
        var totalMs = counter * counterIntervalInMs;

        _hours = totalMs / (SECOND_IN_MILLIS * Gregorian.SECONDS_PER_HOUR);
        totalMs = totalMs % (SECOND_IN_MILLIS * Gregorian.SECONDS_PER_HOUR);

        _minutes = totalMs / (SECOND_IN_MILLIS * Gregorian.SECONDS_PER_MINUTE);
        totalMs = totalMs % (SECOND_IN_MILLIS * Gregorian.SECONDS_PER_MINUTE);

        _seconds = totalMs / SECOND_IN_MILLIS;
        _milliseconds = totalMs % SECOND_IN_MILLIS;
    }

    /**
     * Get the hours.
     * 
     * @returns the hours
     */
    function getHours() as Number {
        return _hours;
    }

    /**
     * Get the minutes.
     * 
     * @returns the minutes
     */
    function getMinutes() as Number {
        return _minutes;
    }    

    /**
     * Get the seconds.
     * 
     * @returns the seconds
     */
    function getSeconds() as Number {
        return _seconds;
    }

    /**
     * Get the milliseconds.
     * 
     * @returns the milliseconds
     */
    function getMilliseconds() as Number {
        return _milliseconds;
    }

    function getTimestamp() as Number {
        return timerCount;
    }

    /**
     * Convert the current object into a string.
     *
     * @returns the formatted string
     *          hours are printed, if greater than zero
     *          for milliseconds, only the hundredths are displayed
     */
    function toString() as String {
        var string = _hours > 0 ? Lang.format("$1$:", _hours) : "";
        return string + Lang.format("$1$:$02$:$3$", [_minutes.format("%02d"), _seconds.format("%02d"), _milliseconds / 100]);
    }
}
