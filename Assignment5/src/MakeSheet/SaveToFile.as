package MakeSheet
{
	import flash.display.Bitmap;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class SaveToFile
	{
		
		
		private var _fileStream:FileStream = new FileStream(); 
		
		private var _spriteSheetBitmap : Vector.<Bitmap>;
		private var _spriteSheetRect :  Vector.<Vector.<Rectangle>>;
		private var _spriteSheetName : Vector.<Array>;
		
		
		public function SaveToFile(bitmap:Vector.<Bitmap>, spriteSheetRect : Vector.<Vector.<Rectangle>>, spriteSheetName : Vector.<Array>)
		{
			var filePath:File = File.documentsDirectory.resolvePath("images/");
			_spriteSheetBitmap = bitmap;
			_spriteSheetRect = spriteSheetRect;
			_spriteSheetName = spriteSheetName;
			
			var tempPath : String =  filePath.nativePath;
			
			for(var i : int =0; i < _spriteSheetBitmap.length; i++)
			{
				var _bitmapByteArray:ByteArray = new ByteArray();
				_spriteSheetBitmap[i].bitmapData.encode(new Rectangle(0,0,_spriteSheetBitmap[i].width,_spriteSheetBitmap[i].height), new PNGEncoderOptions(), _bitmapByteArray);
				filePath.nativePath += "/NewSprite_Sheet"+i+".png";
				_fileStream.open(filePath, FileMode.WRITE);
				_fileStream.writeBytes(_bitmapByteArray);
				filePath.nativePath = tempPath;
				_fileStream.close();
			}
			
			for(var j : int = 0; j< _spriteSheetName.length; j++)
			{
				filePath.nativePath += "/NewSprite_Sheet"+j+".xml";
				_fileStream.open(filePath, FileMode.WRITE);
				_fileStream.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
				_fileStream.writeUTFBytes("<TextureAtlas ImagePath=\"" + "NewSprite_sheet"+j+".png" + "\">\n");
				for(var k : int = 0; k< _spriteSheetName[j].length; k++)
				{
					_fileStream.writeMultiByte("<SubTexture name=\"" + _spriteSheetName[j][k] + "\" x=\"" + _spriteSheetRect[j][k].x 
						+ "\" y=\"" + _spriteSheetRect[j][k].y + "\" width=\"" + _spriteSheetRect[j][k].width + "\" height=\"" + _spriteSheetRect[j][k].height + " \"/>\n","EUC-KR");
				}
				_fileStream.writeUTFBytes("</TextureAtlas>");
				_fileStream.close();
				filePath.nativePath = tempPath;
			}
		}
		/**
		 * 
		 * @param bitmap 병합 된  bitmap
		 * Note @유영선 병합 된 bitmap을 PNGEncoder 라이브러리를 이용하여 png 변환 후 파일로 출력
		 * 
		 * 
		 * spriteSheetRect [sheet 개수][sheet 안에 이미지 개수의 위치 값] 의 이차원 벡터
		 * spriteSheetName [sheet 개수][sheet 안에 이미지 이름] 의 이차원 벡터
		 * 
		 */		

		private function onSelectHandler(e:Event):void
		{
		
			
		}
	}
}