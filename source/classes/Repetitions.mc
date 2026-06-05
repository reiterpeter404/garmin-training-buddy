import Toybox.Lang;

/**
 * This class is responsible for tracking the repetitions of the workout, including the laps and sets.
 */
class Repetitions {
    var laps = 0;
    var sets = 0;

    var lapCount as Number;
    var setCount as Number;

    function initialize(_lapCount, _setCount) {
        laps = 0;
        sets = 0;

        lapCount = _lapCount;
        setCount = _setCount;
    }

    /**
     * Get the current lap count.
     */
    function getLaps() as Number {
        return laps;
    }

    /**
     * Get the current set count.
     */
    function getSets() as Number {
        return sets;
    }

    /**
     * Get the lap view string to be displayed on the UI.
     *
     * @returns the lap view string
     */
    function getLapView() as String {
        return laps + " / " + lapCount;
    }

    /**
     * Get the set view string to be displayed on the UI.
     *
     * @returns the set view string
     */
    function getSetView() as String {
        return sets + " / " + setCount;
    }

    /**
     * Increase the lap count.
     *
     * @returns true if the lap was increased, false if the training is finished
     */
    function increaseLaps() as Boolean {

        // start first training set
        if (sets == 0) {
            sets++;
            laps++;
            return true;
        }
        if (laps >= lapCount) {
            // finish the training
            if (sets == setCount) {
                return false;
            } else {
                laps = 1;
                sets++;
                return true;
            }
        }
        laps++;
        return true;
    }

    /**
     * Return true if the training is finished, false otherwise.
     */
    function trainingFinished() as Boolean {
        return laps == lapCount && sets == setCount;
    }
}
