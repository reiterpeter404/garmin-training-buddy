import Toybox.WatchUi;
import Toybox.Lang;

class DiscardConfirmDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainDelegate as TrainingBuddyDelegate;

    function initialize(mainDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove confirmation menu

        if (id.equals("confirm_discard")) {
            _mainDelegate.discardActivity();
        } else if (id.equals("cancel_discard")) {
            // If canceled, go back to recording view but keep it paused
            _mainDelegate.resumeActivity(); // Or remove this line if you want it to remain paused
        }
    }
}