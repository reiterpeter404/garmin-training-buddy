using Toybox.Lang;

const HOUR_IN_MINUTES = 60;
const MINUTE_IN_SECONDS = 60;
const SECOND_IN_MILLIS = 1000;

var _hours = 0;
var _minutes = 0;
var _seconds = 0;
var _milliseconds = 0;

class Duration extends Lang.Object {
    
    /**
     * Create a new object of the Duration class.
     */
    function initialize() {
        _hours = 0;
        _minutes = 0;
        _seconds = 0;
        _milliseconds = 0;
    }

    /**
     * Update the time from the given timer values.
     *
     * @param counter              the current counter of the timer
     * @param counterIntervalsInMs the interval of the counter
     */
    function updateTimer(counter, counterIntervalInMs) {
        var totalMs = counter * counterIntervalInMs;

        _hours = totalMs / (SECOND_IN_MILLIS * MINUTE_IN_SECONDS * HOUR_IN_MINUTES);
        totalMs = totalMs % (SECOND_IN_MILLIS * MINUTE_IN_SECONDS * HOUR_IN_MINUTES);

        _minutes = totalMs / (SECOND_IN_MILLIS * MINUTE_IN_SECONDS);
        totalMs = totalMs % (SECOND_IN_MILLIS * MINUTE_IN_SECONDS);

        _seconds = totalMs / SECOND_IN_MILLIS;
        _milliseconds = totalMs % SECOND_IN_MILLIS;
    }

    /**
     * Get the hours.
     * 
     * @returns the hours
     */
    function getHours() {
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