package prefabs 
{
	import components.BoxColliderComponent;
	import components.RenderComponent;
	import maths.Vec2;
	import systems.EntityManager;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Platform 
	{
		private var entity_manager:EntityManager;
		private var render_component:RenderComponent;
		private var box_collider_component:BoxColliderComponent;
		private var position:Vec2;
		
		private var entity:int;
		
		private static const COLOR_ARRAY:Array = new Array(0xFFFF33, 0x0FFF0F, 0x79DCF4, 0xFF3333, 0xFFCC33, 0x99CC33);
		
		public function Platform(entity_manager:EntityManager, x:Number, y:Number, length:Number, height:Number) 
		{
			this.entity_manager = entity_manager;
			
			position = new Vec2();
			position.x = x;
			position.y = y;
			
			render_component = new RenderComponent();
			
			var randomColorID:Number = Math.floor(Math.random()*COLOR_ARRAY.length);
 
			render_component.graphics.beginFill(COLOR_ARRAY[randomColorID]);
			render_component.graphics.drawRect(0, 0, length, height);
			render_component.graphics.endFill();
			render_component.x = x;
			render_component.y = y;
			
			box_collider_component = new BoxColliderComponent(position,
			new Vec2(), 0, 0, length, height);
			box_collider_component.is_static = true;
			box_collider_component.is_teleporter = false;
			
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