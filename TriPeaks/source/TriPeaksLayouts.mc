import Toybox.Math;

var layouts = ["Pile", "Random", "Original", "Checkers", "Quadrants", "Solitaire", "Eyeball", "Tiger", "Tie Fighter", "Heart", "Taj Mahal", "Stacks?"];
var layout = 2;

function getlayout() {
    // Position cards using x,y from 0 to 100 representing card center positions
    // Cards are 20 x 32
    // grid is 6 cards wide by about 4 cards tall
    // wholes: every 20  x  0,32,64,96 / 2,34,66,98
    boardXY = [];
    board = [];
    if (layouts[layout].equals("Pile")) {
        // Pile
        for (var i=0;i<20;i++) {
            tmp = (Math.rand() % 50) + (Math.rand() % 50);
            tmp2 = (Math.rand() % 50) + (Math.rand() % 50);
            addcard(tmp,tmp2);
        }
    } else if (layouts[layout].equals("Random")) {
        // Random
        for (var i=0;i<25;i++) {
            tmp = Math.rand() % 100;
            tmp2 = Math.rand() % 100;
            addcard(tmp,tmp2);
        }
    } else if (layouts[layout].equals("Original")) {
        // Original
        addcard(50,2);
        addcard(40,18);
        addcard(60,18);
        addcard(30,34);
        addcard(50,34);
        addcard(70,34);
        addcard(50,10);
        addcard(40,26);
        addcard(60,26);

        addcard(20,66);
        addcard(10,82);
        addcard(30,82);
        addcard(0,98);
        addcard(20,98);
        addcard(40,98);
        addcard(20,74);
        addcard(10,90);
        addcard(30,90);

        addcard(80,66);
        addcard(70,82);
        addcard(90,82);
        addcard(60,98);
        addcard(80,98);
        addcard(100,98);
        addcard(80,74);
        addcard(70,90);
        addcard(90,90);
    } else if (layouts[layout].equals("Quadrants")) {
        // Quadrants
        for (var x=0;x<101;x+=20) {
            for (var y=2;y<100;y+=32) {
                addcard(x,y);
            }
        }
        for (var x=10;x<100;x+=60) {
            for (var y=10;y<100;y+=64) {
                addcard(x,y);
                addcard(x+20,y);
                addcard(x+10,y);
            }
        }
    } else if (layouts[layout].equals("Eyeball")) {
        // Eyeball
        addcard(50,9);      // top
        addcard(36,11);      // counter-clockwise
        addcard(25,16);
        addcard(13,25);
        addcard(5,34);      // almost left

        addcard(63,11);      // almost top
        addcard(75,16);
        addcard(87,25);
        addcard(95,34);     // almost right

        addcard(50,91);    // bottom
        addcard(36,89);     // clockwise
        addcard(25,84);
        addcard(13,75);
        addcard(5,66);      // almost left

        addcard(64,89);     // almost bottom
        addcard(75,84);
        addcard(87,75);
        addcard(95,66);     // almost right

        addcard(0,50);      // left
        addcard(100,50);    // right

        addcard(40,50);     // middle bits
        addcard(60,50);
        addcard(50,50);
    } else if (layouts[layout].equals("Tie Fighter")) {
        // Tie Fighter
        // Supports to cockpit
        addcard(10,50);
        addcard(90,50);
        addcard(20,50);
        addcard(80,50);
        addcard(30,55);
        addcard(30,45);
        addcard(70,55);
        addcard(70,45);
        addcard(40,60);
        addcard(40,40);
        addcard(60,60);
        addcard(60,40);
        addcard(50,50);

        // left wing
        addcard(0,50);
        addcard(0,66);
        addcard(0,34);
        addcard(0,82);
        addcard(0,18);
        addcard(0,98);
        addcard(0,2);

        // right wing
        addcard(100,50);
        addcard(100,66);
        addcard(100,34);
        addcard(100,82);
        addcard(100,18);
        addcard(100,98);
        addcard(100,2);
    } else if (layouts[layout].equals("Solitaire")) {
        // Solitaire
        addcard(8,0);
        addcard(36,0);
        addcard(64,0);
        addcard(92,0);
        tmp = [1,2,3,4,5,6];
        for (var i=0;i<6;i++) {
            for (var j=0;j<tmp[i];j++) {
                addcard(i*20,j*12+38);
            }
        }
    } else if (layouts[layout].equals("Heart")) {
        // Heart

        // small heart
        addcard(30,24);
        addcard(70,24);
        addcard(40,48);
        addcard(60,48);
        addcard(50,64);

        // left edge going down
        addcard(20,52);
        addcard(30,68);
        addcard(40,84);

        // right edge going down
        addcard(80,52);
        addcard(70,68);
        addcard(60,84);

        // top left to middle
        addcard(20,0);
        addcard(10,36);
        addcard(10,4);
        addcard(30,4);
        addcard(40,12);
        addcard(0,20);

        // top right to middle
        addcard(80,0);
        addcard(90,36);
        addcard(70,4);
        addcard(90,4);
        addcard(60,12);
        addcard(100,20);

        // top and bottom middle
        addcard(50,20);
        addcard(50,96);
    } else if (layouts[layout].equals("Checkers")) {
        // Checkers
        for (var x=16;x<=100;x+=33) {
            for (var y=26;y<=100;y+=48) {
                addcard(x,y);
            }
        }
        for (var x=0;x<=100;x+=33) {
            for (var y=2;y<=100;y+=48) {
                addcard(x,y);
            }
        }
        for (var x=16;x<=100;x+=33) {
            for (var y=26;y<=100;y+=48) {
                addcard(x,y);
            }
        }
    } else if (layouts[layout].equals("Stacks?")) {
        // Random Stacks
        var h = [2,3,4,5,6,7];
        for (var i=0;i<100;i++) {
            tmp = Math.rand() % 6;
            tmp2 = Math.rand() % 6;
            tmp3 = h[tmp];
            h[tmp] = h[tmp2];
            h[tmp2] = tmp3;
        }

        for (var i=0;i<h[0];i++) {
            addcard(30,14);
        }
        for (var i=0;i<h[1];i++) {
            addcard(50,0);
        }
        for (var i=0;i<h[2];i++) {
            addcard(70,14);
        }
        for (var i=0;i<h[4];i++) {
            addcard(50,60);
        }
        for (var i=0;i<h[3];i++) {
            addcard(70,46);
        }
        for (var i=0;i<h[5];i++) {
            addcard(50,100);
        }
    } else if (layouts[layout].equals("Taj Mahal")) {
        // Taj Mahal
        // back towers
        for (var y=82;y>=10;y-=16) {
            addcard(10,y);
            addcard(90,y);
        }
        // front towers
        for (var y=98;y>=20;y-=16) {
            addcard(0,y);
            addcard(100,y);
        }

        // main building
        addcard(30,90);
        addcard(50,95);
        addcard(70,90);
        addcard(35,60);
        addcard(65,60);
        addcard(50,65);
        addcard(40,35);
        addcard(60,35);
    } else if (layouts[layout].equals("Tiger")) {
        // Tiger
        // left ear
        addcard(10,34);
        addcard(30,16);
        addcard(15,16);
        addcard(15,2);

        // right ear
        addcard(90,34);
        addcard(70,16);
        addcard(85,16);
        addcard(85,2);

        // left side
        addcard(20,82);
        addcard(10,66);
        addcard(5,50);

        // right side
        addcard(80,82);
        addcard(90,66);
        addcard(95,50);

        //bottom of face
        addcard(30,94);
        addcard(70,94);
        addcard(40,98);
        addcard(60,98);
        addcard(50,98);


        //middle of face
        addcard(50,30);
        addcard(30,54);
        addcard(70,54);
        addcard(40,58);
        addcard(60,58);
        addcard(50,54);
    }
}

function addcard(x,y) {
    boardXY.add([SW*x/200,SH*y/200]);
    board.add(["",false]);
}
