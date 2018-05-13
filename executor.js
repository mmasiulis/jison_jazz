var parser = require('./parser.js');

function exec (input) {
  return parser.parse(input);
}

var twenty = exec("4 * 5");