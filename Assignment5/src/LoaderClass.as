package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import com.lpesign.Extension;

	
	public class LoaderClass
	{
		/**
		 * 이미지와 xml 2가지를  분리하여 Dictionary에 저장
		 * 기존에 구현 했던 Loaderclass 수정
		 * 
		 */		
		private var _currentCount : int = 0;
		public static var sImageMaxCount :int;
		private static var _selectPath:Array;
		
		private var _spriteSheetDictionary : Dictionary = new Dictionary();
		private var _xmlDictionary : Dictionary = new Dictionary;
		
		private var _spriteName : Vector.<String> = new Vector.<String>; 
		private var _xmlName : Vector.<String> = new Vector.<String>;  //XML 한 개씩 출력으르 조절 하기 위한 변수
		
		private var _urlArray:Array = new Array();					//파일명이 담긴 배열
		private var _fileDataArray:Array = new Array();			   //파일이 담김 배열
		private var _loaderXML:URLLoader;
		private var _completeFunction:Function;
		
		private var _isXml : Boolean; //xml 존재 여부
		private var _errorToast:Extension = new Extension();
		public function LoaderClass(completeFunction : Function)
		{
			_completeFunction = completeFunction;
		}
		
		public function resourceLoad(directoryPath:Array = null, isXml : Boolean = true) : void
		{
			_isXml = isXml;
			_selectPath = directoryPath;
			
			if(_selectPath == null)
				getFolderResource("resource/Component");
			else
				getFileResource(_selectPath);
			
			buildLoader();
			
			if(_isXml == true)
				buildXMLLoader();
		}
		
		/**
		 * 
		 * @return 
		 * Note @유영선불러올 폴더명 지정
		 * 폴더 안에 이미지 로드
		 */		
		private function getFolderResource(filePath : String):void
		{
			var directory:File;
			var array:Array;
			
			if(_selectPath == null)
			{
				directory = File.applicationDirectory.resolvePath(filePath);
				array = directory.getDirectoryListing();
			}
			else
			{
				directory = File.desktopDirectory.resolvePath(filePath);
				array = directory.getDirectoryListing();
			}
			
			for(var i:int = 0; i<array.length; ++i)
			{				
				
				var url:String = decodeURIComponent(array[i].url); 
				
				var extension:String = url.substr(url.lastIndexOf(".") + 1, url.length);
				
				if(extension == "png" || extension == "jpg" || extension == "PNG" || extension == "JPG")
				{
					if(_selectPath == null)
						url = url.substring(5, url.length);	
					
					_urlArray.push(decodeURIComponent(url));
				}
				//XML Loader
				else if(extension == "XML" || extension == "xml")
				{
					if(_selectPath == null)
						url = url.substring(5, url.length);	
					_xmlName.push(url);
				}
			}
		}
		/**
		 * 
		 * @param file 파일명
		 * @Note 유영선 선택 되어진 파일들 로드
		 */		
		private function getFileResource(file : Array):void
		{
			var directory:File;
			var array:Array =file;
			
			for(var i:int = 0; i<array.length; ++i)
			{				
				
				var url:String = decodeURIComponent(array[i].url); 
				
				var extension:String = url.substr(url.lastIndexOf(".") + 1, url.length);
				
				if(extension == "png" || extension == "jpg" || extension == "PNG" || extension == "JPG")
				{
					if(_selectPath == null)
						url = url.substring(5, url.length);	
					
					_urlArray.push(decodeURIComponent(url));	
					
					if(_isXml == true)
						_xmlName.push(url.replace("."+extension,".xml"));
				}
			}
		}
		/**
		 *Note @유영선 XML 로드 
		 * 
		 */		
		private function buildXMLLoader():void
		{
			if(_xmlName.length == 0 && _isXml == true)
			{
				_errorToast.toast("선택 된 파일이 Sprtie Sheet가 아니거나 Xml이 존재하지 않습니다.");
				return;
			}
			
			_loaderXML = new URLLoader(new URLRequest(_xmlName[0]));
			_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete);
		}
		/**
		 *Note @유영선 이미지 파일 로드 
		 * 
		 */		
		private function buildLoader():void
		{
			if(_xmlName.length == 0 && _isXml == true)
			{
				_errorToast.toast("선택 된 파일이 Sprtie Sheet가 아니거나 Xml이 존재하지 않습니다.");
				return;
			}
			
			sImageMaxCount =_urlArray.length; 
			sImageMaxCount+=_xmlName.length;
			
			for(var i:int = 0; i<_urlArray.length; ++i)
			{
				var loader:Loader = new Loader();
				
				loader.load(new URLRequest(_urlArray[i]));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);					
			}			
		}
		
		/**
		 * 
		 * @param e
		 * Note @유영선 한 이미지가 완료 후 다른 이미지 로딩 진행
		 */		
		private function onLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			
			var filename:String = decodeURIComponent(loaderInfo.url);
			var extension:Array = filename.split('/');
			
			_spriteName.push(extension[extension.length-1]);
			_spriteSheetDictionary[extension[extension.length-1]] = e.target.content as Bitmap;
			
			chedckedImage();
		}
		
		/**
		 * 
		 * @param e
		 * Note @유영선 XML 로딩 진행 (순서에 따라 로딩을 위해 한개씩 로딩 진행)
		 */		
		private function onLoadXMLComplete(e:Event):void
		{

			_loaderXML.removeEventListener(Event.COMPLETE, onLoadXMLComplete);
			var extension:Array = _xmlName[0].split('/');
			_xmlDictionary[extension[extension.length-1]] = XML(e.currentTarget.data);
			_xmlName.removeAt(0);
			
			chedckedImage();
			
			if(_xmlName.length != 0)
			{
				_loaderXML = new URLLoader(new URLRequest(_xmlName[0]));
				_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete)
			}	
		}
		
		/**
		 * 
		 * Note @유영선 이미지가 모두 로딩 된 후에 Mainclass에 완료 함수 호출
		 */		
		private function chedckedImage() : void
		{
			_currentCount++;
			trace(_currentCount);
			if(_currentCount == sImageMaxCount) 
			{
				
				_completeFunction();
			}
		}
		
		public function getSpriteSheetDictionary() : Dictionary
		{
			return _spriteSheetDictionary;
		}
		
		public function getxmlDictionary() :  Dictionary
		{
			return _xmlDictionary;
		}
		
		public function getspriteName() : Vector.<String>
		{
			return _spriteName;
		}
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("로더 클래스 해제");
			_loaderXML.removeEventListener(Event.COMPLETE,onLoadXMLComplete);
		}
	}
}