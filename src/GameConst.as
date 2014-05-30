package  
{
	import flash.display.DisplayObject;
	import maths.Vec2;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class GameConst 
	{
		public static const COMP_NULL:int = 0;
		public static const COMP_RENDER:int = 1;
		public static const COMP_PLAYER:int = 2;
		public static const COMP_COL_BOX:int = 3;
		public static const COMP_PROJ:int = 4;
		public static const COMP_BACK:int = 5;
		public static const COMP_ENEMY:int = 6;
		public static const LAST_COMPONENT:int = 6;
		
		public static const SCENE_MENU:int = 0;
		public static const SCENE_GAME:int = 1;
		
		public static const GRAVITY:Vec2 = new Vec2(0, 1.5);
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 600;
		
		public static const PLAYER_SIZE:int = 50;
		public static const TILE_BLOCK_SIZE:int = 50;
		
		public static const MAP_WIDTH:int = 100;
		public static const MAP_HEIGHT:int = 100;
		
		public static const SECTOR_WIDTH:int = 30;
		public static const SECTOR_HEIGHT:int = 30;
		
		// Magic number in the middle of the bounds
		public static const PLAYER_START_POS_X:int = 15000;
		public static const PLAYER_START_POS_Y:int = 15000;
		
		public static const MAX_PLATFORMS_PER_SECTOR:int = 10;
		
		public static const CAM_SCALE:Number = 0.5;
		
		public static var nextLevel:Boolean = false;
		public static var currentLevel:int = 0;
		
		public static var keyDown:Array = new Array();
		public static var keyPressed:Array = new Array();
		public static var keyNotUp:Array = new Array();
		
		
	}

}