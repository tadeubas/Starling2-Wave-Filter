# Starling2-Wave-Filter

A custom filter for Wave effect, as an extension for Starling2


Usage:

```as3
//creating and configuring the WaveFilter
var waveFilter:WaveFilter = new WaveFilter();
var linear_source:WaveSource = new WaveSource(WaveSource.LINEAR, .01, .5, 50, 30);
var radial_source:WaveSource = new WaveSource(WaveSource.RADIAL, .02, 5, 60, 5, new Point(.3,.3), 1);

waveFilter.addWaveSource(linear_source);
waveFilter.addWaveSource(radial_source);			
starling.juggler.add(waveFilter);


//creating an Image and applying the filter
var imgBoat:Image = new Image(Texture.fromEmbeddedAsset(EmbeddedAssets.boat));
imgBoat.x = 50;
imgBoat.y = 30;
imgBoat.filter = waveFilter;
addChild(imgBoat);
```

**Creator Starling 1.x**: yloquen - https://github.com/yloquen/WaveFilter AND https://github.com/yloquen/StarlingFilters

### Demo (Starling Extensions page):
https://wiki.starling-framework.org/extensions/wave-filter

### Other info:
https://forum.starling-framework.org/topic/wave-filter