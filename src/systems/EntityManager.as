package systems 
{
	/**
	 * ...
	 * @author Max Kidd
	 */
	import flash.utils.Dictionary;
	import components.IComponent
	
	public class EntityManager 
	{
		// Map of all component types to a map of entities mapped to the component
		private var _component_store:Dictionary = new Dictionary();
		// List of all entity IDs
		private var _all_entities:Array = new Array();
		// Lowest currently unassigned ID
		private var _lowest_unassigned_entity_id:int;
		
		public function EntityManager() 
		{
			_lowest_unassigned_entity_id = 1;
		}
		
		// Gets a given component reference from a given entity and component type
		public function GetComponent(entity:int, component_type:int):IComponent
		{
			// Get the map of entities mapped to the component
			var entities_store:Dictionary = _component_store[component_type];
			
			if (entities_store == null)
				return null;
			
			// Return the IComponent
			var map_store:IComponent = entities_store[entity];
			return map_store;
		}
		
		// Returns an array of all components of given type
		public function GetAllComponentsOfType(component_type:int):Array
		{
			var map_store:Dictionary = _component_store[component_type];
			
			var comps:Array = new Array();
			
			for each( var component : IComponent in map_store)
			{
				if(component != null)
					comps.push(component);
			}
			return comps;
		}
		
		// Returns an array of all entities possessing component types
		public function GetAllEntitiesPossessingComponents(component_array:Array):Array
		{
			var entities:Array = new Array();
			
			for each(var entity:int in _all_entities)
			{
				var has_components:Boolean = true;
				for each (var component:uint in component_array)
				{
					has_components = has_components && (GetComponent(entity, component) != null);
				}
				if (has_components)
				{
					entities.push(entity);
				}
			}
			return entities;
		}
		
		// Returns an array of all entities possessing component type
		public function GetAllEntitiesPossessingComponent(component_type:int):Array 
		{
			var map_store:Dictionary = _component_store[component_type];
			
			var entities:Array = new Array();
			
			for each( var entity : int in map_store)
			{
				entities.push(entity);
			}
			
			return entities;
		}
		
		// Adds given component to an entity
		public function AddComponent(entity:int, comp:IComponent, replace:Boolean):void
		{
			var map_store:Dictionary = _component_store[comp.type()];
			
			if (map_store == null)
			{
				_component_store[comp.type()] = new Dictionary;
			}
			_component_store[comp.type()][entity] = comp;
			
		}
		public function RemoveComponent(entity:int, comp:IComponent):void
		{
			var map_store:Dictionary = _component_store[comp.type()];
			
			if (map_store == null)
			{
				return;
			}
			_component_store[comp.type()][entity].erase();
			delete _component_store[comp.type()][entity];
			_component_store[comp.type()][entity] = null;
			
		}
		
		public function CreateEntity():int
		{
			var new_id:int  = GenerateNewEntityID();
			
			if (new_id < 1)
			{
				return 0;
			}
			_all_entities.push(new_id);
			
			return new_id;
		}
		
		public function KillEntity(entity:int): void
		{
			// Kill components
			var component:IComponent;
			for (var i:int = 1; i <= GameConst.LAST_COMPONENT; i++ )
			{
				component = GetComponent(entity, i);
				if (component != null)
				{
					RemoveComponent(entity, component);
				}
			}
			
		}
		
		private function GenerateNewEntityID():int
		{
			return _lowest_unassigned_entity_id++;
		}
		
	}

}