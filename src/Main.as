package
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author TadeuBAS
	 */
	public class Main extends Sprite 
	{
		
		public static var starling:Starling;
		
		public function Main() 
		{
			starling = new Starling(Game, stage, null, null, Context3DRenderMode.AUTO);
			starling.showStats = true;
			starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
			starling.start();
		}
		
		
		private function onRootCreated(event:Event, game:Game):void
        {
			starling.removeEventListener(Event.ROOT_CREATED, onRootCreated);
			// starling entry point
            
			game.begin();
        }
		
	}
	
}