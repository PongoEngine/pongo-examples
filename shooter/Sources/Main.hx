package;

import pongo.math.CMath;
import pongo.display.CircleSprite;
import pongo.ecs.group.ReactiveGroup;
import pongo.ecs.group.SourceGroup;
import kha.System;

import pongo.display.FillSprite;
import pongo.Pongo;
import pongo.ecs.Entity;
import breakers.Body;
import breakers.Paddle;
import breakers.PaddleSystem;
import breakers.Ball;
import breakers.BallSystem;
import breakers.DebugSprite;
import breakers.CollisionSystem;

class Main 
{
    
    public static function main() : Void
    {
        System.start({title: "Empty", width: 800, height: 600}, onStart);
    }

    private static function onStart(window) : Void
    {
        var pongo :Pongo = new pongo.platform.Pongo();
        var paddles = pongo.manager.registerGroup([Body, Paddle]);
        var balls = pongo.manager.registerGroup([Body, Ball]);
        var bodies = pongo.manager.registerGroup([Body]);

        pongo
            .addSystem(new PaddleSystem(pongo, paddles))
            .addSystem(new BallSystem(balls, paddles))
            .addSystem(new CollisionSystem(bodies))
            .root
                .addEntity(createBall(pongo, 0, 400, pongo.width/2, 420, 15))
                .addEntity(createPaddle(pongo, pongo.width/2, 550, 100, 20))
                .addEntity(createWalls(pongo))
                .addEntity(pongo.createEntity().setVisual(new DebugSprite(bodies)));
    }

    public static function createPaddle(pongo :Pongo, x :Float, y :Float, width :Float, height :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Paddle())
            .setVisual(new FillSprite(0xff00ff00, width, height)
                .centerAnchor())
            .addComponent(new Body(x, y, RECT(width, height), NONE, null, Rect.create(), true));
    }

    public static function createBall(pongo :Pongo, velocityX :Float, velocityY :Float, x :Float, y :Float, radius :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Ball(velocityX, velocityY))
            .setVisual(new CircleSprite(0xff00ffff, radius)
                .centerAnchor())
            .addComponent(new Body(x, y, CIRCLE(radius), NONE, null, Rect.create(), false));
    }

    public static function createWalls(pongo :Pongo) : Entity
    {
        return pongo.createEntity()
            .addEntity(pongo.createEntity()
                .addComponent(new Body(-5,pongo.height/2,RECT(10,pongo.height), NONE, null, Rect.create(), false)))
            .addEntity(pongo.createEntity()
                .addComponent(new Body(pongo.width + 5,pongo.height/2,RECT(10,pongo.height), NONE, null, Rect.create(), false)))
            .addEntity(pongo.createEntity()
                .addComponent(new Body(pongo.width/2,-5,RECT(pongo.width,10), NONE, null, Rect.create(), false)));
    }
}