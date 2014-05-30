package systems
{
	import components.BackgroundComponent;
	import components.IComponent;
	import components.PlayerComponent;
	import components.RenderComponent;
	import flash.text.TextField;
	import GameConst;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class GraphicsManager extends Sprite
	{
		
		public function GraphicsManager() 
		{
			
		}
		
		public function Draw(entity_manager:EntityManager):void
		{
			// Get all renderable components
			var renderable_components:Array = entity_manager.GetAllComponentsOfType(GameConst.COMP_RENDER);
			var background_components:Array = entity_manager.GetAllComponentsOfType(GameConst.COMP_BACK);
			
			// Get all player components with a score
			var player_components:Array = entity_manager.GetAllComponentsOfType(GameConst.COMP_PLAYER);
			
			// Iterate through the components
			if (renderable_components != null)
			{
				for (var i:int = 0; i < renderable_components.length; i++) 
				{
					var renderablecomponent:RenderComponent = renderable_components[i];
					if (!renderablecomponent.stage)
					{
						addChild(renderablecomponent);
					}
				}
			}
			
			// Iterate through the components
			if (background_components != null)
			{
				for (var i:int = 0; i < background_components.length; i++) 
				{
					var backgroundcomponent:BackgroundComponent = background_components[i];
					if (!backgroundcomponent.stage)
					{
						addChildAt(backgroundcomponent, 0);
					}
				}
			}
			
			// Iterate through the components
			if (player_components != null)
			{
				for (var i:int = 0; i < player_components.length; i++) 
				{
					var playercomponent:PlayerComponent = player_components[i];
					if (!playercomponent.score_text.stage)
					{
						addChildAt(playercomponent.score_text, numChildren-1);
						addChildAt(playercomponent.health_text, numChildren-1);
					}
					setChildIndex(playercomponent.score_text, numChildren - 1);
					setChildIndex(playercomponent.health_text, numChildren - 1);
				}
			}
			
		}
		
	}

}