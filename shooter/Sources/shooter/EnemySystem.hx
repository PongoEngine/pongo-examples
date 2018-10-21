package shooter;

import pongo.ecs.Entity;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;

class EnemySystem implements System
{
    public function new(enemies :SourceGroup) : Void
    {
        _enemies = enemies;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _enemies.iterate(function(entity :Entity) {
            var body :Body = entity.getComponent(Body);

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
                entity.visual.rotation = body.rotation;
            }
        });
    }

    private var _enemies :SourceGroup;
}