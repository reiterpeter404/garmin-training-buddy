using Toybox.Lang;
using Toybox.Time.Gregorian;

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

    function start() as Void {
        timer.start(method(:timerCallback), TIMER_INTERVAL, true);
    }

    function stop() as Void {
        timer.stop();
    }

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
    function updateTimer(counter, counterIntervalInMs) as Void {
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
    function getHours(){
        return _hours;
    }

    /**
     * Get the minutes.
     * 
     * @returns the minutes
     */
    function getMinutes() {
        return _minutes;
    }    

    /**
     * Get the seconds.
     * 
     * @returns the seconds
     */
    function getSeconds() {
        return _seconds;
    }

    /**
     * Get the milliseconds.
     * 
     * @returns the milliseconds
     */
    function getMilliseconds() {
        return _milliseconds;
    }

    function getTimestamp() {
        return timerCount;
    }

    /**
     * Convert the current object into a string.
     *
     * @returns the formatted string
     *          hours are printed, if greater than zero
     *          for milliseconds, only the hundredths are displayed
     */
    function toString() {
        var string = _hours > 0 ? Lang.format("$1$:", _hours) : "";
        return string + Lang.format("$1$:$02$:$3$", [_minutes.format("%02d"), _seconds.format("%02d"), _milliseconds / 100]);
    }

}