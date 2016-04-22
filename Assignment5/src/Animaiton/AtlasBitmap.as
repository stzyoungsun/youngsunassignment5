package Animaiton
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class AtlasBitmap
	{
		private var _sprtieSheet:Bitmap;
		private var _subSpriteSheetDictionary: Dictionary;	//SubTexture Dictionary
		private var _subSheetVector:Vector.<Bitmap> = new Vector.<Bitmap>;	//SubTexture Vector
		
		private var _subTextureNames:Vector.<String> = new Vector.<String>;	//SubTexture들의 이름을 담고있는 Vector
		
		public function AtlasBitmap(sprtieSheet:Bitmap, spriteXml:XML = null)
		{
			_subSpriteSheetDictionary = new  Dictionary();
			_sprtieSheet = sprtieSheet;
			
			if (spriteXml)
			{
				parseAtlasXml(spriteXml);
			}
		}
		
		/**
		 * 
		 * @param spriteXml
		 * Note @유영선 xml에 SubBitmap에 접근하여 원하는 정보를 얻어 옵니다 
		 */		
		protected function parseAtlasXml(spriteXml:XML):void
		{
			var region:Rectangle = new Rectangle();
			
			for(var i : int =0; i < spriteXml.child("SubTexture").length(); i++)
			{
				var name:String = spriteXml.child("SubTexture")[i].attribute("name");
				var x:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("x"));
				var y:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("y"));
				var width:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("width"));
				var height:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("height"));
				
				region.setTo(x,y,width,height);
				createSubTexure(name, region);
			}
		}
		/**
		 * 
		 * @param name : subTexture 이름
		 * @param region : 
		 * 
		 */		
		public function createSubTexure(name : String, region:Rectangle):void
		{
			var tempBitmapData : BitmapData = new BitmapData(region.width,region.height);
	
			tempBitmapData.copyPixels(_sprtieSheet.bitmapData,region,new Point(0,0));
			
			_subSpriteSheetDictionary[name] = new Bitmap(tempBitmapData);
			_subTextureNames.push(name);
			//_subSheetVector.push(Texture.fromTexture(_sprtieSheet,region));
			
		}
		/**
		 * 
		 * @param subBitmap : 추가 할 이미지
		 * @param name : 추가 할 파일의 이름
		 * 
		 */		
		public function addSubBitmap(subBitmap : Bitmap, name : String) : void
		{
			_subSpriteSheetDictionary[name] =  subBitmap;
			_subTextureNames.push(name);
		}
		
		public function getsubSpriteSheet() :Dictionary   //subtecture를  Dictionary로 리턴
		{
			return _subSpriteSheetDictionary;
		}
		
		public function getsubBitmapName() : Vector.<String > //subtecture에 이름만 리턴
		{
			return _subTextureNames;
		}
	}
}