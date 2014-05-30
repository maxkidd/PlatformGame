package logic 
{
	import components.BoxColliderComponent;
	import components.EnemyComponent;
	import components.PlayerComponent;
	import components.ProjectileComponent;
	import components.RenderComponent;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Collisions implements ILogic 
	{
		// Object array
		private var _dynamic_box_objects:Array;
		private var _static_box_objects:Array;
		
		// Integer array
		private var _player_entity:int;
		private var _platform_entities:Array = new Array();
		private var _projectile_entities:Array = new Array();
		private var _enemy_entities:Array = new Array();
		
		// Entity manager
		private var _entity_manager:EntityManager;
		
		public function Collisions() 
		{
			_entity_manager = ServiceLocator.GetEntityManager();
			
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			// Reset the arrays TODO: send a dictionary of updated entities to reload only
			_platform_entities = new Array();
			_projectile_entities = new Array();
			// Get player entity
			var player_entities:Array = _entity_manager.GetAllEntitiesPossessingComponents(new Array(GameConst.COMP_COL_BOX, GameConst.COMP_PLAYER));
			_player_entity = player_entities[0];
			
			// Get all platform entities
			var box_collider_render_entities:Array = _entity_manager.GetAllEntitiesPossessingComponents(new Array(GameConst.COMP_COL_BOX, GameConst.COMP_RENDER));
			for (var i:int = 0; i < box_collider_render_entities.length; i++ )
			{
				if ((_entity_manager.GetComponent(box_collider_render_entities[i], GameConst.COMP_COL_BOX) as BoxColliderComponent).is_static)
				{
					_platform_entities.push(box_collider_render_entities[i]);
				}
			}
			
			// Get all enemy entities
			var _enemy_entities:Array = _entity_manager.GetAllEntitiesPossessingComponents(
				new Array(GameConst.COMP_COL_BOX, GameConst.COMP_RENDER, GameConst.COMP_ENEMY));
			
			
			
			// Get all projectile entities
			_projectile_entities = _entity_manager.GetAllEntitiesPossessingComponents(new Array(GameConst.COMP_COL_BOX, GameConst.COMP_PROJ));
			
			
			// Platform collisions collision
			playerPlatformCollisions(_player_entity, _platform_entities);
			projectilePlatformCollisions(_projectile_entities, _platform_entities);
			enemyPlatformCollisions(_enemy_entities, _platform_entities);
			
			projectileEnemyPlayerCollisions(_projectile_entities, _enemy_entities, _player_entity);
			
			
		}
		
		private function projectileEnemyPlayerCollisions(projectile_entities:Array, enemy_entities:Array, player_entity:int):void
		{
			// Iterate through projectiles
			for (var i:int = 0; i < projectile_entities.length; i++ )
			{
				var projectile_box_component:BoxColliderComponent = _entity_manager.GetComponent(projectile_entities[i], GameConst.COMP_COL_BOX) as BoxColliderComponent;
				var projectile_component:ProjectileComponent = _entity_manager.GetComponent(projectile_entities[i], GameConst.COMP_PROJ) as ProjectileComponent;
				
				// If attack player
				if (!projectile_component.attacksWho)
				{
					// Get player box component
					var player_box_collider:BoxColliderComponent =  _entity_manager.GetComponent(player_entity, GameConst.COMP_COL_BOX) as BoxColliderComponent;
					
					var intersectingX:Boolean = false;
					var intersectingY:Boolean = false;
					
					// Test if interestecting a static object
					if ((projectile_box_component.pos.x + projectile_box_component.min_x + projectile_box_component.vel.x < player_box_collider.pos.x + player_box_collider.max_x) 
					&& (projectile_box_component.pos.x + projectile_box_component.max_x + projectile_box_component.vel.x > player_box_collider.pos.x + player_box_collider.min_x))
					{
						intersectingX = true;
					}
					if ((projectile_box_component.pos.y + projectile_box_component.min_y + projectile_box_component.vel.y < player_box_collider.pos.y + player_box_collider.max_y) 
					&& (projectile_box_component.pos.y + projectile_box_component.max_y + projectile_box_component.vel.y > player_box_collider.pos.y + player_box_collider.min_y))
					{
						intersectingY = true;
					}
					// If it is intersecting
					if (intersectingX && intersectingY)
					{
						projectile_component.explosion_sound.play();
						// TODO: Explosion
						_entity_manager.KillEntity(projectile_entities[i]);
						// damage on enemy player
						var player_component:PlayerComponent = _entity_manager.GetComponent(player_entity, GameConst.COMP_PLAYER) as PlayerComponent;
						
						PlayerComponent.health -= 5 * PlayerComponent.level;
						
					}
				}
				else // else attack enemy
				{
					
					// Iterate through enemies
					for (var j:int = 0; j < enemy_entities.length; j++ )
					{
						var enemy_box_component:BoxColliderComponent = _entity_manager.GetComponent(enemy_entities[j], GameConst.COMP_COL_BOX) as BoxColliderComponent;
						
						// Check if components are still there
						if (enemy_box_component == null || projectile_box_component == null)
							return;
						
						var intersectingX:Boolean = false;
						var intersectingY:Boolean = false;
						
						// Test if interestecting a static object
						if ((projectile_box_component.pos.x + projectile_box_component.min_x + projectile_box_component.vel.x < enemy_box_component.pos.x + enemy_box_component.max_x) 
						&& (projectile_box_component.pos.x + projectile_box_component.max_x + projectile_box_component.vel.x > enemy_box_component.pos.x + enemy_box_component.min_x))
						{
							intersectingX = true;
						}
						if ((projectile_box_component.pos.y + projectile_box_component.min_y + projectile_box_component.vel.y < enemy_box_component.pos.y + enemy_box_component.max_y) 
						&& (projectile_box_component.pos.y + projectile_box_component.max_y + projectile_box_component.vel.y > enemy_box_component.pos.y + enemy_box_component.min_y))
						{
							intersectingY = true;
						}
						// If it is intersecting
						if (intersectingX && intersectingY)
						{
							projectile_component.explosion_sound.play();
							// TODO: Explosion
							_entity_manager.KillEntity(projectile_entities[i]);
							// damage on enemy player
							var enemy_component:EnemyComponent = _entity_manager.GetComponent(enemy_entities[j], GameConst.COMP_ENEMY) as EnemyComponent;
							
							enemy_component.health -= 20;
							if (enemy_component.health < 1)
							{
								_entity_manager.KillEntity(enemy_entities[j]);
							}
						}
					}	
				}
			}
		}
		
		// Collide between players and platform/teleporter
		private function playerPlatformCollisions(player_entity:int, platform_entities:Array):void
		{
			// Get player box component
			var player:BoxColliderComponent =  _entity_manager.GetComponent(player_entity, GameConst.COMP_COL_BOX) as BoxColliderComponent;
			
			// Reset bools
			player.isTouchingFloor = false;
			player.isTouchingRoof = false;
			player.isTouchingLeftWall = false;
			player.isTouchingRightWall = false;
			
			// Check between player object and platforms
			for (var i:int = 0; i < platform_entities.length; i++ )
			{
				// Get platform component
				
				var platform:BoxColliderComponent = _entity_manager.GetComponent(platform_entities[i], GameConst.COMP_COL_BOX) as BoxColliderComponent;
				
				// Check broad phase
				if (BroadPhase(player,  platform))
				{
					// Checks real collisions
					NarrowPlatformPhase(player,  platform, GameConst.COMP_PLAYER);
				}
			}
		}
		
		
		private function enemyPlatformCollisions(enemy_entities:Array, platform_entities:Array):void
		{
			// Go through enemies
			for (var i:int = 0; i < enemy_entities.length; i++ )
			{
				var enemy_box_component:BoxColliderComponent = _entity_manager.GetComponent(enemy_entities[i], GameConst.COMP_COL_BOX) as BoxColliderComponent;
				
				// Reset bools
				enemy_box_component.isTouchingFloor = false;
				enemy_box_component.isTouchingRoof = false;
				enemy_box_component.isTouchingLeftWall = false;
				enemy_box_component.isTouchingRightWall = false;
				
				// Reset collidiing with
				enemy_box_component.collidingWith = new Array();
				
				// Check between enemy objects and platforms
				for (var j:int = 0; j < platform_entities.length; j++ )
				{
					// Get platform component
					
					var platform_box_component:BoxColliderComponent = _entity_manager.GetComponent(platform_entities[j], GameConst.COMP_COL_BOX) as BoxColliderComponent;
					
					// Check broad phase
					if (BroadPhase(enemy_box_component,  platform_box_component))
					{
						// Checks real collisions
						if (NarrowPlatformPhase(enemy_box_component,  platform_box_component, GameConst.COMP_ENEMY))
							enemy_box_component.collidingWith.push(platform_box_component);
					}
				}
			}
		}
		
		private function projectilePlatformCollisions(projectile_entities:Array, platform_entities:Array):void
		{
			// Go through projectiles
			for (var i:int = 0; i < projectile_entities.length; i++ )
			{
				var projectile_box_component:BoxColliderComponent = _entity_manager.GetComponent(projectile_entities[i], GameConst.COMP_COL_BOX) as BoxColliderComponent;
				var projectile_component:ProjectileComponent = _entity_manager.GetComponent(projectile_entities[i], GameConst.COMP_PROJ) as ProjectileComponent;
				
				// Check between projectile objects and platforms
				for (var j:int = 0; j < platform_entities.length; j++ )
				{
					// Get platform component
					
					var platform_box_component:BoxColliderComponent = _entity_manager.GetComponent(platform_entities[j], GameConst.COMP_COL_BOX) as BoxColliderComponent;
					
					// Check broad phase
					if (BroadPhase(projectile_box_component,  platform_box_component))
					{
						projectile_component.bounce_sound.play();
						projectile_component.bounces++;
						// Checks real collisions
						NarrowPlatformPhase(projectile_box_component,  platform_box_component, GameConst.COMP_PROJ)
						
					}
				}
			}
		}
		
		// Returns true if they are close, returns false if they're not near
		private function BroadPhase(obj_dyn:BoxColliderComponent, obj_stat:BoxColliderComponent):Boolean
		{
			if (obj_dyn.pos.x + obj_dyn.max_x + obj_dyn.vel.x <= obj_stat.pos.x + obj_stat.min_x)
				return false;
			if (obj_dyn.pos.y + obj_dyn.max_y + obj_dyn.vel.y <= obj_stat.pos.y + obj_stat.min_y)
				return false;
			if (obj_dyn.pos.x + obj_dyn.min_x + obj_dyn.vel.x >= obj_stat.pos.x + obj_stat.max_x)
				return false;
			if (obj_dyn.pos.y + obj_dyn.min_y + obj_dyn.vel.y >= obj_stat.pos.y + obj_stat.max_y)
				return false;
			return true;
		}
		
		// Changes dynamic object accordingly, returns true if colliding
		private function NarrowPlatformPhase(dynamic_object:BoxColliderComponent, static_object:BoxColliderComponent, component_type:int):Boolean
		{
			if (component_type == GameConst.COMP_PLAYER)
			{
					if (static_object.is_teleporter)
					{
						PlayerComponent.nextLevel = true;
						return true;
					}
			}
			
			// If object interesects from the top
			if ((dynamic_object.pos.y + dynamic_object.max_y <= static_object.pos.y + static_object.min_y) 
			&& (dynamic_object.pos.y + dynamic_object.max_y + dynamic_object.vel.y > static_object.pos.y + static_object.min_y))
			{
				dynamic_object.pos.y = static_object.pos.y - dynamic_object.max_y;
				dynamic_object.isTouchingFloor = true;
				switch(component_type)
				{
					case GameConst.COMP_ENEMY:
					case GameConst.COMP_PLAYER:
						dynamic_object.vel.y = 0;
					break;
					case GameConst.COMP_PROJ:
						dynamic_object.vel.y = -0.5 * dynamic_object.vel.y;
					break;
				default:
					break;
				}
			} else
			// If object interesects from the bottom
			if ((dynamic_object.pos.y + dynamic_object.min_y >= static_object.pos.y + static_object.max_y) 
			&& (dynamic_object.pos.y + dynamic_object.min_y + dynamic_object.vel.y < static_object.pos.y + static_object.max_y))
			{
				dynamic_object.pos.y = static_object.pos.y + static_object.max_y;
				dynamic_object.isTouchingRoof = true;
				switch(component_type)
				{
					case GameConst.COMP_ENEMY:
					case GameConst.COMP_PLAYER:
						dynamic_object.vel.y = 0;
					break;
					case GameConst.COMP_PROJ:
						dynamic_object.vel.y = -0.5 * dynamic_object.vel.y;
					break;
				default:
					break;
				}
			}
			else
			// If object interesects from the left
			if ((dynamic_object.pos.x + dynamic_object.max_x <= static_object.pos.x + static_object.min_x) 
			&& (dynamic_object.pos.x + dynamic_object.max_x + dynamic_object.vel.x > static_object.pos.x + static_object.min_x))
			{
				dynamic_object.pos.x = static_object.pos.x - dynamic_object.max_x;
				dynamic_object.isTouchingLeftWall = true;
				switch(component_type)
				{
					case GameConst.COMP_ENEMY:
					case GameConst.COMP_PLAYER:
						dynamic_object.vel.x = 0;
					break;
					case GameConst.COMP_PROJ:
						dynamic_object.vel.x = -0.5 * dynamic_object.vel.x;
					break;
				default:
					break;
				}
			}
			else
			// If object interesects from the right
			if ((dynamic_object.pos.x + dynamic_object.min_x >= static_object.pos.x + static_object.max_x) 
			&& (dynamic_object.pos.x + dynamic_object.min_x + dynamic_object.vel.x < static_object.pos.x + static_object.max_x))
			{
				dynamic_object.pos.x = static_object.pos.x + static_object.max_x;
				dynamic_object.isTouchingRightWall = true;
				switch(component_type)
				{
					case GameConst.COMP_ENEMY:
					case GameConst.COMP_PLAYER:
						dynamic_object.vel.x = 0;
					break;
					case GameConst.COMP_PROJ:
						dynamic_object.vel.x = -0.5 * dynamic_object.vel.x;
					break;
				default:
					break;
				}
			}
			return true;
		}
		
	}

}