package
{

	import com.lpesign.ToastExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;

	//[SWF(width="480", height="800", frameRate="60", backgroundColor="#ffffff")]
	public class Assignment5 extends Sprite
	{
		private var _mainStarling:Starling;
		private var _exitToast:ToastExtension = new ToastExtension();
		
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
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			function handleKeys (e : KeyboardEvent) : void
			{
				if(e.keyCode == Keyboard.BACK)
				{
					trace("종료");
					e.preventDefault();
					_exitToast.toast("exit");
				}
			}
		}
	}
}