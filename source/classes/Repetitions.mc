class Repetitions {
    var laps = 0;
    var sets = 0;

    var lapCount;
    var setCount;

    function initialize(_lapCount, _setCount) {
        laps = 0;
        sets = 0;

        lapCount = _lapCount;
        setCount = _setCount;
    }

    function getLaps() {
        return laps;
    }

    function getSets() {
        return sets;
    }

    function getLapView() {
        return laps + " / " + lapCount;
    }

    function getSetView() {
        return sets + " / " + setCount;
    }

    function increaseLaps() {

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

    function trainingFinished() {
        return laps == lapCount && sets == setCount;
    }
}