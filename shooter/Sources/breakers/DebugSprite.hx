package breakers;

import pongo.display.Graphics;
import pongo.display.Sprite;
import pongo.ecs.group.SourceGroup;
import pongo.Pongo;
import breakers.Body;


class DebugSprite extends Sprite
{
    public function new(bodies :SourceGroup) : Void
    {
        super();
        _bodies = bodies;
    }

    override public function draw(pongo :Pongo, g :Graphics) : Void
    {
        _bodies.iterate(function(e) {
            var body = e.getComponent(Body);
            switch body.shape {
                case RECT(width, height):
                    g.drawRect(0xffff0000, body.x-width/2, body.y-height/2, width, height);
                case CIRCLE(radius):
                    g.drawCircle(0xffff0000, body.x, body.y, radius);
            }
        });
    }

    private var _bodies :SourceGroup;
}