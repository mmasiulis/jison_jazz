const jison = require("jison");
const fs = require('fs');
const bnf = fs.readFileSync("grammar.jison", "utf8");
const parserTruOne = new jison.Parser(bnf);

const source = parserTruOne.generate();

fs.writeFile("./interpreterSource.js", source, function(err) {
	if(err) {
		return console.log(err);
	}

	console.log("Interpreter source was saved!");

	const parser = require('./interpreterSource.js').parser;
	const Transpiler = require('./generator.js');

	if (process.argv[2]) {
		const fileName = process.argv[2];

		const ext = fileName.split('.');

		if (ext.length > 0 && ext[ext.length - 1] === 'sj') {
			const data = fs.readFileSync(fileName, 'utf-8');
			const AST = parser.parse(data);
			console.log(JSON.stringify(AST))
			const code = Transpiler.getJSCode(AST);
			fs.writeFileSync(fileName + '.js', code);
		} else {
			console.log('File must have sj extension');
		}
	} else {
		console.log('You must specify a file');
	}
});

