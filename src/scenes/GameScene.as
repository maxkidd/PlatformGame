package scenes 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import logic.Collisions;
	import logic.EnemyController;
	import logic.MapManager;
	import logic.PlayerController;
	import logic.ProjectileController;
	import logic.UI;
	import logic.UpdateComponents;
	import maths.Vec2;
	import prefabs.Platform;
	import prefabs.Player;
	import components.PlayerComponent;
	import systems.EntityManager;
	import systems.GraphicsManager;
	import systems.ServiceLocator;
	import Game;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class GameScene extends Sprite implements IScene
	{
		private var graphics_manager:GraphicsManager;
		private var entity_manager:EntityManager;
		private var map_manager:MapManager;
		private var UI_manager:UI;
		
		private var game_over:Boolean;
		
		private var collisions:Collisions;
		private var update_components:UpdateComponents;
		private var player_controller:PlayerController;
		private var projectile_controller:ProjectileController;
		private var enemy_controller:EnemyController;
		
		private var scene_manager:Game;
		
		public function GameScene(game:Game) 
		{
			// Increase level
			PlayerComponent.nextLevel = false;
			PlayerComponent.level++;
			
			// Set scene manager
			scene_manager = game;
			
			// Create Graphics manager
			graphics_manager = new GraphicsManager();
			addChild(graphics_manager);
			
			
			// Create entity manager
			entity_manager = new EntityManager();
			
			// Provide entity manager to service locator
			ServiceLocator.ProvideEntityManager(entity_manager);
			
			// Create entities and add components
			// WASD
			var player:Player = new Player(entity_manager, GameConst.PLAYER_START_POS_X, GameConst.PLAYER_START_POS_Y,
				87, 65, 68, 81, 69);
			
			// Block Player in (unfortunately) so can't escape game bounds (Glitchy rendering system after breaking integer bounds)
			var platform_bottom:Platform = new Platform(entity_manager, -1000, 33000, 35000, 1000);
			var platform_right :Platform = new Platform(entity_manager, 33000, -1000, 1000, 35000);
			var platform_bottom:Platform = new Platform(entity_manager, -1000, -1000, 35000, 1000);
			var platform_right :Platform = new Platform(entity_manager, -1000, -1000, 1000, 35000);
			
			// Create game logic
			player_controller = new PlayerController();
			projectile_controller = new ProjectileController();
			enemy_controller = new EnemyController();
			// After majority of game logic
			collisions = new Collisions();
			update_components = new UpdateComponents();
			
			// Create map manager
			map_manager = new MapManager();
			map_manager.Initialize(); // Initialise first map sectors
			// Create UI manager
			UI_manager = new UI();
			
			
			
			// Add frame listener
			addEventListener(Event.ENTER_FRAME, Frame);
			addEventListener(MouseEvent.CLICK, player_controller.MouseClick);
		}
		
		public function Frame(e:Event):void
		{
			
			// Update mouse for player controller
			player_controller.UpdateMouse(mouseX, mouseY);
			
			for (var i:int = 0; i < GameConst.keyPressed.length; i++)
			{
				// If esc
				if (GameConst.keyPressed[i] == 27)
				{
					PlayerComponent.health = 100;
					PlayerComponent.level = 0;
					GameConst.keyPressed.splice(i);
					
					removeEventListener(Event.ENTER_FRAME, Frame);
					scene_manager.ShowScene(new MenuScene(scene_manager));
					return;
				}
			}
			
			// Check if game should exit
			if (PlayerComponent.nextLevel)
			{
				PlayerComponent.nextLevel = false;
				removeEventListener(Event.ENTER_FRAME, Frame);
				scene_manager.ShowScene(new GameScene(scene_manager));
				return;
			}
			if (PlayerComponent.health <= 0)
			{
				PlayerComponent.health = 100;
				PlayerComponent.level = 0;
				
				removeEventListener(Event.ENTER_FRAME, Frame);
				scene_manager.ShowScene(new MenuScene(scene_manager));
				return;
			}
			
			// Update map logic
			map_manager.Process();
			
			// Update game logic
			player_controller.Process();
			projectile_controller.Process();
			enemy_controller.Process();
			
			// Collisions
			collisions.Process();
			
			// Update position
			update_components.Process();
			
			UI_manager.Process();
			
			// Update screen
			UpdateCamera();
			graphics_manager.Draw(entity_manager);
		}
		
		public function UpdateCamera():void
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
	}

}