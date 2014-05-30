package prefabs 
{
	import components.BoxColliderComponent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import maths.Vec2;
	import systems.EntityManager;
	import components.PlayerComponent;
	import components.RenderComponent;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Player 
	{
		var entity:int;
		public function Player(entity_manager:EntityManager, x:Number, y:Number, up_key:int, left_key:int, right_key:int, shift_left_key:int, shift_right_key:int)
		{
			var render_component:RenderComponent = new RenderComponent();
			
			var player_clip:MovieClip = new player_mc;
			render_component.addMC(player_clip);
			
			var position:Vec2 = new Vec2();
			position.x = x;
			position.y = y;
			
			var velocity:Vec2 = new Vec2();
			
			
			var player_component:PlayerComponent = new PlayerComponent();
			player_component.pos = position;
			player_component.vel = velocity;
			player_component.up_key = up_key;
			player_component.left_key = left_key;
			player_component.right_key = right_key;
			player_component.shift_left_key = shift_left_key;
			player_component.shift_right_key = shift_right_key;
			
			var box_collider_component:BoxColliderComponent = new BoxColliderComponent(position, velocity, 0, 0, 48, 48);
			box_collider_component.is_static = false;
			
			entity = entity_manager.CreateEntity();
			entity_manager.AddComponent(entity, render_component, false);
			entity_manager.AddComponent(entity, player_component, false);
			entity_manager.AddComponent(entity, box_collider_component, false);
		}
		
		public function GetEntity():int
		{
			return entity;
		}
		
	}

}