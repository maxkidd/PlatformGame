package logic 
{
	import components.BoxColliderComponent;
	import components.EnemyComponent;
	import components.PlayerComponent;
	import components.RenderComponent;
	import maths.Vec2;
	import prefabs.Projectile;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class EnemyController implements ILogic 
	{
		private var enemies:Array;
		
		private var entity_manager:EntityManager;
		
		private var player:int;
		private var player_component:PlayerComponent;
		
		public function EnemyController() 
		{
			entity_manager = ServiceLocator.GetEntityManager();
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			if (player_component == null)
			{
				var player_array:Array = entity_manager.GetAllEntitiesPossessingComponents([GameConst.COMP_PLAYER]);
				
				player = player_array[0];
				player_component = entity_manager.GetComponent(player, GameConst.COMP_PLAYER) as PlayerComponent;
			}
			
			
			var enemy_array:Array = [GameConst.COMP_COL_BOX, GameConst.COMP_ENEMY, GameConst.COMP_RENDER];
			enemies = entity_manager.GetAllEntitiesPossessingComponents(enemy_array);
			if (enemies == null)
				return;
				
			for each(var enemy:int in enemies)
			{
				var enemy_component:EnemyComponent = entity_manager.GetComponent(enemy, GameConst.COMP_ENEMY) as EnemyComponent;
				var enemy_box_component:BoxColliderComponent = entity_manager.GetComponent(enemy, GameConst.COMP_COL_BOX) as BoxColliderComponent;
				var render_component:RenderComponent = entity_manager.GetComponent(enemy, GameConst.COMP_RENDER) as RenderComponent;
				
				render_component.play();
				// Play running and update speed
				render_component.speed = Math.abs(enemy_component.vel.x / 20);
				
				// Add gravity acceleration
				enemy_component.vel.y += 0.5;
				
				if (enemy_component.isAttacking)
				{
					enemy_component = null;
				}
				else // if idle
				{
					// If enemy is not moving
					if (enemy_component.walkState == null)
					{
						// Check player is touching platform
						if (enemy_box_component.isTouchingFloor)
						{
							// Walk either left or right
							enemy_component.walkState = (Math.random() > 0.5) ? true : false;
						}
					}
					else if (enemy_component.walkState == true) // Else if enemy is moving left
					{
						
						// Flip to the left side
						render_component.movie_clip.x = render_component.width;
						render_component.movie_clip.scaleX = -1;
						
						if (enemy_box_component.isTouchingRightWall)
						{
							enemy_component.walkState = false;
							if(enemy_component.vel.x < 10)
								enemy_component.vel.x += 4;
						}
						else if (enemy_box_component.collidingWith[0] != null)
						{
							if (enemy_box_component.pos.x >= enemy_box_component.collidingWith[0].pos.x)
							{
								if(enemy_component.vel.x > -10)
									enemy_component.vel.x += -4;
							}
							else
							{
								enemy_component.walkState = false;
								if(enemy_component.vel.x < 10)
									enemy_component.vel.x += 4;
							}
						}
					}
					else if (enemy_component.walkState == false) // Else if enemy is moving right
					{
						
						// Flip to the right side
						render_component.movie_clip.x = 0;
						render_component.movie_clip.scaleX = 1;
						
						if (enemy_box_component.isTouchingLeftWall)
						{
							enemy_component.walkState = true;
							if(enemy_component.vel.x > -10)
								enemy_component.vel.x += -4;
						}
						else if (enemy_box_component.collidingWith[1] != null)
						{
							if (enemy_box_component.pos.x + enemy_box_component.max_x <= enemy_box_component.collidingWith[1].pos.x + enemy_box_component.collidingWith[1].max_x)
							{
								if(enemy_component.vel.x < 10)
									enemy_component.vel.x += 4;
							}
							else
							{
								enemy_component.walkState = true;
								if(enemy_component.vel.x > -10)
									enemy_component.vel.x += -4;
							}
						}
						else if (enemy_box_component.collidingWith[0] != null)
						{
							if (enemy_box_component.pos.x + enemy_box_component.max_x <= enemy_box_component.collidingWith[0].pos.x + enemy_box_component.collidingWith[0].max_x)
							{
								if(enemy_component.vel.x < 10)
									enemy_component.vel.x += 4;
							}
							else
							{
								enemy_component.walkState = true;
								if(enemy_component.vel.x > -10)
									enemy_component.vel.x += -4;
							}
						}
					}
				}
				
				// See if player is near
				if (enemy_component.pos.x + enemy_component.view_distance.x > player_component.pos.x
				&& enemy_component.pos.x - enemy_component.view_distance.x < player_component.pos.x
				&& enemy_component.pos.y + enemy_component.view_distance.y > player_component.pos.y
				&& enemy_component.pos.y - enemy_component.view_distance.y < player_component.pos.y)
				{
					enemy_component.vel.x = 0;
					
					// Projectile
					if (enemy_component.shootTimer < 1)
					{
						var t:Number = 25;
						var Sx:Number = player_component.pos.x - enemy_component.pos.x;
						var Sy:Number = player_component.pos.y - enemy_component.pos.y;
						
						// U = s/t - at/2
						var Ux:Number = (Sx/t)
						var Uy:Number = (Sy/t) - (0.75*t)/2
						
						new Projectile(new Vec2(enemy_component.pos.x + 25, enemy_component.pos.y + 10), new Vec2(Ux, Uy), false);
						enemy_component.shootTimer = 60;
					}
					else
						enemy_component.shootTimer--;
				}
				
			}
		}
		
	}

}