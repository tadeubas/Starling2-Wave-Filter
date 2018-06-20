package starling.extensions.wave 
{
	import starling.animation.IAnimatable;
	import starling.filters.FragmentFilter;
	import starling.rendering.FilterEffect;
	
	public class WaveFilter extends FragmentFilter implements IAnimatable
	{
		
		public function WaveFilter():void {	}
		
		override protected function createEffect():FilterEffect
        {
            return new WaveEffect();
        }
		
		private function get waveEffect():WaveEffect
        {
            return effect as WaveEffect;
        }
		
		//TODO: Setters and Getters ?
		public function addWaveSource(src:WaveSource):void
		{
			waveEffect.addWaveSource(src);
			setRequiresRedraw();
		}
		
		public function removeWaveSource(src:WaveSource):void
		{
			waveEffect.removeWaveSource(src);
			setRequiresRedraw();
		}
		
		public function advanceTime(time:Number):void
		{
			waveEffect.advanceTime(time);
			setRequiresRedraw();
		}
	}

}