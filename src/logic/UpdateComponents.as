package logic 
{
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
	public class UpdateComponents implements ILogic 
	{
		private var _players:Array;
		private var _entity_manager:EntityManager;
		
		public function UpdateComponents() 
		{
			
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			UpdatePlayers();
			UpdateProjectiles();
			UpdateEnemies();
		}
		
		private function UpdatePlayers():void
		{
			if (_players == null)
			{
				_entity_manager = ServiceLocator.GetEntityManager();
				var renderable_players:Array = [GameConst.COMP_PLAYER, GameConst.COMP_RENDER];
				_players = _entity_manager.GetAllEntitiesPossessingComponents(renderable_players);
				
				if (_players == null)
					return;
			}
			
			for each (var player:int in _players)
			{
				// Get player and render components
				var render_component:RenderComponent = _entity_manager.GetComponent(player, GameConst.COMP_RENDER) as RenderComponent;
				var player_component:PlayerComponent = _entity_manager.GetComponent(player, GameConst.COMP_PLAYER) as PlayerComponent;
				
				player_component.pos.x += player_component.vel.x;
				player_component.pos.y += player_component.vel.y;
				
				render_component.x = player_component.pos.x;
				render_component.y = player_component.pos.y;
				
				
			}
		}
		
		private function UpdateProjectiles():void
		{
			// Update projectiles
			var projectiles_array:Array = [GameConst.COMP_PROJ, GameConst.COMP_RENDER];
			var projectiles:Array = _entity_manager.GetAllEntitiesPossessingComponents(projectiles_array);
			if (projectiles == null)
				return;
			for each (var projectile:int in projectiles)
			{
				// Get player and render components
				var render_component:RenderComponent = _entity_manager.GetComponent(projectile, GameConst.COMP_RENDER) as RenderComponent;
				var projectile_component:ProjectileComponent = _entity_manager.GetComponent(projectile, GameConst.COMP_PROJ) as ProjectileComponent;
				
				
				projectile_component.pos.x += projectile_component.vel.x;
				projectile_component.pos.y += projectile_component.vel.y;
				
				render_component.x = projectile_component.pos.x;
				render_component.y = projectile_component.pos.y;
			}
		}
		
		private function UpdateEnemies():void
		{
			// Update projectiles
			var enemy_array:Array = [GameConst.COMP_ENEMY, GameConst.COMP_RENDER];
			var enemies:Array = _entity_manager.GetAllEntitiesPossessingComponents(enemy_array);
			if (enemies == null)
				return;
			for each (var enemy:int in enemies)
			{
				var render_component:RenderComponent = _entity_manager.GetComponent(enemy, GameConst.COMP_RENDER) as RenderComponent;
				var enemy_component:EnemyComponent = _entity_manager.GetComponent(enemy, GameConst.COMP_ENEMY) as EnemyComponent;
				
				enemy_component.pos.x += enemy_component.vel.x;
				enemy_component.pos.y += enemy_component.vel.y;
				
				render_component.x = enemy_component.pos.x;
				render_component.y = enemy_component.pos.y;
			}
		}
		
	}

}