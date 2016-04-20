package com.lpesign
{
	import flash.external.ExtensionContext;

	public class Extension
	{
		private var context:ExtensionContext;
		public function Extension()
		{
			try
			{
				context = ExtensionContext.createExtensionContext("com.lpesign.Extension",null);
			} 
			catch(e:Error) 
			{
				trace(e.message);
			}
		}
		public function toast(message:String):void{
			context.call("toast",message);
		}
		
		public function exitDialog(clickedFlag:Boolean):void{
			context.call("exitdialog",clickedFlag);
		}
		
	}
}