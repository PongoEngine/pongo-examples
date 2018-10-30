package breakers;

import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;
import breakers.Body;

import pongo.ecs.Entity;
using pongo.math.CMath;

class CollisionSystem implements System
{
    public function new(bodies :SourceGroup) : Void
    {
        _bodies = bodies;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _bodies.iterate(function(e :Entity) {
            e.getComponent(Body).collisionDirection = NONE;
            updateRect(e.getComponent(Body));
        });

        _bodies.changed.iterate(function(from :Entity) {
            var fromBody = from.getComponent(Body);
            _bodies.iterateWithEscape(function(to :Entity) {
                var toBody = to.getComponent(Body);
                checkCollision(fromBody, toBody);
                return fromBody.collisionDirection != NONE;
            });
        });
    }

    private function checkCollision(from :Body, to :Body) : Void
    {
        if(from == to) return;

        switch [from.shape, to.shape] {
            case[CIRCLE(radius), RECT(width, height)]: circleToRect(from, radius, to);
            case[RECT(width, height), CIRCLE(radius)]: checkCollision(to, from);
            case[RECT(width1, height1), RECT(width2, height2)]: rectToRect(from, to);
            case[CIRCLE(radius1), CIRCLE(radius2)]: circleToCircle(from, radius1, to, radius2);
        }

        from.collidedWith = (from.collisionDirection != NONE)
            ? from.collidedWith = to
            : null;
    }

    private function circleToRect(from :Body, radius :Float, to :Body) : Void
    {
        var closestX = CMath.clamp(from.x, to.rect.left, to.rect.right);
        var closestY = CMath.clamp(from.y, to.rect.top, to.rect.bottom);

        var distanceX = from.x - closestX;
        var distanceY = from.y - closestY;
        var distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
        if(distanceSquared < (radius * radius)) {
            collisionDirection(from, to);
        }
    }

    private function rectToRect(from :Body, to :Body) : Void
    {
        if (from.rect.left < to.rect.right && from.rect.right > to.rect.left && from.rect.top < to.rect.bottom && from.rect.bottom > to.rect.top) {
            collisionDirection(from, to);
        }
    }

    private function circleToCircle(from :Body, radius1 :Float, to :Body, radius2 :Float) : Void
    {
        var dx = from.x - to.x;
        var dy = from.y - to.y;
        var distance = Math.sqrt(dx * dx + dy * dy);

        if (distance < radius1 + radius2) {
            collisionDirection(from, to);
        }
    }

    private function updateRect(body :Body) : Void
    {
        switch body.shape {
            case RECT(width, height): {
                var halfWidth = width/2;
                var halfHeight = height/2;
                body.rect.setVals(body.x - halfWidth, body.x + halfWidth, body.y - halfHeight, body.y + halfHeight);
            }
            case CIRCLE(radius): {
                body.rect.setVals(body.x - radius, body.x + radius, body.y - radius, body.y + radius);
            }
        }
    }

    private function collisionDirection(from :Body, to :Body) : Void
    {
        if(from.rect.collidedFromLeft(to.rect)) from.collisionDirection = RIGHT;
        if(from.rect.collidedFromRight(to.rect)) from.collisionDirection = LEFT;
        if(from.rect.collidedFromBottom(to.rect)) from.collisionDirection = TOP;
        if(from.rect.collidedFromTop(to.rect)) from.collisionDirection = BOTTOM;
    }

    private var _bodies :SourceGroup;
}