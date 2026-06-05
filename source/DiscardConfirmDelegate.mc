import Toybox.WatchUi;
import Toybox.Lang;

class DiscardConfirmDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainDelegate as TrainingBuddyDelegate;

    function initialize(mainDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
    }

    function onBack() {
        return;
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove confirmation menu

        if (id.equals("confirm_discard")) {
            _mainDelegate.discardActivity();
        } else if (id.equals("cancel_discard")) {
            // return to the pause menu
            _mainDelegate.pushPauseMenu();
        }
    }
}
