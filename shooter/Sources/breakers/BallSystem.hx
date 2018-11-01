package breakers;

import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;
import breakers.Body;
import pongo.ecs.group.EntityList;

import pongo.ecs.Entity;
using pongo.math.CMath;

class BallSystem implements System
{
    public function new(balls :SourceGroup) : Void
    {
        _balls = balls;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        trace(_balls.length);
        _balls.iterate(function(entity :Entity) {
            var body :Body = entity.getComponent(Body);
            var ball :Ball = entity.getComponent(Ball);

            if(body.collisionDirection != NONE) {
                switch body.collisionDirection {
                    case LEFT, RIGHT:
                        ball.velocityX *= -1;
                    case TOP, BOTTOM:
                        if(body.collidedWith.isPaddle) {
                            var a = body.x - body.collidedWith.rect.left;
                            var b = body.collidedWith.rect.right - body.collidedWith.rect.left;
                            var percent = ((a / b) - 0.5) * 2;
                            ball.velocityX = 400 * percent;
                        }
                        ball.velocityY *= -1;
                    case NONE:
                }
            }
            else {
                body.x = ball.velocityX*dt + body.x;
                body.y = ball.velocityY*dt + body.y;
            }

            if(body.y > pongo.height - 100) {
                entity.removeComponent(Alive);
                trace("we did it!");
            }

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
            }
        });
    }

    private var _balls :SourceGroup;
}