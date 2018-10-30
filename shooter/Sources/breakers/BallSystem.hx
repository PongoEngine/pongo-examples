package breakers;

import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;
import breakers.Body;

import pongo.ecs.Entity;
using pongo.math.CMath;

class BallSystem implements System
{
    public function new(balls :SourceGroup, paddles :SourceGroup) : Void
    {
        _balls = balls;
        _paddles = paddles;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _balls.iterate(function(entity :Entity) {
            var body :Body = entity.getComponent(Body);
            var ball :Ball = entity.getComponent(Ball);

            if(body.collisionDirection != NONE) {
                switch body.collisionDirection {
                    case LEFT, RIGHT: 
                        ball.velocityX *= -1;
                    case TOP, BOTTOM: 
                        ball.velocityY *= -1;
                    case NONE:
                }
            }
            else {
                body.x = ball.velocityX*dt + body.x;
                body.y = ball.velocityY*dt + body.y;
            }

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
            }
        });
    }

    private var _balls :SourceGroup;
    private var _paddles :SourceGroup;
}