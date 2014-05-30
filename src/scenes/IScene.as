package scenes 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import Game;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public interface IScene
	{
		function IScene(game:Game);
		function Frame(e:Event):void;
	}
	
}