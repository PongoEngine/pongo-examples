let fs = require('fs');
let path = require('path');
let project = new Project('rainy shmup');
project.addDefine('HXCPP_API_LEVEL=332');
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/osx');
await project.addProject('build/osx-build');
await project.addProject('/Users/jack/Desktop/pongo-examples/shooter/Kha');
if (fs.existsSync(path.join('Libraries/Pongo', 'korefile.js'))) {
	await project.addProject('Libraries/Pongo');
}
resolve(project);
