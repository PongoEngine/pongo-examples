package shooter;

import pongo.ecs.Entity;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.ReactiveGroup;
import pongo.Pongo;
import pongo.display.CircleSprite;
import pongo.display.Sprite;
import pongo.display.Graphics;

class EnemySystem implements System extends Sprite
{
    public function new(enemies :SourceGroup, closeEnemies :ReactiveGroup, farEnemies :ReactiveGroup) : Void
    {
        super();
        _enemies = enemies;
        _closeEnemies = closeEnemies;
        _farEnemies = farEnemies;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        _enemies.iterate(function(entity :Entity) {
            var enemy = entity.getComponent(Enemy);
            var body = entity.getComponent(Body);

            if(enemy.direction == 1) {
                body.y += enemy.speed*dt;
                if(body.y > pongo.height) {
                    body.y = pongo.height;
                    enemy.direction = -1;
                }
            }
            else if(enemy.direction == -1) {
                body.y -= enemy.speed*dt;
                if(body.y < 0) {
                    body.y = 0;
                    enemy.direction = 1;
                }
            }

            if(entity.visual != null) {
                entity.visual.x = body.x;
                entity.visual.y = body.y;
                entity.visual.rotation = body.rotation;
                cast (entity.visual, CircleSprite).color = enemy.color;
            }
        });

        _farEnemies.iterate(function(e) {
            var enemy = e.getComponent(Enemy);
            enemy.color = 0xff004455;
        });

        _closeEnemies.iterate(function(e) {
            var enemy = e.getComponent(Enemy);
            enemy.color = 0xffaabbcc;
        });
    }

    override public function draw(pongo :Pongo, g :Graphics) : Void
    {
        _enemies.iterate(function(entity :Entity) {
            var enemy = entity.getComponent(Enemy);
            var body = entity.getComponent(Body);
            g.drawLine(0xffaabbcc, body.x, 0, body.x, pongo.height);
            g.drawCircle(0xffaabbcc, body.x, body.y, body.radius);
        });
    }

    private var _enemies :SourceGroup;
    private var _closeEnemies :ReactiveGroup;
    private var _farEnemies :ReactiveGroup;
}