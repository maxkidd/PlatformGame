package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import Game;
	
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Main extends Sprite 
	{
		private var game:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			game = new Game(stage.stageWidth, stage.stageHeight);
			// Adds the game sprite to make it visible
			addChild(game);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		// Key functions to add to global keys
		
		private function keyDownListener(e:KeyboardEvent):void
		{
			
			var inArray:Boolean = false;
			for each(var key:int in GameConst.keyDown)
			{
				if (e.keyCode == key)
				{
					inArray = true;
				}
			}
			if (inArray)
			{
				return;
			}
			GameConst.keyDown.push(e.keyCode);
			GameConst.keyPressed.push(e.keyCode);
		}
		
		private function keyUpListener(e:KeyboardEvent):void
		{
			for (var i:int = 0; i < GameConst.keyDown.length; i++)
			{
				if (e.keyCode == GameConst.keyDown[i])
				{
					GameConst.keyDown.splice(i, 1);
				}
			}
		}
		
	}
	
}