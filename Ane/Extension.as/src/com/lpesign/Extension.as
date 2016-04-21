package com.lpesign
{
	import flash.display.BitmapData;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class Extension
	{
		private var context:ExtensionContext;
		private var _drawSprite : Function;
		
		public function Extension(drawSprite : Function = null)
		{
			_drawSprite = drawSprite;
			try
			{
				if(!context)
					context = ExtensionContext.createExtensionContext("com.lpesign.Extension", null);
				if(context)
					context.addEventListener(StatusEvent.STATUS,statusHandle);
			} 
			catch(e:Error) 
			{
				trace(e.message);
			}
		}
		public function statusHandle(event:StatusEvent):void{
			trace(event);
			// process event data
			trace(event.code);
			trace(event.level);
			_drawSprite(event.level as String);
		}
		
		public function toast(message:String):void{
			context.call("toast",message);
		}
		
		public function exitDialog(clickedFlag:Boolean):void{
			context.call("exitdialog",clickedFlag);
		}
				
		public function listDialog(arrPngName:Array) : void{
			context.call("listdialog",arrPngName);
		}
		
		public function spriteActivity(spriteSheet:BitmapData) : void{
			context.call("spritesheet",spriteSheet);
		}
	}
}