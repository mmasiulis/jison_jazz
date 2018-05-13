var fs = require("fs");
var jison = require("jison");

var bnf = fs.readFileSync("grammar.jison", "utf8");
var parser = new jison.Parser(bnf);
var source = parser.generate();

fs.writeFile("./interpreterSource.js", source, function(err) {
  if(err) {
    return console.log(err);
  }

  console.log("Interpreter source was saved!");
});