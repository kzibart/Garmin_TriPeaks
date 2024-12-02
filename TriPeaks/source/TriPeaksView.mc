import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Application.Storage;
import Toybox.Timer;

var DS = System.getDeviceSettings();
var SW = DS.screenWidth;
var SH = DS.screenHeight;
var centerX = SW/2;
var centerY = SH/2;
var center = Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER;
var left = Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER;
var right = Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER;

var game,state,deck,board,card;
var gamehist,lastgame,stats;
var titleXY,layoutnameXY,resultXY;
var bgXY,bgWH,themeXY,themeWH,selXY,selWH;
var gridXY,gridWH;
var startXY,startWH;
var boardXY,deckXY,cardXY,cardWH,cardR;
var newXY,newWH,buttonR;
var solid,shadow,so,soh;
var mydc,tmp,tmp2,tmp3,tmp4;
var moving,zooming,path,timer;
var bigfont = Graphics.FONT_SMALL;
var smallfont = Graphics.FONT_TINY;
var buttonfont = Graphics.FONT_XTINY;
var scale = 0.60;

var themes = ["Outlines", "Outlines with shadows", "Solids", "Solids with shadows"];
var theme = 2;
var suitcolors = ["Standard", "Four Colors"];
var suitcolor = 0;
var backgrounds = ["Green", "Blue", "Red", "Black"];
var bgcolors = [0x204020, 0x006374, 0x7f2019, 0x000000];
var background = 0;
var animations = ["Slow", "Fast", "Instant"];
var animation = 1;
var deckposs = ["Right", "Left"];
var deckpos = 0;

var titlecolor = 0xf4c223;
var buttoncolor = 0xec6a6a;
var startcolor = 0xf4c223;
var wincolor = 0x27c235;
var losecolor = 0xcc5c5c;
var newcolor = 0xf4c223;
var deckcolor = 0x56bfec;
var scolors,ocolors;
var backcolor = 0xe6e3de;
var platecolor = 0x80744d;
var bgcolor;
// grays
var valcolor = 0xaaaaaa;
var shadowcolor = 0x333333;
var nopecolor = 0x808080;

var suitF,suitH,suitA,suitD;

class TriPeaksView extends WatchUi.View {

    function initialize() {
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        cardWH = [SW*10/100,SH*16/100];
        cardR = cardWH[0]*12/100;
        buttonR = cardR*2;
        zooming = false;

        so = SW*1/100;
        soh = so/2;

        // All XY values are centers
        // State 0 locations
        titleXY = [SW/2,SH*10/100];

        gridXY = [SW*25/100,SW*25/100];
        gridWH = [SW*50/100,SW*50/100];

        selXY = [
            [SW*18/100,SH*60/100],
            [SW*82/100,SH*60/100]
        ];
        selWH = [SH*14/100,SH*13/100];
        layoutnameXY = [SW*50/100,SH*60/100];

        themeXY = [SW*26/100,SH*75/100];
        themeWH = [SW*30/100,SH*13/100];
        bgXY = [SW*66/100,SH*75/100];
        bgWH = [SW*46/100,SH*13/100];

        startXY = [SW/2,SH*90/100];
        startWH = [SW*30/100,SH*13/100];

        // State 1+ locations
        resultXY = [SW/2,SH*50/100];
        newXY = [SW*50/100,SH*90/100];
        newWH = [SW*30/100,SH*13/100];

        moving = false;
        zooming = false;
        path = [];

        // Load card font based on screen size
        if (SW < 270) { 
            suitF = WatchUi.loadResource(Rez.Fonts.suits20);
//            sh = 5;
        }
        else if (SW < 360) { 
            suitF = WatchUi.loadResource(Rez.Fonts.suits30); 
//            sh = 8;
        }
        else if (SW < 390) { 
            suitF = WatchUi.loadResource(Rez.Fonts.suits35); 
//            sh = 9;
        }
        else {
            suitF = WatchUi.loadResource(Rez.Fonts.suits40);
//            sh = 12;
        }
        suitH = Graphics.getFontHeight(suitF);
        suitA = suitH*29/100;
        suitD = suitH*42/100;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        mydc = dc;

        theme = Storage.getValue("theme");
        if (theme == null) { theme = 2; Storage.setValue("theme",theme); }
        switch (theme) {
            case 0:
                solid = false;
                shadow = false;
                break;
            case 1:
                solid = false;
                shadow = true;
                break;
            case 2:
                solid = true;
                shadow = false;
                break;
            case 3:
                solid = true;
                shadow = true;
                break;
        }

        background = Storage.getValue("background");
        if (background == null) { background = 0; Storage.setValue("background",background); }
        bgcolor = bgcolors[background];

        animation = Storage.getValue("animation");
        if (animation == null) { animation = 1; Storage.setValue("animation",animation); }

        suitcolor = Storage.getValue("suitcolor");
        if (suitcolor == null) { suitcolor = 0; Storage.setValue("suitcolor",suitcolor); }
        // spades, clubs, diamonds, hearts
        switch (suitcolor) {
            case 0:
                scolors = [0x202020, 0x202020, 0xbe4b4b, 0xbe4b4b];
                ocolors = [0xffffff, 0xffffff, 0xbe4b4b, 0xbe4b4b];
                break;
            case 1:
                scolors = [0x202020, 0x33ac30, 0x5855fe, 0xbe4b4b];
                ocolors = [0xffffff, 0x33ac30, 0x5855fe, 0xbe4b4b];
                break;
        }

        deckpos = Storage.getValue("deckpos");
        if (deckpos == null) { deckpos = 0; Storage.setValue("deckpos",deckpos); }
        if (deckpos == 0) {
            deckXY = [SW*90/100,SH*50/100];
            cardXY = [SW*10/100,SH*50/100];
        } else {
            deckXY = [SW*10/100,SH*50/100];
            cardXY = [SW*90/100,SH*50/100];
        }

        // Load game
        if (!moving) {
            loadgame();
        }

        mydc.setColor(bgcolor,bgcolor);
        mydc.clear();

        drawlabel(titleXY,"Tri Peaks",titlecolor,true,false);

        switch (state) {
            case 0:
                // New round
                if (!zooming) {
                    getlayout();

                    drawboard(scale);

                    drawlabel(layoutnameXY,layouts[layout],newcolor,false,false);

                    drawbutton(themeXY,themeWH,"Theme",buttoncolor,true);
                    drawbutton(bgXY,bgWH,"Background",buttoncolor,true);

                    drawbutton(selXY[0],selWH,"<",buttoncolor,true);
                    drawbutton(selXY[1],selWH,">",buttoncolor,true);
                }

                drawbutton(startXY,startWH,"Start",startcolor,true);
                break;
            case 1:
                drawlabel(titleXY,"Tri Peaks",titlecolor,true,false);

                drawboard(1);

                drawplate(deckXY);
                drawcard(deckXY,deck.size());
                drawplate(cardXY);
                drawcard(cardXY,card);

                drawbutton(newXY,newWH,"New",newcolor,true);

// Grid boundaries for debugging
//mydc.setColor(0xffffff,-1);
//mydc.drawRectangle(gridXY[0]-cardWH[0]/2,gridXY[1]-cardWH[1]/2,gridWH[0]+cardWH[0],gridWH[1]+cardWH[1]);
                break;
            case 2:
                // No more moves
                drawboard(1);

                drawcard(deckXY,deck.size());
                drawcard(cardXY,card);

                drawbutton(newXY,newWH,"New",newcolor,true);

                drawlabel(resultXY,"Out of Moves",losecolor,true,true);

                drawbutton(newXY,newWH,"New",newcolor,true);
                break;
            case 3:
                // Game won
                drawboard(1);

                drawcard(deckXY,deck.size());
                drawcard(cardXY,card);

                drawbutton(newXY,newWH,"New",newcolor,true);

                drawlabel(resultXY,"You won!",wincolor,true,true);

                drawbutton(newXY,newWH,"New",newcolor,true);
                break;
        }

        if (zooming) {
            drawboard(path[0]);
            path = path.slice(1,null);
            if (path.size() == 0) {
                path = [];
                state = 1;
                firstdeal();
                savegame();
                zooming = false;
            }
            timer = new Timer.Timer();
            timer.start(method(:onTimer), 50, false);
        }

        if (moving) {
            var lastmove = true;
            for (var i=0;i<path.size();i++) {
                tmp = path[i][1];
                if (tmp.size() > 0) {
                    if (tmp.size() == 1) {
                        card = path[i][0];
                    } else {
                        lastmove = false;
                    } 
                    path[i][1] = path[i][1].slice(1,null);
                    tmp = tmp[0];
                    drawcard(tmp,path[i][0]);
                }
            }
            if (lastmove) {
                flipcards();
                path = [];
                moving = false;
                savegame();
            }
            if (board.size() <= 10) {
                timer = new Timer.Timer();
                timer.start(method(:onTimer), 50, false);
            } else {
                onTimer();
            }
        }
    }

    function onTimer() as Void {
        WatchUi.requestUpdate();
    }

    function drawplate(xy) {
        var extra = cardWH[0]*15/100;
        var x = xy[0]-cardWH[0]/2-extra;
        var y = xy[1]-cardWH[1]/2-extra;
        var w = cardWH[0]+extra+extra;
        var h = cardWH[1]+extra+extra;
        var r = cardR*150/100;
        if (solid) {
            if (shadow) {
                mydc.setColor(shadowcolor,-1);
                mydc.fillRoundedRectangle(x+so, y+so, w, h, r);
            }
            mydc.setColor(platecolor,-1);
            mydc.fillRoundedRectangle(x, y, w, h, r);
        } else {
            if (shadow) {
                mydc.setColor(shadowcolor,-1);
                mydc.drawRoundedRectangle(x+so, y+so, w, h, r);
            }
            mydc.setColor(platecolor,-1);
            mydc.drawRoundedRectangle(x, y, w, h, r);

        }
    }

    function drawlabel(xy,text,col,big,bg) {
        if (big) { tmp = bigfont; }
        else { tmp = smallfont; }
        if (shadow) {
            if (bg) {
                mydc.setColor(shadowcolor,bgcolor);
            } else {
                mydc.setColor(shadowcolor,-1);
            }
            mydc.drawText(xy[0]+so, xy[1]+so, tmp, text, center);
        }
        if (bg and !shadow) {
            mydc.setColor(col,bgcolor);
        } else {
            mydc.setColor(col,-1);
        }
        mydc.drawText(xy[0], xy[1], tmp, text, center);
    }

    function drawbutton(xy,wh,text,col,valid) {
        var x = xy[0]-wh[0]/2;
        var y = xy[1]-wh[1]/2;
        var w = wh[0];
        var h = wh[1];
        if (solid) {
            if (shadow) {
                mydc.setColor(shadowcolor,-1);
                mydc.fillRoundedRectangle(x+so, y+so, w, h, buttonR);
            }
            if (valid) {
                mydc.setColor(col,-1);
            } else {
                mydc.setColor(nopecolor,-1);
            }
            mydc.fillRoundedRectangle(x, y, w, h, buttonR);
            if (shadow) {
                mydc.setColor(Graphics.COLOR_LT_GRAY,-1);
                mydc.drawText(xy[0]-soh, xy[1]-soh, buttonfont, text, center);
            }
            mydc.setColor(Graphics.COLOR_BLACK,-1);
            mydc.drawText(xy[0], xy[1], buttonfont, text, center);
        } else {
            if (shadow) {
                mydc.setColor(shadowcolor,-1);
                mydc.drawRoundedRectangle(x+so, y+so, w, h, buttonR);
                mydc.drawText(xy[0]+so, xy[1]+so, buttonfont, text, center);
            }
            if (valid) {
                mydc.setColor(col,-1);
            } else {
                mydc.setColor(nopecolor,-1);
            }
            mydc.drawRoundedRectangle(x, y, w, h, buttonR);
            mydc.drawText(xy[0], xy[1], buttonfont, text, center);
        }
    }

    function drawboard(scale) {
        var x,y,w,h,ox,oy;
        ox = ((gridWH[0]-gridWH[0]*scale)/2).toNumber();
        oy = ((gridWH[1]-gridWH[1]*scale)/2).toNumber();
        for (var i=0;i<boardXY.size();i++) {
            x = (boardXY[i][0]*scale).toNumber()+gridXY[0]+ox;
            y = (boardXY[i][1]*scale).toNumber()+gridXY[0]-oy/2;
            w = (cardWH[0]*scale).toNumber();
            h = (cardWH[1]*scale).toNumber();
            if (board[i][1]) { tmp = board[i][0]; }
            else { tmp = ""; }
            drawcard2([x,y],[w,h],tmp);
        }
    }

    function drawcard(xy, card) {
        drawcard2(xy,cardWH,card);
    }

    function drawcard2(xy,wh,card) {
        if (card == null or card == 0) { return; }
        var sh = shadow;
//        if (moving) { sh = false; }
        var w = wh[0];
        var h = wh[1];
        var x = xy[0]-w/2;
        var y = xy[1]-h/2;
        var fc,tc;
        var l1 = "";
        var l2 = "";
        var other = false;
        card = card.toString();
        if (card.length() == 2) {
            l1 = card.substring(0,1);
            l2 = card.substring(1,2);
        } else {
            l1 = card;
        }
        switch (l2) {
            case "s":
                fc = backcolor;
                if (solid) { tc = scolors[0]; }
                else { tc = ocolors[0]; }
                break;
            case "c":
                fc = backcolor;
                if (solid) { tc = scolors[1]; }
                else { tc = ocolors[1]; }
                break;
            case "d":
                fc = backcolor;
                if (solid) { tc = scolors[2]; }
                else { tc = ocolors[2]; }
                break;
            case "h":
                fc = backcolor;
                if (solid) { tc = scolors[3]; }
                else { tc = ocolors[3]; }
                break;
            default:
                other = true;
                fc = deckcolor;
                if (solid) { tc = Graphics.COLOR_BLACK; }
                else { tc = Graphics.COLOR_WHITE; }
                break;
        }

        // Draw card shape
        if (solid) {
            if (sh) {
                mydc.setColor(shadowcolor,-1);
                mydc.fillRoundedRectangle(x+so, y+so, w, h, cardR);
            }
            mydc.setColor(fc,-1);
            mydc.fillRoundedRectangle(x, y, w, h, cardR);
            mydc.setColor(Graphics.COLOR_DK_GRAY,-1);
            mydc.setPenWidth(2);
            mydc.drawRoundedRectangle(x, y, w, h, cardR);
            if (sh) {
                mydc.setColor(Graphics.COLOR_LT_GRAY,-1);
            }
            mydc.setColor(tc,-1);
        } else {
            mydc.setPenWidth(2);
            mydc.setColor(bgcolor,-1);
            mydc.fillRoundedRectangle(x,y,w,h,cardR);
            if (sh) {
                mydc.setColor(shadowcolor,-1);
                mydc.drawRoundedRectangle(x+soh, y+soh, w, h, cardR);
            }
            mydc.setColor(fc,-1);
            mydc.drawRoundedRectangle(x, y, w, h, cardR);
        }

        // Draw card value
        if (other) {
            if (sh) {
                if (solid) {
                    mydc.setColor(Graphics.COLOR_LT_GRAY,-1);
                } else {
                    mydc.setColor(shadowcolor,-1);
                }
                mydc.drawText(xy[0]+soh,xy[1]+soh,smallfont,card,center);
            }
            mydc.setColor(tc,-1);
            mydc.drawText(xy[0],xy[1],smallfont,card,center);
        } else {
            // top left, side by side
            // bottom right, side by side, reverse order?
            var rev = l2+l1;
            if (sh) {
                if (solid) {
                    mydc.setColor(Graphics.COLOR_LT_GRAY,-1);
                } else {
                    mydc.setColor(shadowcolor,-1);
                }
                mydc.drawText(x+3+soh,y+1+suitA+soh,suitF,card,left);
                mydc.drawText(x+w-3+soh,y+h-1-suitD+soh,suitF,rev,right);
            }
            mydc.setColor(tc,-1);
            mydc.drawText(x+3,y+1+suitA,suitF,card,left);
            mydc.drawText(x+w-3,y+h-1-suitD,suitF,rev,right);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}

function newgame() {
    state = 0;
    deck = ["As","2s","3s","4s","5s","6s","7s","8s","9s","Ts","Js","Qs","Ks",
            "Ac","2c","3c","4c","5c","6c","7c","8c","9c","Tc","Jc","Qc","Kc",
            "Ad","2d","3d","4d","5d","6d","7d","8d","9d","Td","Jd","Qd","Kd",
            "Ah","2h","3h","4h","5h","6h","7h","8h","9h","Th","Jh","Qh","Kh"];
    for (var i=0;i<1000;i++) {
        tmp = Math.rand() % 52;
        tmp2 = Math.rand() % 52;
        tmp3 = deck[tmp];
        deck[tmp] = deck[tmp2];
        deck[tmp2] = tmp3;
    }
    boardXY = [];
    board = [];
    savegame();
}

function savegame() as Void {
    if (state == 1 & !moving) {
        var done;
        if (board.size() == 0) {
            done = true;
        } else if (deck.size() == 0) {
            done = true;
            tmp = value(card);
            for (var i=0;i<board.size();i++) {
                if (board[i][1]) {
                    tmp2 = (tmp-value(board[i][0])).abs();
                    if (tmp2 == 1 or tmp2 == 12) {
                        done = false;
                        break;
                    }
                }
            }
        } else { done = false; }
        if (done) {
            if (board.size() == 0) { state = 3; }
            else { state = 2; }
        }
    }

    game = {
        "ver" => 1,
        "state" => state,
        "deck" => deck,
        "boardXY" => boardXY,
        "board" => board,
        "card" => card,
        "layout" => layout
    };
    Storage.setValue("game",game);
}

function loadgame() {
    game = Storage.getValue("game");
//game = null;
    if (game == null) { 
        layout = 2;
        newgame();
    }
    state = game.get("state");
    deck = game.get("deck");
    boardXY = game.get("boardXY");
    board = game.get("board");
    card = game.get("card");
    layout = game.get("layout");
}

function firstdeal() {
    board = [];
    tmp = boardXY.size();
    for (var i=0;i<tmp;i++) {
        board.add([deck[i],false]);
    }
    deck = deck.slice(tmp+1,null);
    card = null;
    deal();
    flipcards();
    savegame();
}

function flipcards() {
    var free,x,y;
    var w = cardWH[0];
    var h = cardWH[1];
    for (var i=0;i<board.size();i++) {
        board[i][1] = true;
        for (var j=i+1;j<board.size();j++) {
            x = (boardXY[j][0]-boardXY[i][0]).abs();
            y = (boardXY[j][1]-boardXY[i][1]).abs();
            if (x < w and y < h) {
                board[i][1] = false;
                break;
            }
        }
    }
}

function deal() as Void {
    var tmp = deck.size();
    if (tmp == 0) { return; }
    path.add([deck[0],calcpath(deckXY,cardXY)]);
    deck = deck.slice(1,null);
    moving = true;
}

function play(s) as Boolean {
    if (!board[s][1]) { return false; }
    tmp = (value(board[s][0])-value(card)).abs();
    if (tmp != 1 and tmp != 12) { return false; }
    path.add([board[s][0],calcpath([boardXY[s][0]+gridXY[0],boardXY[s][1]+gridXY[1]],cardXY)]);

    // remove element s from board and boardXY
    var a = [];
    var b = [];
    for (var i=0;i<board.size();i++) {
        if (i != s) {
            a.add(board[i]);
            b.add(boardXY[i]);
        }
    }
    board = a;
    boardXY = b;
    moving = true;
    return true;
}

function calcpath(xy1,xy2) {
    var x1 = xy1[0];
    var y1 = xy1[1];
    var x2 = xy2[0];
    var y2 = xy2[1];
    var a = [];
    var cells = 1;
    if (animation == 0) {
        cells = 5;
    } else if (animation == 1) {
        cells = 3;
    } else if (animation == 2) {
        cells = 1;
    }
    for (var cell=1;cell<=cells;cell++) {
        a.add([(x1*(cells-cell)/cells+x2*cell/cells),(y1*(cells-cell)/cells+y2*cell/cells)]);
    }
    return a;
}

function value(c as String) as Number {
    // return the value of the given card
    switch (c.substring(0,1)) {
        case "A": return 1;
        case "2": return 2;
        case "3": return 3;
        case "4": return 4;
        case "5": return 5;
        case "6": return 6;
        case "7": return 7;
        case "8": return 8;
        case "9": return 9;
        case "T": return 10;
        case "J": return 11;
        case "Q": return 12;
        case "K": return 13;
    }
    return 0;
}

function commas(whole) {
    if (whole == 0) { return "0"; }
    var digits = [];
    
    var count = 0;
    while (whole != 0) {
        var digit = (whole % 10).toString();
        whole /= 10;
        
        if (count == 3) {
            digits.add(",");
            count = 0;
        }
        ++count;
        
        digits.add(digit);
    }
    
    digits = digits.reverse();
    
    whole = "";
    for (var i = 0; i < digits.size(); ++i) {
        whole += digits[i];
    }

    return whole;
}

function deepcopy(input)
{
    var result = null;

    if (input == null) {
        // do nothing
    }
    if (input instanceof Lang.Array) {
        if (input.size() == 0) { result = []; }
        else {
            result = new [ input.size() ];
            for (var i = 0; i < result.size(); ++i) {
                result[i] = deepcopy(input[i]);
            }
        }
    }
    else if (input instanceof Lang.Dictionary) {
        var keys = input.keys();
        var vals = input.values();

        result = {};
        for (var i = 0; i < keys.size(); ++i) {
            var key_copy = deepcopy(keys[i]);
            var val_copy = deepcopy(vals[i]);
            result.put(key_copy, val_copy);
        }
    }
    else if (input instanceof Lang.String) {
        return input.substring(0, input.length());
    }
//    else if (input instanceof Lang.ByteArray) {
//        result = input.slice(null, null);
//    }
    else if (input instanceof Lang.Long) {
        return 1 * input;
        
    }
    else if (input instanceof Lang.Double) {
        return 1.0 * input;
    }
    else {
        // primitive types (Number/Float/Boolean/Char) are always copied
        result = input;
    }

    return result;
}
