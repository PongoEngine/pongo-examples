package shooter;

import pongo.Pongo;
import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;

class CameraSystem implements System
{
    public function new(pongo :Pongo, cameras :SourceGroup, heroes :SourceGroup) : Void
    {
        _cameras = cameras;
        _heroes = heroes;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _heroes.changed.iterate(function(hero :Entity) {
            if(_cameras.first() != null) {
                var heroBody :Body = hero.getComponent(Body);
                _cameras.first().visual.x = -heroBody.x + pongo.width/2;
                _cameras.first().visual.y =  -heroBody.y + pongo.height/2 + 100;
            }
        });
    }

    private var _cameras :SourceGroup;
    private var _heroes :SourceGroup;
}