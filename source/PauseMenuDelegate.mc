import Toybox.WatchUi;
import Toybox.Lang;

/**
 * This class is responsible for handling the interactions with the pause menu.
 */
class PauseMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var mainDelegate as TrainingBuddyDelegate;
    private var menuDelegate as MenuDelegate;

    function initialize(mainAppDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
        mainDelegate = mainAppDelegate;
        menuDelegate = new MenuDelegate(mainAppDelegate);
    }

    /**
     * Prevent default behavior of the back button to avoid closing the menu.
     */
    function onBack() {
        return;
    }

    /**
     * Handle the selection of a menu item.
     */
    function onSelect(item as MenuItem) as Void {
        VibrationProfiles.vibrateStrong();

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

    /**
     * Open a menu to confirm the discard action.
     */
    private function pushDiscardConfirmationMenu() as Void {
        var confirmMenu = new WatchUi.Menu2({:title => "Are you sure?"});
        confirmMenu.addItem(new WatchUi.MenuItem("Cancel", null, "cancel_discard", null));
        confirmMenu.addItem(new WatchUi.MenuItem("Discard", null, "confirm_discard", null));
        
        WatchUi.pushView(confirmMenu, new DiscardConfirmDelegate(mainDelegate), WatchUi.SLIDE_UP);
    }
}
