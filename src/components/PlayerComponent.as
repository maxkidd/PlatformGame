package components 
{
	import flash.text.TextField;
	import maths.Vec2;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class PlayerComponent implements IComponent
	{
		public static var nextLevel:Boolean = false;
		public static var level:int = 0;
		
		// Keys
		public var up_key:int;
		public var left_key:int;
		public var right_key:int;
		public var shift_right_key:int;
		public var shift_left_key:int;
		
		// Vectors
		public var acceleration:Vec2;
		public var vel:Vec2;
		public var pos:Vec2;
		
		// Timers
		public var shift_timer:int; // When player is shifting
		public var shift_recharge:int;
		public var shoot_timer:int;
		
		// Player info
		public var score:int;
		public var score_text:TextField;
		
		public static var health:int = 100;
		public var health_text:TextField;
		
		public var has_doublejumped:Boolean;
		public var max_speed:Number; // Max speed due to air resistance
		public var mass:Vec2;
		
		public function PlayerComponent() 
		{
			// Vectors
			vel = new Vec2();
			pos = new Vec2();
			acceleration = new Vec2();
			acceleration.x = 2;
			
			// Timer
			shift_timer = 0;
			shift_recharge = 10;
			
			shoot_timer = 0;
			
			// Player info
			score_text = new TextField();
			score = 0;
			health_text = new TextField();
			
			has_doublejumped = false;
			max_speed = 25;
			mass = new Vec2(2, 2);
			
			// Input keys
			up_key = 0;
			left_key = 0;
			right_key = 0;
			shift_right_key = 0;
			shift_left_key = 0;
		}
		
		public function type():int
		{
			return GameConst.COMP_PLAYER;
		}
		
		public function erase():void
		{
		}
	}

}