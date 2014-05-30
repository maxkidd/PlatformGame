package prefabs 
{
	import components.BoxColliderComponent;
	import components.ProjectileComponent;
	import components.RenderComponent;
	import flash.display.MovieClip;
	import maths.Vec2;
	import systems.ServiceLocator;
	import systems.EntityManager;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Projectile 
	{
		
		public function Projectile(pos:Vec2, vel:Vec2, attacksWho:Boolean) 
		{
			var entity_manager:EntityManager = ServiceLocator.GetEntityManager();
			
			var render_component:RenderComponent = new RenderComponent();
			
			var rocket_clip:MovieClip = new rocket;
			render_component.addMC(rocket_clip);
			render_component.movie_clip.play();
			render_component.movie_clip.scaleX = 2;
			render_component.movie_clip.scaleY = 2;
			
			var projectile_component:ProjectileComponent = new ProjectileComponent();
			projectile_component.pos = pos;
			projectile_component.vel = vel;
			projectile_component.attacksWho = attacksWho;
			
			var box_collider_component:BoxColliderComponent = new BoxColliderComponent(pos, vel,
				0, 5, 10, 15);
			box_collider_component.is_static = false;
			
			var projectile:int = entity_manager.CreateEntity();
			entity_manager.AddComponent(projectile, render_component, false);
			entity_manager.AddComponent(projectile, projectile_component, false);
			entity_manager.AddComponent(projectile, box_collider_component, false);
		}
		
	}

}