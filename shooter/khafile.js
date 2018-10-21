let project = new Project('rainy shmup');

project.addLibrary("Pongo");
project.addSources('Sources');
project.addParameter('--connect 6000');
project.addParameter('-dce full');
project.addParameter('-debug');
project.addAssets('Assets/**');

resolve(project);