package shooter;

import pongo.ecs.group.ReactiveGroup;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.Group;
import pongo.Pongo;

import pongo.ecs.Entity;
import kha.input.KeyCode;
using pongo.math.CMath;

class HeroSystem implements System
{
    public function new(pongo :Pongo, heroes :SourceGroup) : Void
    {
        _heroes = heroes;
        _isDown = false;
        _isUp = false;
        _isLeft = false;
        _isRight = false;

        pongo.keyboard.down.connect(function(key :KeyCode) {
            switch key {
                case KeyCode.Up: _isDown = false; _isUp = true;
                case KeyCode.Down: _isDown = true; _isUp = false;
                case KeyCode.Left: _isLeft = true; _isRight = false;
                case KeyCode.Right: _isLeft = false; _isRight = true;
                case _:
            }
        });

        pongo.keyboard.up.connect(function(key :KeyCode) {
            switch key {
                case KeyCode.Up: _isUp = false;
                case KeyCode.Down: _isDown = false;
                case KeyCode.Left: _isLeft = false;
                case KeyCode.Right: _isRight = false;
                case _:
            }
        });
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _heroes.iterate(function(entity :Entity) {
            var body :Body = entity.getComponent(Body);
            body.veloX = _isRight ? 900 : _isLeft ? -900 : 0;
            body.veloY = _isDown ? 900 : _isUp ? -900 : 0;

            var nX = body.x + body.veloX * dt;
            var nY = CMath.clamp(body.y + body.veloY * dt, 0, pongo.height);
            body.rotation = CMath.angle(body.x, body.y, nX, nY).toDegrees();
            body.x = nX;
            body.y = nY;

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
                entity.visual.rotation = body.rotation;
            }
        });
    }

    private var _heroes :SourceGroup;
    private var _isDown :Bool;
    private var _isUp :Bool;
    private var _isLeft :Bool;
    private var _isRight :Bool;
}