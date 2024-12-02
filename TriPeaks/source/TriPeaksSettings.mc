import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Graphics;

class TriPeaksMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    public function onSelect(item as MenuItem) {
        switch (item.getId()) {
            case "theme":
                theme = (theme + 1) % themes.size();
                Storage.setValue("theme",theme);
                item.setSubLabel(themes[theme]);
                break;
            case "suitcolor":
                suitcolor = (suitcolor + 1) % suitcolors.size();
                Storage.setValue("suitcolor",suitcolor);
                item.setSubLabel(suitcolors[suitcolor]);
                break;
            case "background":
                background = (background + 1) % backgrounds.size();
                Storage.setValue("background",background);
                item.setSubLabel(backgrounds[background]);
                break;
            case "animation":
                animation = (animation + 1) % animations.size();
                Storage.setValue("animation",animation);
                item.setSubLabel(animations[animation]);
                break;
            case "deckpos":
                deckpos = (deckpos + 1) % deckposs.size();
                Storage.setValue("deckpos",deckpos);
                item.setSubLabel(deckposs[deckpos]);
                break;
            case "stats":
                showstats();
                break;
        }
    }

    public function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}

class TriPeaksSettings extends WatchUi.Menu2 {
    public function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");

        var themeicon = new $.CustomIcon(theme);
        var scicon = new $.CustomIcon(suitcolor);
        var bgicon = new $.CustomIcon(background);
        var anicon = new $.CustomIcon(animation);
        var dpicon = new $.CustomIcon(deckpos);
        var statsicon = new $.CustomIcon(0);

        Menu2.addItem(new WatchUi.IconMenuItem("Theme", themes[theme], "theme", themeicon, null));
        Menu2.addItem(new WatchUi.IconMenuItem("Suit Colors", suitcolors[suitcolor], "suitcolor", scicon, null));
        Menu2.addItem(new WatchUi.IconMenuItem("Background", backgrounds[background], "background", bgicon, null));
        Menu2.addItem(new WatchUi.IconMenuItem("Animations", animations[animation], "animation", anicon, null));
        Menu2.addItem(new WatchUi.IconMenuItem("Deck Position", deckposs[deckpos], "deckpos", dpicon, null));
        Menu2.addItem(new WatchUi.IconMenuItem("Stats", "Show statistics", "stats", statsicon, null));
    }
}

class CustomIcon extends WatchUi.Drawable {
    private var _index as Number;

    public function initialize(index as Number) {
        _index = index;
        Drawable.initialize({});
    }

    public function draw(dc as Dc) as Void {
        dc.setColor(-1,-1);
        dc.clear();
    }
}
