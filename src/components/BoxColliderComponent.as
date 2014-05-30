package components 
{
	import maths.Vec2;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class BoxColliderComponent implements IComponent 
	{
		// Relative to the player position
		public var min_x:Number;
		public var min_y:Number;
		public var max_x:Number;
		public var max_y:Number;
		
		public var isTouchingFloor:Boolean;
		public var isTouchingRoof:Boolean;
		public var isTouchingRightWall:Boolean;
		public var isTouchingLeftWall:Boolean;
		
		public var pos:Vec2;
		public var vel:Vec2;
		
		// Array of colliding with
		public var collidingWith:Array;
		
		// Is moveable
		public var is_static:Boolean;
		public var is_teleporter:Boolean;
		
		public function BoxColliderComponent(pos:Vec2, vel:Vec2, min_x:Number, min_y:Number, max_x:Number, max_y:Number) 
		{
			this.min_x = min_x;
			this.min_y = min_y;
			this.max_x = max_x;
			this.max_y = max_y;
			this.pos = pos;
			this.vel = vel;
			
			isTouchingFloor = false;
			isTouchingLeftWall = false;
			isTouchingRightWall = false;
			isTouchingRoof = false;
			
			is_teleporter = false;
		}
		
		/* INTERFACE components.IComponent */
		
		public function type():int 
		{
			return GameConst.COMP_COL_BOX;
		}
		
		public function erase():void
		{
		}
		
	}

}