package;

import kha.System;

import pongo.display.Sprite;
import pongo.Pongo;

class Main {
    public static function main() : Void
    {
        System.start({title: "Empty", width: 800, height: 600}, onStart);
    }

    private static function onStart(window) : Void
    {
        var pongo :Pongo = new pongo.platform.Pongo();
    }
}

