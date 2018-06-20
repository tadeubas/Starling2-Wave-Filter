package 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.extensions.wave.WaveFilter;
	import starling.extensions.wave.WaveSource;
	
	public class Game extends Sprite
	{
		[Embed(source="assets/boat_960.jpg")]
        public static const boat:Class;
		
		public function Game() { }
		
		public function begin():void {
			
			//### Wave Filter
			var waveFilter:WaveFilter = new WaveFilter();
			var linear_source:WaveSource = new WaveSource(WaveSource.LINEAR, .01, .5, 50, 30);
			var radial_source:WaveSource = new WaveSource(WaveSource.RADIAL, .03, 2.5, 60, 5, new Point(.2,.2), 1);
			
			waveFilter.addWaveSource(linear_source);
			waveFilter.addWaveSource(radial_source);			
			Main.starling.juggler.add(waveFilter);
			
			var boatTexture:Texture = Texture.fromEmbeddedAsset(boat);
			var imgBoat:Image = new Image(boatTexture);
			imgBoat.x = 50;
			imgBoat.y = 30;
			imgBoat.filter = waveFilter;
			addChild(imgBoat);
		}
		
	}
	
}