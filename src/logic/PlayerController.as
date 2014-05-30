package logic 
{
	import components.BoxColliderComponent;
	import components.PlayerComponent;
	import components.RenderComponent;
	import flash.events.Event;
	import maths.Vec2;
	import prefabs.Projectile;
	import systems.EntityManager;
	import systems.ServiceLocator;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class PlayerController implements ILogic 
	{
		private var players:Array;
		private var entity_manager:EntityManager;
		
		private var player_entity:int;
		private var box_collider_component:BoxColliderComponent;
		private var player_component:PlayerComponent;
		private var render_component:RenderComponent;
		
		private var mouseX:Number;
		private var mouseY:Number;
		
		public function PlayerController() 
		{
			entity_manager = ServiceLocator.GetEntityManager();
		}
		
		/* INTERFACE logic.ILogic */
		
		public function Process():void 
		{
			if (players == null)
			{
				// Players with box colliders
				var box_players:Array = [GameConst.COMP_PLAYER, GameConst.COMP_COL_BOX];
				players = entity_manager.GetAllEntitiesPossessingComponents(box_players);
				
				
				
				if (players == null)
					return;
				
				player_entity = players[0]
				
				box_collider_component = entity_manager.GetComponent(player_entity, GameConst.COMP_COL_BOX) as BoxColliderComponent;
				player_component = entity_manager.GetComponent(player_entity, GameConst.COMP_PLAYER) as PlayerComponent;
				render_component = entity_manager.GetComponent(player_entity, GameConst.COMP_RENDER) as RenderComponent;
				
				render_component.play();
			}
			
			
				
			// Play running and update speed
			render_component.speed = Math.abs(player_component.vel.x / 20);
			
			// Reset acceleration
			player_component.acceleration.x = 0;
			player_component.acceleration.y = 0;
			
			if (PlayerComponent.health < 1)
			{
				trace("dead");
			}
			
			if(player_component.shift_timer > 0)
			{
				// Decrease timer
				player_component.shift_timer--;
			}
			if(player_component.shoot_timer > 0)
			{
				// Decrease timer
				player_component.shoot_timer--;
			}
			
			if (player_component.shift_recharge > 0)
			{
				player_component.shift_recharge--;
			}
			
			if (box_collider_component.isTouchingFloor)
			{
				player_component.has_doublejumped = false;
			}
			
			
			// Gravity
			player_component.acceleration.y = 0.5;
			
			
			// Update velocity
			player_component.vel.x += player_component.acceleration.x;
			player_component.vel.y += player_component.acceleration.y;
			
			// If player isn't moving to the left or right, velocity = 0
			var player_moving:Boolean = false;
			
			// Input logic
			for (var i:int = 0; i < GameConst.keyDown.length; i++ )
			{
				
				if (GameConst.keyDown[i] == player_component.left_key)
				{
					player_moving = true;
					// Flip to the left side
					render_component.movie_clip.x = render_component.width;
					render_component.movie_clip.scaleX = -1;
					
					// Accelerate to the left if player is touching the floor
					if (box_collider_component.isTouchingFloor)
					{
						if(player_component.vel.x > -10)
							player_component.vel.x += -4;
					}
					else
					{
						if(player_component.vel.x > -10)
							player_component.vel.x += -1;
					}
				}
				else if (GameConst.keyDown[i] == player_component.right_key)
				{
					player_moving = true;
					// Flip to the right side
					render_component.movie_clip.x = 0;
					render_component.movie_clip.scaleX = 1;
					
					// Accelerate to the right if player is touching the floor
					if (box_collider_component.isTouchingFloor)
					{
						if(player_component.vel.x < 10)
							player_component.vel.x += 4;
					}
					else
					{
						if(player_component.vel.x < 10)
							player_component.vel.x += 1;
					}
				}
			}
			if (!player_moving)
			{
				player_component.vel.x = 0;
			}
			// Limit velocity due to factors
			for (var i:int = 0; i < GameConst.keyPressed.length; i++ )
			{
				// Player presses jump key
				if (GameConst.keyPressed[i] == player_component.up_key)
				{
					// Check what player is touching
					if (box_collider_component.isTouchingFloor)
					{
						// Jump force
						if(player_component.vel.y > -10)
							player_component.vel.y += -10;
						player_component.has_doublejumped = false;
					}
					else if (box_collider_component.isTouchingLeftWall)
					{
						player_component.vel.x = -20;
						player_component.vel.y = -10;
						player_component.has_doublejumped = false;
					}
					else if (box_collider_component.isTouchingRightWall)
					{
						player_component.vel.x = 20;
						player_component.vel.y = -10;
						player_component.has_doublejumped = false;
					}
					else if (!player_component.has_doublejumped)
					{
						if(player_component.vel.y > -10)
							player_component.vel.y = -10;
						player_component.has_doublejumped = true;
					}
				}
				GameConst.keyPressed.splice(i, 1);
			}
		}
		
		// Fire projectile
		public function MouseClick(e:Event):void
		{
			if (player_component.shoot_timer < 1)
			{
				// Work out the distance to determine how fast to fire
				var difference:Vec2 = new Vec2(mouseX - player_component.pos.x, mouseY - player_component.pos.y);
				
				// Create new projectile
				new Projectile(new Vec2(player_component.pos.x + 25, player_component.pos.y + 10), new Vec2(difference.x / 20, difference.y / 20), true);
				
				player_component.shoot_timer = 30;
			}
		}
		// Update mouse co-ordinates for projectile firing
		public function UpdateMouse(mouseX:Number, mouseY:Number):void
		{
			this.mouseX = mouseX;
			this.mouseY = mouseY;
		}
		
	}

}