package breakers;

import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;

import pongo.ecs.Entity;

class DeadBallSystem implements System
{
    public function new(deadBalls :SourceGroup) : Void
    {
        _deadBalls = deadBalls;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _deadBalls.iterate(function(entity :Entity) {
            trace("dipose ball");
            entity.dispose();
        });
    }

    private var _deadBalls :SourceGroup;
}