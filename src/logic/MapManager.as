package logic 
{
	import components.PlayerComponent;
	import flash.utils.Dictionary;
	import maths.Vec2;
	import prefabs.Background;
	import prefabs.Enemy;
	import prefabs.Platform;
	import prefabs.Teleporter;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class MapManager implements ILogic
	{
		// Var
		public var previous_player_position_x:int = 0;
		public var previous_player_position_y:int = 0;
		
		private var map_sector:Dictionary = new Dictionary();
		private var background_sector:Dictionary = new Dictionary();
		private var enemy_sector:Dictionary = new Dictionary();
		private var teleport_sector:Dictionary = new Dictionary();
		
		private var entity_manager:EntityManager;
		
		private var player_entity:int;
		private var players:Array;
		private var player_component:PlayerComponent;
		
		public function MapManager() 
		{
			entity_manager = ServiceLocator.GetEntityManager();
			previous_player_position_x = GameConst.PLAYER_START_POS_X /GameConst.TILE_BLOCK_SIZE / GameConst.SECTOR_WIDTH;
			previous_player_position_y = GameConst.PLAYER_START_POS_X / GameConst.TILE_BLOCK_SIZE / GameConst.SECTOR_HEIGHT;
			
		}
		
		public function Initialize():void
		{
			// Create map for the start
			CreateMapSector(previous_player_position_x-1, previous_player_position_y-1);
			CreateMapSector(previous_player_position_x-1, previous_player_position_y);
			CreateMapSector(previous_player_position_x - 1, previous_player_position_y+1);
			
			CreateMapSector(previous_player_position_x, previous_player_position_y-1);
			CreateMapSector(previous_player_position_x, previous_player_position_y);
			CreateMapSector(previous_player_position_x, previous_player_position_y+1);
			
			CreateMapSector(previous_player_position_x+1, previous_player_position_y-1);
			CreateMapSector(previous_player_position_x+1, previous_player_position_y);
			CreateMapSector(previous_player_position_x+1, previous_player_position_y+1);
		}
		
		public function Process():void
		{
			// Get player
			if (players == null)
			{
				entity_manager = ServiceLocator.GetEntityManager();
				players = entity_manager.GetAllEntitiesPossessingComponents([GameConst.COMP_PLAYER]);
				
				if (players == null)
					return;
			}
			var player_component:PlayerComponent = entity_manager.GetComponent(players[0], GameConst.COMP_PLAYER) as PlayerComponent;
			
			
			// Get current player position in relation to the sectors
			var current_player_position_x:int = player_component.pos.x / (GameConst.TILE_BLOCK_SIZE * GameConst.SECTOR_WIDTH);
			var current_player_position_y:int = player_component.pos.y / (GameConst.TILE_BLOCK_SIZE * GameConst.SECTOR_HEIGHT);
			
			
			// If the players x position within the sector has changed
			if (current_player_position_x != previous_player_position_x)
			{
				// If greater than
				if (current_player_position_x > previous_player_position_x)
				{
					DeleteMapSector(previous_player_position_x-1, previous_player_position_y-1);
					DeleteMapSector(previous_player_position_x-1, previous_player_position_y);
					DeleteMapSector(previous_player_position_x-1, previous_player_position_y+1);
						
					CreateMapSector(current_player_position_x+1, current_player_position_y-1);
					CreateMapSector(current_player_position_x+1, current_player_position_y);
					CreateMapSector(current_player_position_x+1, current_player_position_y+1);
				}
				else // Less than
				{
					DeleteMapSector(previous_player_position_x+1, previous_player_position_y-1);
					DeleteMapSector(previous_player_position_x+1, previous_player_position_y);
					DeleteMapSector(previous_player_position_x+1, previous_player_position_y+1);
					
					CreateMapSector(current_player_position_x-1, current_player_position_y-1);
					CreateMapSector(current_player_position_x-1, current_player_position_y);
					CreateMapSector(current_player_position_x-1, current_player_position_y+1);
				}
				
				// Update x
				previous_player_position_x = current_player_position_x;
			}
			
			// If the players y position within the sector has changed
			if (current_player_position_y != previous_player_position_y)
			{
				// If greater than
				if (current_player_position_y > previous_player_position_y)
				{
					DeleteMapSector(previous_player_position_x-1, previous_player_position_y-1);
					DeleteMapSector(previous_player_position_x, previous_player_position_y-1);
					DeleteMapSector(previous_player_position_x+1, previous_player_position_y-1);
						
					CreateMapSector(current_player_position_x-1, current_player_position_y+1);
					CreateMapSector(current_player_position_x, current_player_position_y+1);
					CreateMapSector(current_player_position_x+1, current_player_position_y+1);
				}
				else // Less than
				{
					DeleteMapSector(previous_player_position_x-1, previous_player_position_y+1);
					DeleteMapSector(previous_player_position_x, previous_player_position_y+1);
					DeleteMapSector(previous_player_position_x+1, previous_player_position_y+1);
						
					CreateMapSector(current_player_position_x-1, current_player_position_y-1);
					CreateMapSector(current_player_position_x, current_player_position_y-1);
					CreateMapSector(current_player_position_x+1, current_player_position_y-1);
				}
				
				// Update y
				previous_player_position_y = current_player_position_y;
			}
		}
		
		private function CreateMapSector(x:int, y:int):void
		{
			map_sector[x + GameConst.MAP_WIDTH * y] = new Array();
			
			var horizontal_platforms:int = Math.ceil(Math.random() * GameConst.MAX_PLATFORMS_PER_SECTOR);
			
			// Random horizontal platforms platforms
			for (var i:int = 0; i <= horizontal_platforms; i++ )
			{
				// Random tile (in multiples of 50)
				var xTileStart:Number = (x * GameConst.SECTOR_WIDTH) + Math.ceil(Math.random() * (GameConst.SECTOR_WIDTH));
				var yTileStart:Number = (y * GameConst.SECTOR_HEIGHT) + Math.ceil(Math.random() * (GameConst.SECTOR_HEIGHT));
				var TileLength:Number = Math.ceil(Math.random() * 15);
				var TileHeight:Number = Math.ceil(Math.random() * 1);
				
				map_sector[x + GameConst.MAP_WIDTH * y][i] = new Platform(entity_manager, xTileStart*50, yTileStart*50, TileLength*50, TileHeight*50);
			}
			// Random vertical platforms
			for (var i:int = ++horizontal_platforms; i <= GameConst.MAX_PLATFORMS_PER_SECTOR; i++ )
			{
				// Random tile (in multiples of 50)
				var xTileStart:Number = (x * GameConst.SECTOR_WIDTH) + Math.ceil(Math.random() * (GameConst.SECTOR_WIDTH));
				var yTileStart:Number = (y * GameConst.SECTOR_HEIGHT) + Math.ceil(Math.random() * (GameConst.SECTOR_HEIGHT));
				var TileLength:Number = Math.ceil(Math.random() * 1);
				var TileHeight:Number = Math.ceil(Math.random() * 15);
				
				map_sector[x + GameConst.MAP_WIDTH * y][i] = new Platform(entity_manager, xTileStart * GameConst.TILE_BLOCK_SIZE,
					yTileStart*GameConst.TILE_BLOCK_SIZE, TileLength*GameConst.TILE_BLOCK_SIZE, TileHeight*GameConst.TILE_BLOCK_SIZE);
			}
			
			// Create background image
			background_sector[x + GameConst.MAP_WIDTH * y] = new Background(entity_manager, x * GameConst.SECTOR_WIDTH * GameConst.TILE_BLOCK_SIZE,
				y * GameConst.SECTOR_HEIGHT * GameConst.TILE_BLOCK_SIZE, GameConst.SECTOR_WIDTH * GameConst.TILE_BLOCK_SIZE, GameConst.SECTOR_HEIGHT * GameConst.TILE_BLOCK_SIZE);
			
			
			enemy_sector[x + GameConst.MAP_WIDTH * y] = new Array();
			// Create enemies
			for (var i:int = 0; i <= 1; i++ )
			{
				// Random tile
				var xTileStart:Number = (x * GameConst.SECTOR_WIDTH) + Math.ceil(Math.random() * GameConst.SECTOR_WIDTH);
				var yTileStart:Number = (y * GameConst.SECTOR_HEIGHT) + Math.ceil(Math.random() * GameConst.SECTOR_HEIGHT);
				
				enemy_sector[x + GameConst.MAP_WIDTH * y][i] = new Enemy(entity_manager, xTileStart * GameConst.TILE_BLOCK_SIZE, yTileStart * GameConst.TILE_BLOCK_SIZE);
			}
			
			// Create teleport area
			teleport_sector[x + GameConst.MAP_WIDTH * y] = new Array();
			if (Math.random() < 0.15)
			{
				var xTileStart:Number = (x * GameConst.SECTOR_WIDTH) + Math.ceil(Math.random() * GameConst.SECTOR_WIDTH);
				var yTileStart:Number = (y * GameConst.SECTOR_HEIGHT) + Math.ceil(Math.random() * GameConst.SECTOR_HEIGHT);
				
				teleport_sector[x + GameConst.MAP_WIDTH * y][0] = new Teleporter(entity_manager, xTileStart * GameConst.TILE_BLOCK_SIZE, yTileStart * GameConst.TILE_BLOCK_SIZE, 50, 50);
			}
		}
		
		// Deletes all platforms
		private function DeleteMapSector(x:int, y:int):void
		{
			// Delete platforms
			var sector_platform_store:Array = map_sector[x + GameConst.MAP_WIDTH * y];
			if (sector_platform_store != null)
			{
				
				for (var i:int = 0; i < map_sector[x + GameConst.MAP_WIDTH * y].length; i++ )
				{
					if (map_sector[x + GameConst.MAP_WIDTH * y][i] != null)
					{
						// Destruct platform
						map_sector[x + GameConst.MAP_WIDTH * y][i].erase();
						delete map_sector[x + GameConst.MAP_WIDTH * y][i];
					}
				}
			}
			
			// Delete enemies
			var sector_enemy_store:Array = enemy_sector[x + GameConst.MAP_WIDTH * y];
			if (sector_enemy_store != null)
			{
				
				for (var i:int = 0; i < enemy_sector[x + GameConst.MAP_WIDTH * y].length; i++ )
				{
					if (enemy_sector[x + GameConst.MAP_WIDTH * y][i] != null)
					{
						// Destruct platform
						enemy_sector[x + GameConst.MAP_WIDTH * y][i].erase();
						delete enemy_sector[x + GameConst.MAP_WIDTH * y][i];
					}
				}
			}
			
			// Delete backgrounds
			if (background_sector[x + GameConst.MAP_WIDTH * y] != null)
			{
				// Destruct background
				background_sector[x + GameConst.MAP_WIDTH * y].erase();
				delete background_sector[x + GameConst.MAP_WIDTH * y];
			}
			
			// Delete teleporter
			var sector_teleport_score:Array = enemy_sector[x + GameConst.MAP_WIDTH * y];
			if (sector_teleport_score != null)
			{
				
				for (var i:int = 0; i < enemy_sector[x + GameConst.MAP_WIDTH * y].length; i++ )
				{
					if (teleport_sector[x + GameConst.MAP_WIDTH * y][i] != null)
					{
						// Destruct platform
						teleport_sector[x + GameConst.MAP_WIDTH * y][i].erase();
						delete teleport_sector[x + GameConst.MAP_WIDTH * y][i];
					}
				}
			}
		}
		
	}

}