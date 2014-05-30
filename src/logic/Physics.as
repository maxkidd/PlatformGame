package logic 
{
	import components.PlayerComponent;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Physics implements ILogic
	{
		private var _players:Array;
		private var _entity_manager:EntityManager;
		public function Physics() 
		{
		}
		
		public function Process(deltaTime:Number):void
		{
			if (_players == null)
			{
				_entity_manager = ServiceLocator.GetEntityManager();
				_players = _entity_manager.GetAllComponentsOfType(Types.COMP_PLAYER);
				
				if (_players == null)
					return;
			}
			
			for each (var player:PlayerComponent in _players)
			{
				player.vel.y += Types.GRAVITY;
				
				if (player.vel.y > player.max_fall_speed)
				{
					player.vel.y = player.max_fall_speed;
				}
			}
		}
		
	}

}