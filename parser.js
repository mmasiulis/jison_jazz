const fs = require("fs");
const jison = require("jison");

const bnf = fs.readFileSync("grammar.jison", "utf8");
const parser = new jison.Parser(bnf);
const source = parser.generate();

fs.writeFile("./interpreterSource.js", source, function(err) {
  if(err) {
    return console.log(err);
  }

  console.log("Interpreter source was saved!");
});