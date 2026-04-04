import Toybox.Lang;
import Toybox.WatchUi;

class TrainingBuddyDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TrainingBuddyMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}