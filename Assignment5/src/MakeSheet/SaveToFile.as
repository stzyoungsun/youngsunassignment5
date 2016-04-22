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
		
		private var _spriteSheetBitmaps : Vector.<Bitmap>;
		private var _spriteSheetRects :  Vector.<Vector.<Rectangle>>;
		private var _spriteSheetNames : Vector.<Array>;
		
		
		public function SaveToFile(bitmaps:Vector.<Bitmap>, spriteSheetRects : Vector.<Vector.<Rectangle>>, spriteSheetNames : Vector.<Array>)
		{
			var filePath:File = File.documentsDirectory.resolvePath("images/");
			_spriteSheetBitmaps = bitmaps;
			_spriteSheetRects = spriteSheetRects;
			_spriteSheetNames = spriteSheetNames;
			
			var tempPath : String =  filePath.nativePath;
			
			for(var i : int =0; i < _spriteSheetBitmaps.length; i++)
			{
				var _bitmapByteArray:ByteArray = new ByteArray();
				_spriteSheetBitmaps[i].bitmapData.encode(new Rectangle(0,0,_spriteSheetBitmaps[i].width,_spriteSheetBitmaps[i].height), new PNGEncoderOptions(), _bitmapByteArray);
				filePath.nativePath += "/NewSprite_Sheet"+i+".png";
				_fileStream.open(filePath, FileMode.WRITE);
				_fileStream.writeBytes(_bitmapByteArray);
				filePath.nativePath = tempPath;
				_fileStream.close();
			}
			
			for(var j : int = 0; j< _spriteSheetNames.length; j++)
			{
				filePath.nativePath += "/NewSprite_Sheet"+j+".xml";
				_fileStream.open(filePath, FileMode.WRITE);
				_fileStream.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
				_fileStream.writeUTFBytes("<TextureAtlas ImagePath=\"" + "NewSprite_sheet"+j+".png" + "\">\n");
				for(var k : int = 0; k< _spriteSheetNames[j].length; k++)
				{
					_fileStream.writeMultiByte("<SubTexture name=\"" + _spriteSheetNames[j][k] + "\" x=\"" + _spriteSheetRects[j][k].x 
						+ "\" y=\"" + _spriteSheetRects[j][k].y + "\" width=\"" + _spriteSheetRects[j][k].width + "\" height=\"" + _spriteSheetRects[j][k].height + " \"/>\n","EUC-KR");
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