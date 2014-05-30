package components 
{
	/**
	 * ...
	 * @author Max Kidd
	 */
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	 
	public class RenderComponent extends Sprite implements IComponent
	{
		public var movie_clip:MovieClip = null;
		public var speed:Number;
		private var playing:Boolean;
		private var current_frame:Number;
		
		public function RenderComponent() 
		{
			speed = 0;
			playing = false;
			current_frame = 0;
		}
		
		public function addMC(mc:MovieClip):void
		{
			movie_clip = mc;
			addChild(movie_clip);
		}
		
		public function play():void
		{
			if(!playing) movie_clip.addEventListener(Event.ENTER_FRAME, EnterFrame );
            playing = true;
		}
		
		private function EnterFrame(e:Event):void 
        {
			if (playing)
            {
				if (speed < 0.2)
				{
					current_frame = 0;
				}
                current_frame += speed;
                movie_clip.gotoAndStop( Math.round(current_frame % movie_clip.totalFrames) );             
            }
		}
		public function type():int
		{
			return GameConst.COMP_RENDER;
		}
		
		public function erase():void
		{
			if (movie_clip != null)
			{
				removeChild(movie_clip);
			}
			if (this.stage)
				this.parent.removeChild(this);
		}
	}
}