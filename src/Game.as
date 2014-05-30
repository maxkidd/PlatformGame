package  
{
	/**
	 * ...
	 * @author Max Kidd
	 */
	import scenes.GameScene;
	import scenes.IScene;
	import scenes.MenuScene;
	import flash.display.Sprite;
	
	// Scene manager
	public class Game extends Sprite
	{
		
		private var current_scene : IScene = null;
		
		public function Game(stageWidth:int, stageHeight:int):void
		{
			
			//menu_scene = new MenuScene(this);
			ShowScene(new MenuScene(this));
			
		}
		
		// Switch scene
		public function ShowScene(scene:IScene):void
		{
			if (current_scene != null)
				removeChild(current_scene as Sprite);
			addChild(scene as Sprite);
			current_scene = scene;
		}
	}

}