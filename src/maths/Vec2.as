package maths 
{
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Vec2 
	{
		public var x:Number;
		public var y:Number;
		public function Vec2(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		
        public function add(pos:Vec2):Vec2
		{
			return new Vec2(x + pos.x, y + pos.y);
		}
		
		public function sub(pos:Vec2):Vec2
		{
			return new Vec2(x - pos.x, y - pos.y);
		}
		
		public function mul(pos:Vec2):Vec2
		{
			return new Vec2(x * pos.x, y * pos.y);
		}
		
		public function div(pos:Vec2):Vec2
		{
			return new Vec2(x / pos.x, y / pos.y);
		}
		
		public function eq(pos:Vec2):Boolean
		{
			return ((x == pos.x) && (y == pos.y))
		}
	}

}