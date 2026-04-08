using Toybox.Lang;

const HOUR_IN_MINUTES = 60;
const MINUTE_IN_SECONDS = 60;
const SECOND_IN_MILLIS = 1000;

class MathFunctions {

    public static function timerToString(timer) {
        var timerAsString = Lang.format(
            "$1$:$2$",
            [timer.min.format("%02d"), timer.sec.format("%02d")]
        );
        return timerAsString;
    }

    /**
     * Converts the counter into a time array with [hh, mm, ss, ms * 10]
     */
    public static function counterToTimeArray(counter, counterIntervalInMs) {
        var durationInMilliseconds = counter * counterIntervalInMs;

        var hours = durationInMilliseconds / HOUR_IN_MINUTES / MINUTE_IN_SECONDS / SECOND_IN_MILLIS;
        var minutes = (durationInMilliseconds / SECOND_IN_MILLIS / MINUTE_IN_SECONDS) % HOUR_IN_MINUTES;
        var seconds = (durationInMilliseconds / SECOND_IN_MILLIS) % MINUTE_IN_SECONDS;
        var milliseconds = durationInMilliseconds % SECOND_IN_MILLIS;

        var durationArray = [];
        durationArray.add(hours);
        durationArray.add(minutes);
        durationArray.add(seconds);
        durationArray.add(milliseconds);
        return durationArray;
    }

}
