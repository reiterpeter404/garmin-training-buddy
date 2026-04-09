class Repetitions {
    const MAX_LAPS = 3;
    const MAX_SETS = 4;

    var laps = 0;
    var sets = 0;

    function initialize() {
        laps = 0;
        sets = 0;
    }

    function getLaps() {
        return laps;
    }

    function getSets() {
        return sets;
    }

    function increaseLaps() {

        // start first training set
        if (sets == 0) {
            sets++;
            laps++;
            return true;
        }
        if (laps >= MAX_LAPS) {
            // finish the training
            if (sets == MAX_SETS) {
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
        return laps == MAX_LAPS && sets == MAX_SETS;
    }
}