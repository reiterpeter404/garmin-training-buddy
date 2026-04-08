import Toybox.Lang;

class HelperFunctions {

    public static function arrayToTimeString(timeArray) {
        var timeForView = "";

        if (timeArray[0] > 0) {
            timeForView = Lang.format("$1$:", timeArray[0]);
        } 
        
        return timeForView + Lang.format("$1$:$02$:$3$", [timeArray[1].format("%02d"), timeArray[2].format("%02d"), timeArray[3] / 100]);
    }

}