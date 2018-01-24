using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class BahnhofsuhrView extends Ui.WatchFace {

	var isAwake = false;
	var handRed = 0xAA0000;

	// helper function to rotate point[x,y] around origin[x,y] by (angle)
    function rotatePoint(origin, point, angle) {

      var radians = angle * Math.PI / 180.0;
      var cos = Math.cos(radians);
      var sin = Math.sin(radians);
      var dX = point[0] - origin[0];
      var dY = point[1] - origin[1];

      return [ cos * dX - sin * dY + origin[0], sin * dX + cos * dY + origin[1]];

    }

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    		
    		// draw the background
    		dc.drawBitmap(0, 0, Ui.loadResource( Rez.Drawables.UhrBackground ));
    		
    		
        // Get the current time
        var clockTime = Sys.getClockTime();
        var minutes = clockTime.min;
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            } else {}
        }

		/*
        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(App.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);
        */
        
        // draw the hands
        var angleHr = 360/12*hours + 360/12/60*minutes;
        var angleMin = 360/60*minutes;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    		dc.fillPolygon([
    		rotatePoint([120,120], [113,147], angleHr),
    		rotatePoint([120,120], [126,147], angleHr),
    		rotatePoint([120,120], [125,42], angleHr),
    		rotatePoint([120,120], [114,42], angleHr)
    		]);
    		
    		dc.fillPolygon([
    		rotatePoint([120,120], [114,149], angleMin),
    		rotatePoint([120,120], [125,149], angleMin),
    		rotatePoint([120,120], [124,6], angleMin),
    		rotatePoint([120,120], [115,6], angleMin)
    		]);
    		
    		if(isAwake) {
    			var seconds = clockTime.sec;
    			var angleSec = 360/60*seconds;
    		
    			dc.setColor(handRed, Graphics.COLOR_WHITE);
    			
    			var circlePoints = rotatePoint([120,120], [120,42], angleSec);
    			dc.fillCircle(circlePoints[0], circlePoints[1], 12);
    		
	    		dc.fillPolygon([
	    		rotatePoint([120,120], [118,160], angleSec),
	    		rotatePoint([120,120], [121,160], angleSec),
	    		rotatePoint([120,120], [121,50], angleSec),
	    		rotatePoint([120,120], [118,50], angleSec)
	    		]);	
    		}

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {

		isAwake = true;

    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    
    		isAwake = false;
    
    }

}
