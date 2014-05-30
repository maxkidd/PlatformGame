package prefabs 
{
	import components.BoxColliderComponent;
	import components.RenderComponent;
	import flash.display.MovieClip;
	import maths.Vec2;
	import systems.EntityManager;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Teleporter 
	{
		private var entity_manager:EntityManager;
		private var render_component:RenderComponent;
		private var box_collider_component:BoxColliderComponent;
		private var position:Vec2;
		
		private var entity:int;
		public function Teleporter(entity_manager:EntityManager, x:Number, y:Number, length:Number, height:Number) 
		{
			this.entity_manager = entity_manager;
			
			position = new Vec2();
			position.x = x;
			position.y = y;
			
			render_component = new RenderComponent();
			
			var teleport_clip:MovieClip = new teleport_mc;
			render_component.addMC(teleport_clip);
			
			render_component.x = x;
			render_component.y = y;
			
			box_collider_component = new BoxColliderComponent(position,
			new Vec2, 0, 0, length, height);
			box_collider_component.is_static = true;
			box_collider_component.is_teleporter = true;
			
			entity = entity_manager.CreateEntity();
			entity_manager.AddComponent(entity, render_component, false);
			entity_manager.AddComponent(entity, box_collider_component, false);
			
		}
		
		public function erase():void
		{
			entity_manager.KillEntity(entity);
		}
	}

}