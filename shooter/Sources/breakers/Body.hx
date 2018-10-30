package breakers;

import pongo.ecs.Component;

class Body implements Component
{
    var x :Float;
    var y :Float;
    var shape :BodyShape;
    var collisionDirection :Direction;
    var collidedWith :Body;
    var rect :Rect;
    var isPaddle :Bool;
}

@:enum
abstract Direction(String)
{
    var NONE = "NONE";
    var LEFT = "LEFT";
    var RIGHT = "RIGHT";
    var TOP = "TOP";
    var BOTTOM = "BOTTOM";
}

enum BodyShape
{
    RECT(width:Float, height:Float);
    CIRCLE(radius :Float);
}

class Rect
{
    public var left (default, null):Float;
    public var right (default, null):Float;
    public var top (default, null):Float;
    public var bottom (default, null):Float;

    public var oldLeft (default, null):Float;
    public var oldRight (default, null):Float;
    public var oldTop (default, null):Float;
    public var oldBottom (default, null):Float;
    public var canUpdate :Bool;

    public function new(left :Float, right :Float, top :Float, bottom :Float) : Void
    {
        this.oldLeft = this.left = left;
        this.oldRight = this.right = right;
        this.oldTop = this.top = top;
        this.oldBottom = this.bottom = bottom;
        this.canUpdate = true;
    }

    public function setVals(left :Float, right :Float, top :Float, bottom :Float) : Void
    {
        if(this.canUpdate) {
            this.oldLeft = this.left;
            this.oldRight = this.right;
            this.oldTop = this.top;
            this.oldBottom = this.bottom;

            this.left = left;
            this.right = right;
            this.top = top;
            this.bottom = bottom;
            this.canUpdate = false;
        }
    }

    public function collidedFromLeft(otherRect :Rect) : Bool
    {
        return this.oldRight < otherRect.left && this.right >= otherRect.left;
    }

    public function collidedFromRight(otherRect :Rect) : Bool
    {
        return this.oldLeft >= otherRect.right && this.left < otherRect.right;
    }

    public function collidedFromTop(otherRect :Rect) : Bool
    {
        return this.oldBottom < otherRect.top && this.bottom >= otherRect.top;
    }

    public function collidedFromBottom(otherRect :Rect) : Bool
    {
        return this.oldTop >= otherRect.bottom && this.top < otherRect.bottom;
    }

    @:extern public static inline function create() : Rect
    {
        return new Rect(0,0,0,0);
    }
}