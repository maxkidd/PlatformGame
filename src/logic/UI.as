package logic 
{
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import components.PlayerComponent;
	import flash.text.TextFormat;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 * 
	 * UI
	 * 
	 * Player health on top left side of screen
	 * Player score on top right side of screen
	 * 
	 */
	public class UI implements ILogic 
	{
		private var players:Array;
		private var entity_manager:EntityManager;
		private var player_entity:int;
		private var player_component:PlayerComponent;
		
		private var format_left:TextFormat = new TextFormat();
		private var format_right:TextFormat = new TextFormat();
		public function UI() 
		{
			entity_manager = ServiceLocator.GetEntityManager();
			
			format_left.size = 40;
			format_right.size = 40;
			format_right.align = TextFormatAlign.RIGHT;
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			if (players == null)
			{
				// Players with box colliders
				var players_array:Array = [GameConst.COMP_PLAYER];
				players = entity_manager.GetAllEntitiesPossessingComponents(players_array);
				
				if (players == null)
					return;
				
				player_entity = players[0]
				
				player_component = entity_manager.GetComponent(player_entity, GameConst.COMP_PLAYER) as PlayerComponent;
				
				player_component.score_text.type = TextFieldType.DYNAMIC;
				player_component.score_text.defaultTextFormat = format_left;
				player_component.score_text.mouseEnabled = false;
				player_component.score_text.width = 500;
				player_component.score_text.height = 200;
				
				
				player_component.health_text.type = TextFieldType.DYNAMIC;
				player_component.health_text.defaultTextFormat = format_right;
				player_component.health_text.mouseEnabled = false;
				player_component.health_text.width = 500;
				player_component.health_text.height = 200;
			}
			
			player_component.score_text.x = player_component.pos.x - 800;
			player_component.score_text.y = player_component.pos.y - 800;
			player_component.score_text.text = "Level: " + PlayerComponent.level;
			
			player_component.health_text.x = player_component.pos.x + 297;
			player_component.health_text.y = player_component.pos.y - 800;
			player_component.health_text.text = "HEALTH: " + PlayerComponent.health.toString();
		}
		
	}

}