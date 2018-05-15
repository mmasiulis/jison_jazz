const parser = require('./interpreterSource.js').parser;
const Transpiler = require('./generator.js');
const fs = require('fs');

const exec = require('pkg').exec;


if (process.argv[2]) {
	const fileName = process.argv[2];

	const ext = fileName.split('.');

	if (ext.length > 0 && ext[ext.length - 1] === 'sj') {
		const data = fs.readFileSync(fileName, 'utf-8');
		const AST = parser.parse(data);
		// console.log(JSON.stringify(AST))
		const code = Transpiler.getJSCode(AST);
		fs.writeFileSync(fileName + '.js', code);

		exec([`${fileName}.js`, '--target', 'host', '--output', `${fileName.split('.')[0]}.exe`]);

	} else {
		console.log('File must have sj extension');
	}
} else {
	console.log('You must specify a file');
}