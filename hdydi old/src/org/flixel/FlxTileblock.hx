package org.flixel;

import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
	 * This is a basic "environment object" class, used to create simple walls and floors.
	 * It can be filled with a random selection of tiles to quickly add detail.
	 * 
	 * @author Adam Atomic
	 */
class FlxTileblock extends FlxSprite
{
    /**
		 * Creates a new <code>FlxBlock</code> object with the specified position and size.
		 * 
		 * @param	X			The X position of the block.
		 * @param	Y			The Y position of the block.
		 * @param	Width		The width of the block.
		 * @param	Height		The height of the block.
		 */
    public function new(X : Int, Y : Int, Width : Int, Height : Int)
    {
        super(X, Y);
        makeGraphic(Width, Height, 0, true);
        active = false;
        immovable = true;
    }
    
    /**
		 * Fills the block with a randomly arranged selection of graphics from the image provided.
		 * 
		 * @param	TileGraphic 	The graphic class that contains the tiles that should fill this block.
		 * @param	TileWidth		The width of a single tile in the graphic.
		 * @param	TileHeight		The height of a single tile in the graphic.
		 * @param	Empties			The number of "empty" tiles to add to the auto-fill algorithm (e.g. 8 tiles + 4 empties = 1/3 of block will be open holes).
		 */
    public function loadTiles(TileGraphic : Class<Dynamic>, TileWidth : Int = 0, TileHeight : Int = 0, Empties : Int = 0) : FlxTileblock
    {
        if (TileGraphic == null)
        {
            return this;
        }
        
        //First create a tile brush
        var sprite : FlxSprite = new FlxSprite().loadGraphic(TileGraphic, true, false, TileWidth, TileHeight);
        var spriteWidth : Int = sprite.width;
        var spriteHeight : Int = sprite.height;
        var total : Int = as3hx.Compat.parseInt(sprite.frames + Empties);
        
        //Then prep the "canvas" as it were (just doublechecking that the size is on tile boundaries)
        var regen : Bool = false;
        if (width % sprite.width != 0)
        {
            width = as3hx.Compat.parseInt(width / spriteWidth + 1) * spriteWidth;
            regen = true;
        }
        if (height % sprite.height != 0)
        {
            height = as3hx.Compat.parseInt(height / spriteHeight + 1) * spriteHeight;
            regen = true;
        }
        if (regen)
        {
            makeGraphic(width, height, 0, true);
        }
        else
        {
            this.fill(0);
        }
        
        //Stamp random tiles onto the canvas
        var row : Int = 0;
        var column : Int;
        var destinationX : Int;
        var destinationY : Int = 0;
        var widthInTiles : Int = as3hx.Compat.parseInt(width / spriteWidth);
        var heightInTiles : Int = as3hx.Compat.parseInt(height / spriteHeight);
        while (row < heightInTiles)
        {
            destinationX = 0;
            column = 0;
            while (column < widthInTiles)
            {
                if (FlxG.random() * total > Empties)
                {
                    sprite.randomFrame();
                    sprite.drawFrame();
                    stamp(sprite, destinationX, destinationY);
                }
                destinationX += spriteWidth;
                column++;
            }
            destinationY += spriteHeight;
            row++;
        }
        
        return this;
    }
}

