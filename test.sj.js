(function () {
 "use strict";
    (function () {
        var counter = 0;
        var a = 0;
        var b = 1;
        console.log( 'Fibbonachi skaiciai' );
        console.log( a );
        console.log( b );
        while (true) {
            var tmp = b;
            tmp = (tmp + a);
            a = b;
            b = tmp;
            console.log( tmp );
            counter = (counter + 1);
            if (counter > 6) { 
                break;
            } 
        }
    }());
}());