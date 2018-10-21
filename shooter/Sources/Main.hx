package;

import pongo.ecs.group.ReactiveGroup;
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

        var closeEnemies = distanceEnemiesGroup(enemies, heroes, true);
        var farEnemies = distanceEnemiesGroup(enemies, heroes, false);
        var bulletLayer = pongo.createEntity();
        var enemySystem = new EnemySystem(enemies, closeEnemies, farEnemies);

        pongo
            .addSystem(new CameraSystem(pongo, cameras, heroes))
            .addSystem(new HeroSystem(pongo, heroes))
            .addSystem(enemySystem)
            .root
                .setVisual(new Sprite())
                .addComponent(new Camera(0))
                .addEntity(createHero(pongo, pongo.width/2, pongo.height/2, 30))
                .addEntity(createEnemy(pongo, 0xff00aabb, 600, 30, 730))
                .addEntity(createEnemy(pongo, 0xff00aabb, 800, 30, 390))
                .addEntity(createEnemy(pongo, 0xff00aabb, 1200, 30, 820))
                .addEntity(bulletLayer)
                .addEntity(pongo.createEntity()
                    .setVisual(enemySystem));
    }

    private static function distanceEnemiesGroup(enemies :SourceGroup, heroes :SourceGroup, isClose :Bool) : ReactiveGroup
    {
        return enemies.createReactiveGroup(function(e) {
            var firstHero = heroes.first();
            if(firstHero == null) return false;
            else {
                var heroBody = firstHero.getComponent(Body);
                var enemyBody = e.getComponent(Body);
                var dist = CMath.distance(enemyBody.x, enemyBody.y, heroBody.x, heroBody.y);
                return isClose ? dist < 200 : dist >= 200;
            }
        });
    }

    public static function createHero(pongo :Pongo, x :Float, y :Float, radius :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Hero(100))
            .setVisual(new CircleSprite(0xff00ff00, radius)
                .centerAnchor())
            .addComponent(new Body(x, y, 0, 0, radius, 0));
    }

    public static function createEnemy(pongo :Pongo, color :Int, x :Float, radius :Float, speed :Float) : Entity
    {
        return pongo.createEntity()
            .addComponent(new Enemy(color, 10, 1, speed))
            .setVisual(new CircleSprite(color, radius)
                .centerAnchor())
            .addComponent(new Body(x, 0, 0, 0, radius, 0));
    }
}