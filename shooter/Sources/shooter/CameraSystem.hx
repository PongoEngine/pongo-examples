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
        if(_cameras.first() == null) return;
        var camera = _cameras.first().getComponent(Camera);

        _heroes.changed.iterate(function(hero :Entity) {
            var heroBody :Body = hero.getComponent(Body);
            camera.x = -heroBody.x + pongo.width/2;

            if(_cameras.first().visual != null) {
                _cameras.first().visual.x = camera.x;
            }
        });
    }

    private var _cameras :SourceGroup;
    private var _heroes :SourceGroup;
}