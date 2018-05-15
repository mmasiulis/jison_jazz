# jison_jazz
Some jazz code with jison parser

### Pre-requisites
* Latest node version (8.11.1 recommended)

### How to run
* Open console in root folder
* If it's the first time running the project, type npm i 
* To get executable, run ```npm run pack``` 
* For testing, use ```npm test```

### Language example
```
MAIN (
  var counter <= 0
  var a <= 0
  var b <= 1

  FOOOR yay
    var tmp <= b
    => tmp Is tmp + a;
    => a Is b;
    => b Is tmp;
    Scream tmp
    => counter Is counter + 1;
    
    If counter > 6
      Fin
    Fi
  TADAAA
) ;A
```
