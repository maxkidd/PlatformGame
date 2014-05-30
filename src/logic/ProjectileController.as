package logic 
{
	import components.BoxColliderComponent;
	import systems.EntityManager;
	import systems.ServiceLocator;
	import components.RenderComponent;
	import components.ProjectileComponent;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class ProjectileController implements ILogic 
	{
		private var projectiles:Array;
		
		private var entity_manager:EntityManager;
		
		
		public function ProjectileController() 
		{
			entity_manager = ServiceLocator.GetEntityManager();
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			var projectile_array:Array = [GameConst.COMP_COL_BOX, GameConst.COMP_PROJ, GameConst.COMP_RENDER];
			projectiles = entity_manager.GetAllEntitiesPossessingComponents(projectile_array);
				
			if (projectiles == null)
				return;
				
			for each(var projectile:int in projectiles)
			{
				var box_collider_component:BoxColliderComponent = entity_manager.GetComponent(projectile, GameConst.COMP_COL_BOX) as BoxColliderComponent;
				var projectile_component:ProjectileComponent = entity_manager.GetComponent(projectile, GameConst.COMP_PROJ) as ProjectileComponent;
				var render_component:RenderComponent = entity_manager.GetComponent(projectile, GameConst.COMP_RENDER) as RenderComponent;
				// Add gravity acceleration
				projectile_component.vel.y += 0.8;
				projectile_component.time_till_explode--;
				
				render_component.movie_clip.rotation = (Math.atan2(box_collider_component.vel.x, -box_collider_component.vel.y) * 180)/ Math.PI;
				
				if (projectile_component.time_till_explode < 1 || projectile_component.bounces >= 5)
				{
					projectile_component.explosion_sound.play();
					
					entity_manager.KillEntity(projectile);
					
					render_component = null;
					box_collider_component = null;
					projectile_component = null;
				}
			}
		}
		
	}

}