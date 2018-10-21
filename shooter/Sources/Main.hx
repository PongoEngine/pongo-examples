package;

import pongo.ecs.group.Group;
import pongo.ecs.group.SourceGroup;
import kha.System;

import pongo.display.Sprite;
import pongo.display.CircleSprite;
import pongo.Pongo;
import pongo.ecs.Entity;
import shooter.Body;
import shooter.Hero;
import shooter.HeroSystem;
import shooter.Enemy;
import shooter.EnemySystem;
import shooter.Camera;
import shooter.CameraSystem;
import shooter.Bullet;

import pongo.math.CMath;

class Main {
    public static function main() : Void
    {
        System.start({title: "Empty", width: 800, height: 600}, onStart);
    }

    private static function onStart(window) : Void
    {
        var pongo :Pongo = new pongo.platform.Pongo();
        var heroes = pongo.manager.registerGroup([Body, Hero]);
        var enemies = pongo.manager.registerGroup([Body, Enemy]);
        var cameras = pongo.manager.registerGroup([Camera]);

        var closeEnemies = closeEnemiesGroup(enemies, heroes);

        pongo
            .addSystem(new CameraSystem(pongo, cameras, heroes))
            .addSystem(new HeroSystem(pongo, heroes, closeEnemies))
            .addSystem(new EnemySystem(enemies))
            .root
                .setVisual(new Sprite())
                .addComponent(new Camera(0,0))
                .addEntity(createHero(pongo, pongo.width/2, pongo.height/2, 30))
                .addEntity(createEnemy(pongo, 0xff00aabb, pongo.width/2, 100, 30))
                .addEntity(createEnemy(pongo, 0xff00aabb, pongo.width/2, -500, 30))
                .addEntity(createEnemy(pongo, 0xff00aabb, pongo.width/2, -200, 30));
    }

    private static function closeEnemiesGroup(enemies :SourceGroup, heroes :SourceGroup) : Group
    {
        return enemies.createReactiveGroup(function(e) {
            var firstHero = heroes.first();
            if(firstHero == null) return false;
            else {
                var heroBody = firstHero.getComponent(Body);
                var enemyBody = e.getComponent(Body);
                return CMath.distance(enemyBody.x, enemyBody.y, heroBody.x, heroBody.y) < 200;
            }
        });
    }

    public static function createHero(pongo :Pongo, x :Float, y :Float, radius :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Hero(100))
            .setVisual(new CircleSprite(0xff00ff00, radius)
                .centerAnchor())
            .addComponent(new Body(x, y, radius, 0));
    }

    public static function createEnemy(pongo :Pongo, color :Int, x :Float, y :Float, radius :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Enemy(10))
            .setVisual(new CircleSprite(color, radius)
                .centerAnchor())
            .addComponent(new Body(x, y, radius, 0));
    }

    public static function createBullet(pongo :Pongo, x :Float, y :Float, velocityX :Float, velocityY :Float) : Entity
    {
        var radius = 10;
        return pongo.createEntity()
            .addComponent(new Bullet(velocityX, velocityY))
            .setVisual(new CircleSprite(0xff00ffff, radius)
                .centerAnchor())
            .addComponent(new Body(x, y, radius, 0));
    }
}