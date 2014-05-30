package components 
{
	import flash.media.Sound;
	import maths.Vec2;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class ProjectileComponent implements IComponent 
	{
		[Embed(source="../../res/explosion.mp3")]
		private var explSound:Class;
		
		[Embed(source="../../res/bounce.mp3")]
		private var bnceSound:Class;
		
		[Embed(source="../../res/thump.mp3")]
		private var thmpSound:Class;
		
		// Vectors
		public var acceleration:Vec2;
		public var vel:Vec2;
		public var pos:Vec2;
		
		public var attacksWho:Boolean; // True = enemy, False = player
		
		// Sound
		public var explosion_sound:Sound;
		public var bounce_sound:Sound;
		public var player_hit_sound:Sound;
		
		// Timers
		public var time_till_explode:int; // Time till the projectile explodes if not hit anything (or granade type)
		public var bounces:int; // Bounces projectile has taken
		
		public function ProjectileComponent() 
		{
			// Vectors
			vel = new Vec2();
			pos = new Vec2();
			acceleration = new Vec2();
			
			// Timers
			time_till_explode = 100;
			
			attacksWho = true;
			
			explosion_sound = new explSound() as Sound;
			bounce_sound = new bnceSound() as Sound;
			player_hit_sound = new thmpSound() as Sound;
		}
		
		/* INTERFACE components.IComponent */
		
		public function erase():void 
		{
			//vel = null;
			//pos = null;
			//acceleration = null;
		}
		
		public function type():int 
		{
			return GameConst.COMP_PROJ;
		}
		
	}

}