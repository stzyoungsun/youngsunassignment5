package
{


	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	
	import starling.core.Starling;

	//[SWF(width="480", height="800", frameRate="60", backgroundColor="#ffffff")]
	public class Assignment5 extends Sprite
	{
		private var _mainStarling:Starling;
		

		public function Assignment5()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			trace(stage.stageWidth);
			trace(stage.stageHeight);
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
			
			
		}
	}
}