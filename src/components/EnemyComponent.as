package components 
{
	import maths.Vec2;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class EnemyComponent implements IComponent 
	{
		// Vectors
		public var acceleration:Vec2;
		public var vel:Vec2;
		public var pos:Vec2;
		
		public var health:int;
		
		public var view_distance:Vec2; // Distance enemy can spot player
		
		// Bools
		public var isAttacking:Boolean;
		
		// Tri bool
		public var walkState:Object; // null = not moving, true = walk left, false = walk right
		
		// Timer
		public var shootTimer:int;
		
		public function EnemyComponent() 
		{
			// Vectors
			vel = new Vec2();
			pos = new Vec2();
			acceleration = new Vec2();
			
			view_distance = new Vec2(600, 450);
			
			health = 20 + (PlayerComponent.level * 10);
			walkState = null;
			shootTimer = 0;
		}
		
		/* INTERFACE components.IComponent */
		
		public function erase():void 
		{
		}
		
		public function type():int 
		{
			return GameConst.COMP_ENEMY;
		}
		
	}

}