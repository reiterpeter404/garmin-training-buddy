import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

/**
 * This is the main application class. It is responsible for initializing the application and providing the initial view
 * and input delegate.
 */
class TrainingBuddyApp extends Application.AppBase {

    /**
     * Initialize the application.
     */
    function initialize() {
        AppBase.initialize();
    }

    /**
     * onStart() is called on application start up
     */
    function onStart(state as Dictionary?) as Void {
    }

    /**
     * onStop() is called when your application is exiting
     */
    function onStop(state as Dictionary?) as Void {
    }

    /**
     * Return the initial view of your application here
     */
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var appView = new TrainingBuddyView();
        var delegate = new TrainingBuddyDelegate(appView);
        return [ appView, delegate ];
    }
}

/**
 * Helper function to get the app instance from other classes.
 */
function getApp() as TrainingBuddyApp {
    return Application.getApp() as TrainingBuddyApp;
}
