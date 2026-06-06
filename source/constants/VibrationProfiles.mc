import Toybox.Attention;

class VibrationProfiles {
    private static var vibreProfileLight = [
        new Attention.VibeProfile(25, 1000)
    ];

    private static var vibreProfileMed = [
        new Attention.VibeProfile(50, 1000)
    ];

    private static var vibreProfileStrong = [
        new Attention.VibeProfile(75, 1000)
    ];

    private static var vibreProfileMax = [
        new Attention.VibeProfile(100, 1000)
    ];


    /**
     * Vibrate with a normal vibration pattern.
     */
    static function vibrate() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate(
                vibreProfileLight
            );
        }
    }

    /**
     * Vibrate with a strong vibration pattern.
     */
    static function vibrateMed() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate(
                vibreProfileMed
            );
        }
    }

    /**
     * Vibrate with a strong vibration pattern.
     */
    static function vibrateStrong() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate(
                vibreProfileStrong
            );
        }
    }

    /**
     * Vibrate with the maximum vibration pattern.
     */
    static function vibrateMax() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate(
                vibreProfileMax
            );
        }
    }
}