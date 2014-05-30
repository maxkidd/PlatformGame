package prefabs 
{
	import components.BackgroundComponent;
	import systems.EntityManager;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class Background 
	{
		private var entity_manager:EntityManager;
		private var background_component:BackgroundComponent;
		
		private var entity:int;
		
		public function Background(entity_manager:EntityManager, x:int, y:int, width:int, height:int) 
		{
			this.entity_manager = entity_manager;
			
			var background_component:BackgroundComponent = new BackgroundComponent();
			background_component.bkg_x = x;
			background_component.bkg_y = y;
			background_component.bkg_width = width;
			background_component.bkg_height = height;
			background_component.Initialize();
			
			entity = entity_manager.CreateEntity();
			entity_manager.AddComponent(entity, background_component, false);
		}
		
		public function erase():void
		{
			entity_manager.KillEntity(entity);
			
			background_component = null;
		}
	}

}