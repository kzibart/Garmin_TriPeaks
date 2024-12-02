import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Application.Storage;

function addstats() as Void {
    loadgame();
    stats = Storage.getValue("stats");
//stats = null;
    if (stats == null) {
        // wins 5+ left in deck, 4, 3, 2, 1, 0, loss 1 card left on board, 2, 3, 4, 5+
        stats = [0,0,0,0,0,0,0,0,0,0,0];
    }
    if (deck.size() >= 5) {
        stats[0]++;
    } else if (deck.size() == 4) {
        stats[1]++;
    } else if (deck.size() == 3) {
        stats[2]++;
    } else if (deck.size() == 2) {
        stats[3]++;
    } else if (deck.size() == 1) {
        stats[4]++;
    } else if (board.size() == 0) {
        stats[5]++;
    } else if (board.size() == 1) {
        stats[6]++;
    } else if (board.size() == 2) {
        stats[7]++;
    } else if (board.size() == 3) {
        stats[8]++;
    } else if (board.size() == 4) {
        stats[9]++;
    } else {
        stats[10]++;
    }
    Storage.setValue("stats",stats);
}

function showstats() {
    if (!(Toybox.WatchUi has :CustomMenu)) { return; }
    stats = Storage.getValue("stats");
    if (stats == null) { return; }
    var menu;
    var labels = ["Win 5+","Win 4","Win 3","Win 2","Win 1","Win 0","Lose 1","Lose 2","Lose 3","Lose 4","Lose 5+"];
    var total = 0;
    var max = 0;
    for (var i=0;i<stats.size();i++) {
        if (stats[i] > max) { max = stats[i]; }
        total += stats[i];
    }
    menu = new WatchUi.CustomMenu(45, Graphics.COLOR_BLACK,{
        :title => new $.DrawableMenuTitle(),
        :titleItemHeight => 100
    });
    for (var i=0;i<stats.size();i++) {
        menu.addItem(new $.CustomItem(i,labels[i],stats[i],total,max));
    }
    WatchUi.pushView(menu, new $.TriPeaksStatsDelegate(), WatchUi.SLIDE_UP);
    WatchUi.requestUpdate();
}

class TriPeaksStatsDelegate extends WatchUi.Menu2InputDelegate {
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item as MenuItem) {
        return;
    }

    public function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class DrawableMenuTitle extends WatchUi.Drawable {
    public function initialize() {
        Drawable.initialize({});
    }
    
    public function draw(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        dc.setColor(0x000000,0x000000);
        dc.clear();
        dc.setColor(0xffffff,-1);
        dc.drawText(w/2,h*45/100,Graphics.FONT_SMALL,"Statistics",center);
        dc.drawText(w/2,h*80/100,Graphics.FONT_XTINY,"/",center);
        dc.setColor(Graphics.COLOR_GREEN,-1);
        dc.drawText(w/2-15,h*80/100,Graphics.FONT_XTINY,"Deck Left",right);
        dc.setColor(Graphics.COLOR_RED,-1);
        dc.drawText(w/2+15,h*80/100,Graphics.FONT_XTINY,"Cards Left",left);
        dc.setColor(0xffffff,-1);
        dc.setPenWidth(3);
        dc.drawLine(0,h-1,w,h-1);
    }
}

class CustomItem extends WatchUi.CustomMenuItem {
    private var _id as Number;
    private var _label as String;
    private var _count as Number;
    private var _total as Number;
    private var _max as Number;

    public function initialize(id as Number, label as String, count as Number, total as Number, max as Number) {
        CustomMenuItem.initialize(id, {});
        _id = id;
        _label = label;
        _count = count;
        _total = total;
        _max = max;
    }

    public function draw(dc as Dc) as Void {
        // Fill background horizontally based on percentage
        var w = dc.getWidth();
        var h = dc.getHeight();
        var bx = w/8;
        var bw = w*6/8;
        var lx = bx;
        var cx = (w*.65).toNumber();
        var px = bx+bw;
        var pct = (_count*1.0/_total*100).toNumber();
        var mpct = (_max*1.0/_total*100).toNumber();
        mpct = 1-((mpct-pct)*1.0/mpct);
        dc.setColor(Graphics.COLOR_DK_GRAY,-1);
        dc.fillRectangle(bx,0,(bw*mpct).toNumber(),h);
        if (_id <= 5) { dc.setColor(Graphics.COLOR_GREEN,-1); }
        else { dc.setColor(Graphics.COLOR_RED,-1); }
        dc.drawText(lx,h/2,Graphics.FONT_TINY,_label,Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_BLUE,-1);
        dc.drawText(cx,h/2,Graphics.FONT_TINY,_count,Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_YELLOW,-1);
        dc.drawText(px,h/2,Graphics.FONT_TINY,pct+"%",Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
