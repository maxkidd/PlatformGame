package scenes 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import logic.MapManager;
	import prefabs.Player;
	
	import components.PlayerComponent;
	import components.RenderComponent;
	
	import Game;
	
	import systems.EntityManager;
	import systems.GraphicsManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class MenuScene extends Sprite implements IScene
	{
		private var graphics_manager:GraphicsManager;
		private var entity_manager:EntityManager;
		private var map_manager:MapManager;
		
		private var scene_manager:Game;
		
		private var player_component:PlayerComponent;
		
		var play_clip:MovieClip;
		var instructions_clip:MovieClip;
		var instructions_manual_clip:MovieClip;
		
		var instructionsVisible:Boolean = false;
		
		public function MenuScene(game:Game) 
		{
			// Set scene manager
			scene_manager = game;
			
			// Create Graphics manager
			graphics_manager = new GraphicsManager();
			addChild(graphics_manager);
			
			// Create entity manager
			entity_manager = new EntityManager();
			
			// Provide entity manager to service locator
			ServiceLocator.ProvideEntityManager(entity_manager);
			
			// Creates a player for the camera to follow
			var player:Player = new Player(entity_manager, GameConst.PLAYER_START_POS_X, GameConst.PLAYER_START_POS_Y,
				87, 65, 68, 81, 69);
			var player_entity:int = player.GetEntity();
			
			player_component = entity_manager.GetComponent(player_entity, GameConst.COMP_PLAYER) as PlayerComponent;
			
			// Create map manager
			map_manager = new MapManager();
			map_manager.Initialize(); // Initialise first map sectors
			
			// Create graphics
			play_clip = new play_mc;
			addChild(play_clip);
			instructions_clip = new instructions_mc;
			addChild(instructions_clip);
			instructions_manual_clip = new instructions_manual_mc;
			addChild(instructions_manual_clip);
			
			
			// Add frame listener
			addEventListener(Event.ENTER_FRAME, Frame);
			
			play_clip.addEventListener(MouseEvent.CLICK, Play);
			instructions_clip.addEventListener(MouseEvent.CLICK, DisplayInstructions);
		}
		
		public function Frame(e:Event):void
		{
			// Update player position for camera
			player_component.pos.x++;
			
			// Update map logic
			map_manager.Process();
			
			// Update screen
			UpdateCamera();
			graphics_manager.Draw(entity_manager);
			
			// Check whether show instructions or menu
			if (instructionsVisible)
			{
				play_clip.x = 0;
				instructions_clip.x = 0;
				
				instructions_manual_clip.x = player_component.pos.x - 775;
				instructions_manual_clip.y = player_component.pos.y - 750;
				setChildIndex(instructions_manual_clip, numChildren - 1);
			}
			else
			{
				instructions_manual_clip.x = 0;
				
				play_clip.x = player_component.pos.x - 275;
				play_clip.y = player_component.pos.y - 500;
				instructions_clip.x = player_component.pos.x - 575;
				instructions_clip.y = player_component.pos.y - 200;
				
				setChildIndex(play_clip, numChildren - 1);
				setChildIndex(instructions_clip, numChildren - 1);
			}
		}
		
		private function UpdateCamera():void
		{
			// Get player player entities
			var player_components:Array = entity_manager.GetAllEntitiesPossessingComponents(new Array(GameConst.COMP_RENDER, GameConst.COMP_PLAYER));
			
			var furthest_player_pos_x:int = 0
			var furthest_player_pos_y:int = 0
			
			for each (var player:int in player_components)
			{
				var player_component:PlayerComponent = entity_manager.GetComponent(player, GameConst.COMP_PLAYER) as PlayerComponent;
				
				furthest_player_pos_x = player_component.pos.x;
				furthest_player_pos_y = player_component.pos.y;
			}
			
			this.x = (-furthest_player_pos_x + (GameConst.SCREEN_WIDTH / 2 / GameConst.CAM_SCALE)) * GameConst.CAM_SCALE;
			this.y = (-furthest_player_pos_y + (GameConst.SCREEN_WIDTH / 2 / GameConst.CAM_SCALE)) * GameConst.CAM_SCALE;
			this.scaleY = this.scaleX = GameConst.CAM_SCALE;
		}
		
		private function Play(e:MouseEvent):void
		{
			play_clip.removeEventListener(MouseEvent.CLICK, Play);
			removeEventListener(Event.ENTER_FRAME, Frame);
			scene_manager.ShowScene(new GameScene(scene_manager));
			return;
		}
		
		private function DisplayInstructions(e:MouseEvent):void
		{
			instructions_clip.removeEventListener(MouseEvent.CLICK, DisplayInstructions);
			instructionsVisible = true;
			instructions_manual_clip.addEventListener(MouseEvent.CLICK, DisplayMenu);
		}
		private function DisplayMenu(e:MouseEvent):void
		{
			instructions_manual_clip.removeEventListener(MouseEvent.CLICK, DisplayMenu);
			instructionsVisible = false;
			instructions_clip.addEventListener(MouseEvent.CLICK, DisplayInstructions);
		}
	}

}