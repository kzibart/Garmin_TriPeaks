import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class TriPeaksDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new TriPeaksSettings(), new TriPeaksMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onTap(clickEvent) as Boolean {
        var xy = clickEvent.getCoordinates();
        if (moving) { return false; }
        switch (state) {
            case 0:
                // New round
                if (inbox(xy,selXY[0],selWH)) {
                    layout = layout - 1;
                    if (layout < 0) { layout = layouts.size()-1; }
                    savegame();
                    WatchUi.requestUpdate();
                    return true;
                }
                if (inbox(xy,selXY[1],selWH)) {
                    layout = (layout + 1) % layouts.size();
                    savegame();
                    WatchUi.requestUpdate();
                    return true;
                }
                if (inbox(xy,themeXY,themeWH)) {
                    theme = Storage.getValue("theme");
                    if (theme == null) { theme = 0; }
                    theme = (theme + 1) % themes.size();
                    Storage.setValue("theme",theme);
                    WatchUi.requestUpdate();
                    return true;
                }
                if (inbox(xy,bgXY,bgWH)) {
                    background = Storage.getValue("background");
                    if (background == null) { background = 0; }
                    background = (background + 1) % backgrounds.size();
                    Storage.setValue("background",background);
                    WatchUi.requestUpdate();
                    return true;
                }
                if (inbox(xy,startXY,startWH)) {
                    tmp = 1 - scale;
                    if (animation == 0) { tmp2 = tmp/5; }
                    else if (animation == 1) { tmp2 = tmp/3; }
                    else { tmp2 = tmp; }
                    path = [];
                    for (var i=scale+tmp2;i<=1;i+=tmp2) {
                        path.add(i);
                    }
                    zooming = true;
                    savegame();
                    WatchUi.requestUpdate();
                    return true;
                }
                break;
            case 1:
                // Playing
                for (var i=0;i<boardXY.size();i++) {
                    if (board[i][1]) {
                        if (inbox(xy,[boardXY[i][0]+gridXY[0],boardXY[i][1]+gridXY[1]],cardWH)) {
                            tmp = play(i);
                            if (tmp) {
                                savegame();
                                WatchUi.requestUpdate();
                                return true;
                            }
                            return false;
                        }
                    }
                }
                if (inbox(xy,deckXY,cardWH) and deck.size() > 0) {
                    deal();
                    WatchUi.requestUpdate();
                    savegame();
                    return true;
                }
                if (inbox(xy,newXY,newWH)) {
                    newgame();
                    WatchUi.requestUpdate();
                    return true;
                }
                break;
            case 2:
                // No more moves
                if (inbox(xy,newXY,newWH)) {
                    addstats();
                    newgame();
                    WatchUi.requestUpdate();
                    return true;
                }
                break;
            case 3:
                // Winner
                if (inbox(xy,newXY,newWH)) {
                    addstats();
                    newgame();
                    WatchUi.requestUpdate();
                    return true;
                }
                break;
        }
        return false;
    }

    // Check if a point is within a box
    // boxxy = [x,y] coordinates of center of box
    // boxwh = [w,h] width and height of box
    // point = [x,y] coordinates of point to check
    function inbox(point,boxxy,boxwh) as Boolean {
        var bx = boxxy[0]-boxwh[0]/2;
        var by = boxxy[1]-boxwh[1]/2;
        if (point[0]<bx) {return false;}
        if (point[0]>bx+boxwh[0]) {return false;}
        if (point[1]<by) {return false;}
        if (point[1]>by+boxwh[1]) {return false;}
        return true;
    }
}
