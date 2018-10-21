package shooter;

import pongo.ecs.Component;

class Enemy implements Component
{
    var color :Int;
    var health :Int;
    var direction :Int;
    var speed :Float;
}