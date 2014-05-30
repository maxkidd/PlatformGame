package systems 
{
	/**
	 * ...
	 * @author Max Kidd
	 */
	import systems.EntityManager;
	public class ServiceLocator 
	{
		private static var _entity_manager:EntityManager;
		public function ServiceLocator() 
		{
		}
		
		public static function GetEntityManager():EntityManager
		{
			return _entity_manager;
		}
		
		public static function ProvideEntityManager(manager:EntityManager):void
		{
			_entity_manager = manager;
		}
		
	}

}