package prefabs 
{
	import components.BoxColliderComponent;
	import components.EnemyComponent;
	import components.RenderComponent;
	import flash.display.MovieClip;
	import maths.Vec2;
	import systems.EntityManager;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Enemy 
	{
		private var _entity_manager:EntityManager;
		private var render_component:RenderComponent;
		private var box_collider_component:BoxColliderComponent;
		private var enemy_component:EnemyComponent;
		private var position:Vec2;
		private var entity:int;
		
		public function Enemy(entity_manager:EntityManager, x:Number, y:Number) 
		{
			_entity_manager = entity_manager;
			position = new Vec2();
			position.x = x;
			position.y = y;
			
			render_component = new RenderComponent();
			//render_component.graphics.beginFill(0x00FF00);
			//render_component.graphics.drawRect(0, 0, 50, 50);
			//render_component.graphics.endFill();
			//render_component.x = x;
			//render_component.y = y;
			
			
			var enemy_clip:MovieClip = new enemy_mc;
			render_component.addMC(enemy_clip);
			
			enemy_component = new EnemyComponent();
			enemy_component.pos = position;
			enemy_component.vel = new Vec2();
			
			box_collider_component = new BoxColliderComponent(position, enemy_component.vel, 0, 0, 48, 48);
			box_collider_component.is_static = false;
			
			entity = entity_manager.CreateEntity();
			entity_manager.AddComponent(entity, render_component, false);
			entity_manager.AddComponent(entity, enemy_component, false);
			entity_manager.AddComponent(entity, box_collider_component, false);
		}
		
		public function erase():void
		{
			_entity_manager.KillEntity(entity);
		}
		
	}

}