package starling.extensions.wave 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import starling.animation.IAnimatable;
	 
	import starling.rendering.FilterEffect;
	import starling.rendering.Program;
	
	public class WaveEffect extends FilterEffect implements IAnimatable
	{
		private var waveSources:Vector.<WaveSource>;
		private var constants:Vector.<Number>;
		private var constant_counter:int;
		
		public function WaveEffect() 
		{
			waveSources = new Vector.<WaveSource>();
			constants = new Vector.<Number>();		
		}
		
		override protected function createProgram():Program
		{
			constant_counter = 0;
			
			var vertexShader:String = STD_VERTEX_SHADER;
			
			var generatedProgram:String = new String();
			
			for (var i:int = 0; i < waveSources.length; i++)
			{
				generatedProgram += generateCode(i);				
			}
			
			var fragmentShader:String = [
			"mov ft0, v0	\n", //begin
			generatedProgram,
			"tex ft0, ft0, fs0 <2d, clamp, linear, mipnone>		\n", //end
			"mov oc, ft0	\n"
			].join("");
			
			return Program.fromSource(vertexShader, fragmentShader);
		}
		
		private function generateCode(index:int):String
		{			
			var src:WaveSource = this.waveSources[index];			
			var code:String = new String();
			
			if (src.type == WaveSource.LINEAR)
			{
				code +=
				"mul ft1.xy, v0.xy, fc" + constant_counter + ".yz		\n" +		// a*x , b*y
				"add ft1.x, ft1.x, ft1.y					\n" +					// a*x + b*y
				"add ft1.x, ft1.x, fc" + constant_counter + ".w		\n"	+			// a*x + b*y + t
				"sin ft1.x, ft1.x							\n" +					// sin (a*x + b*y + t)
				"mul ft1.x, fc" + constant_counter + ".x, ft1.x		\n" +			// A.sin (a*x + b*y + t)			
				"add ft0.xy, ft0.xy, ft1.xx					\n";					// x+=wave , y+=wave	
				
				this.constant_counter ++;
			}
			else if (src.type == WaveSource.RADIAL)
			{			
				code +=								
				"sub ft1.xy, v0.xy, fc" + (constant_counter+1) + ".xy	\n" +		//vector from origin - dv
				"mul ft1.x, ft1.x, fc" + (constant_counter+1) + ".z		\n" +		//modify dv for aspect			
				
				"mul ft2.xy, ft1.xy, ft1.xy	\n" +									//x^2, y^2
				
				"add ft1.z, ft2.x, ft2.y	\n" +									//x^2 + y^2
				"sqt ft1.z, ft1.z			\n" +									//sqrt(x^2 + y^2)								
				
				"div ft1.xy, ft1.xy, ft1.zz	\n" +									//normalize
				
				"mul ft1.z, ft1.z, fc" + constant_counter + ".y	\n";				//a.sqrt(x^2 + y^2)
				
				if (src.propagation > 0)
				{
					code+=
					"mov ft3.z, fc" + (constant_counter+1) +".w	\n" +				
					"sub ft3.y, ft3.z, ft1.z						\n";			//propagation*time-distance
				}
				
				code +=							
				"add ft1.z, ft1.z, fc" + constant_counter + ".w	\n" +				//a.sqrt(x^2 + y^2) + t			
				"sin ft1.z, ft1.z			\n" +  									//sin							
				
				"mul ft1.w, ft1.z, ft1.y	\n" +									//sin*dv.y
				"mul ft1.z, ft1.z, ft1.x	\n" +									//sin*dv.x		
							
				"mul ft1.w, ft1.w, fc" + constant_counter + ".x	\n" +				//A*sin*dv.y
				"mul ft1.z, ft1.z, fc" + constant_counter + ".x	\n";				//A*sin*dv.x																
				
				if (src.propagation > 0)
				{
					code +=
					"sat ft3.x, ft3.y								\n" +			
					"mul ft1.w, ft1.w, ft3.x						\n" +
					"mul ft1.z, ft1.z, ft3.x						\n";
				}
				
				code+=
				"add ft0.xy, ft0.xy, ft1.zw	\n";									// x+=wave , y+=wave	
				
				this.constant_counter += 2;
			}
			
			return code;
		}
		
		private function recalculateShaderProgram():void {
			createProgram();
		}
		
		override protected function beforeDraw(context:Context3D):void
		{
			generateConstants();
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, constants, int(constants.length / 4));
			super.beforeDraw(context);
		}
		
		private function generateConstants():void
		{
			var len:int = waveSources.length;			
			var src:WaveSource;
			
			this.constants = new Vector.<Number>();
			
			for (var i:int; i < len; i++)
			{
				src = waveSources[i];
				if (src.type == WaveSource.LINEAR)
					this.constants.push(src.amplitude, src.xComponent, src.yComponent, src.time);
				else if (src.type == WaveSource.RADIAL)
					this.constants.push(src.amplitude, src.xComponent, src.yComponent, src.time, src.origin.x, src.origin.y, src.aspect, src.propagation*src.time);
			}
		}
		
		public function advanceTime(time:Number):void
		{
			var len:int = this.waveSources.length;
			for (var i:int = 0; i < len; i++)
			{
				var src:WaveSource = waveSources[i];
				src.time += time * src.frequency;
			}
		}
		
		public function addWaveSource(src:WaveSource):void
		{
			if (this.waveSources.length < 8)
			{
				waveSources.push(src);
				recalculateShaderProgram();			
			}
		}
		
		public function removeWaveSource(src:WaveSource):void
		{
			var index:int = waveSources.indexOf(src);
			if (index > -1)
			{
				waveSources.splice(index, 1);
				recalculateShaderProgram();			
			}
		}
		
	}

}