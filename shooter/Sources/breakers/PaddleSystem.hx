package breakers;

import pongo.ecs.group.ReactiveGroup;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.Group;
import pongo.Pongo;
import breakers.Body;

import pongo.ecs.Entity;
import kha.input.KeyCode;
using pongo.math.CMath;

class PaddleSystem implements System
{
    public function new(pongo :Pongo, paddles :SourceGroup) : Void
    {
        _paddles = paddles;
        _isLeft = false;
        _isRight = false;

        pongo.keyboard.down.connect(function(key :KeyCode) {
            switch key {
                case KeyCode.Left: _isLeft = true; _isRight = false;
                case KeyCode.Right: _isLeft = false; _isRight = true;
                case _:
            }
        });

        pongo.keyboard.up.connect(function(key :KeyCode) {
            switch key {
                case KeyCode.Left: _isLeft = false;
                case KeyCode.Right: _isRight = false;
                case _:
            }
        });
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _paddles.iterate(function(entity :Entity) {
            var body :Body = entity.getComponent(Body);
            var velocity = _isRight ? 900 : _isLeft ? -900 : 0;
            body.x = switch body.shape {
                case RECT(width, height):
                    CMath.clamp(body.x + velocity * dt, width/2, pongo.width-width/2);
                case CIRCLE(radius):
                    CMath.clamp(body.x + velocity * dt, radius, pongo.width-radius);
            }
            body.y = body.y;

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
            }
        });
    }

    private var _paddles :SourceGroup;
    private var _isLeft :Bool;
    private var _isRight :Bool;
}