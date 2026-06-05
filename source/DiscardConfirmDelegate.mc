import Toybox.WatchUi;
import Toybox.Lang;

/**
 * This class is responsible for handling the discard confirmation menu. It is shown when the user selects the "Discard"
 * option from the pause menu. It provides options to confirm or cancel the discard action.
 */
class DiscardConfirmDelegate extends WatchUi.Menu2InputDelegate {
    private var menuDelegate as MenuDelegate;

    function initialize(mainAppDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
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
        var id = item.getId() as String;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove confirmation menu

        if (id.equals("confirm_discard")) {
            menuDelegate.discardActivity();
        } else if (id.equals("cancel_discard")) {
            // return to the pause menu
            menuDelegate.pushPauseMenu();
        }
    }
}
