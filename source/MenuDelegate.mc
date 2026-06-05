import Toybox.WatchUi;

/**
 * This class is responsible for handling the menu interactions.
 */
class MenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainDelegate as TrainingBuddyDelegate;

    function initialize(mainDelegate as TrainingBuddyDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
    }

    /*
     * 
     */
    public function pushPauseMenu() as Void {
        var menu = new WatchUi.Menu2({:title => "Activity Paused"});
        menu.addItem(new WatchUi.MenuItem("Resume", null, "resume", null));
        menu.addItem(new WatchUi.MenuItem("Save", null, "save", null));
        menu.addItem(new WatchUi.MenuItem("Discard", null, "discard", null));
        
        WatchUi.pushView(menu, new PauseMenuDelegate(_mainDelegate), WatchUi.SLIDE_UP);
    }

    /*
     *
     */
    function resumeActivity() as Void {
        var session = _mainDelegate.getSession();

        if (session != null) {
            session.start();
        }
        _mainDelegate.pressStartButton();
    }

    /*
     * 
     */
    function saveActivity() as Void {
        var session = _mainDelegate.getSession();

        if (session != null) {
            session.save();
            _mainDelegate.setSession(null);
            closeApp();
        }
    }

    /*
     * 
     */
    public function discardActivity() as Void {
        var session = _mainDelegate.getSession();

        if (session != null) {
            session.discard();
            _mainDelegate.setSession(null);
            closeApp();
        }
    }

    /*
     * 
     */
    public function closeApp() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}
