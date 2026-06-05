import Toybox.WatchUi;
import Toybox.Lang;

class PauseMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainDelegate as TrainingBuddyDelegate;
    private var menuDelegate as MenuDelegate;

    function initialize(mainDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
        menuDelegate = new MenuDelegate(_mainDelegate);
    }

    /*
     * Prevent default behavior of the back button to avoid closing the menu.
     */
    function onBack() {
        return;
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove the pause menu

        if (id.equals("resume")) {
            menuDelegate.resumeActivity();
        } else if (id.equals("save")) {
            menuDelegate.saveActivity();
        } else if (id.equals("discard")) {
            pushDiscardConfirmationMenu();
        }
    }

    private function pushDiscardConfirmationMenu() as Void {
        var confirmMenu = new WatchUi.Menu2({:title => "Are you sure?"});
        confirmMenu.addItem(new WatchUi.MenuItem("Cancel", null, "cancel_discard", null));
        confirmMenu.addItem(new WatchUi.MenuItem("Discard", null, "confirm_discard", null));
        
        WatchUi.pushView(confirmMenu, new DiscardConfirmDelegate(_mainDelegate), WatchUi.SLIDE_UP);
    }
}