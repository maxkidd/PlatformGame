package components 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import mx.core.BitmapAsset;
	/**
	 * ...
	 * @author Max Kidd
	 */
	public class BackgroundComponent extends Sprite implements IComponent 
	{
		[Embed(source = "../../res/background2.png")]
		private static var EmbedImage:Class;
		// VAR
		public var bkg:Sprite;
		
		public var bkg_x:int;
		public var bkg_y:int;
		public var bkg_width:int;
		public var bkg_height:int;
		
		static private var bmpData:BitmapData;
		
		public function BackgroundComponent() 
		{
			
		}
		
		public function Initialize():void
		{
			var imgBitmap:BitmapAsset = new EmbedImage();
			var bitmapData:BitmapData = imgBitmap.bitmapData;
			
			bkg = new Sprite();
			bkg.graphics.beginBitmapFill(bitmapData);
			bkg.graphics.drawRect(bkg_x, bkg_y, bkg_width, bkg_height);
			
			addChild(bkg);
		}
		
		public function erase():void 
		{
			if (bkg != null)
			{
				removeChild(bkg);
				bkg = null;
			}
			this.parent.removeChild(this);
			delete this;
		}
		
		public function type():int 
		{
			return GameConst.COMP_BACK;
		}
		
	}

}