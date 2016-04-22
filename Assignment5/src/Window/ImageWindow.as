package Window
{
	import com.lpesign.Extension;
	
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Animaiton.AtlasBitmap;
	import Animaiton.Atlastexture;
	
	import Component.ButtonClass;
	
	import MakeSheet.MakeSpriteSheet;
	import MakeSheet.SaveToFile;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ImageWindow extends Sprite
	{
		private var _cAddImageLoader: LoaderClass;
		
		
		private var _componentDictionary: Dictionary;	//컴포넌트 이미지
		private var _curTexture : Atlastexture; 	//사용자가 로드한 SprtieSheet 안에 의미지
		private var _curBitmap : AtlasBitmap;
		private var _windowRect : Rectangle;
		private var _vewImage : Image;
		
		private var _addButton : ButtonClass;
		private var _listCallButton : ButtonClass;
		private var _makeSheet : ButtonClass;		//추가된 이미지를 이용하여 Sprtie Sheet를 재 생성
		
		private var _curImage : Image;
		private var _viewButtonCnt : int = 0;
		
		private var _fileDialg:Extension; 
		private var _stateToast:Extension = new Extension();
		
		private var _pngNameArray : Array = new Array();
		
		private var _curSelTextField : TextField;
		
		private var _cSaveToFile : SaveToFile;
		
		/**
		 * 
		 * @param posx 윈도우 위치
		 * @param posy 윈도우 위치
		 * @param width 윈도우 크기
		 * @param height 윈도우 크기
		 * @param componentDictionary 컴포넌트 이미지
		 * @param curTexture Animation윈도우에서 클릭 한 이미지의 Texture
		 * @param curBitmap Animation윈도우에서 클릭 한 이미지의 Bitmap
		 * 
		 */		
		public function ImageWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary
									,curTexture : Atlastexture ,curBitmap : AtlasBitmap)
		{
			_fileDialg= new Extension(drawSprite);
			_windowRect = new Rectangle(posx, posy, width, height);
			
			_curSelTextField = new TextField(_windowRect.width,_windowRect.height/20,"");
			
			_componentDictionary = componentDictionary;
			_curTexture = curTexture;
			_curBitmap = curBitmap;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
			curTextureToArray();
		}
		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			_vewImage = new Image(_componentDictionary["Window.png"]);
		
			var nextImage:Image = new Image(_componentDictionary["Next.png"]);
			var prevImage:Image = new Image(_componentDictionary["prev.png"]);
			var addImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			var listCallButtonImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			var makeButtonImage : Image  = new Image(_componentDictionary["LoadSprite.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2;
			
			_addButton = new ButtonClass(new Rectangle(_windowRect.width/2, _windowRect.height/2+30, _windowRect.width/4,  _windowRect.height/10),addImage, "이미지 추가");
			_makeSheet = new ButtonClass(new Rectangle(_windowRect.width*3/4, _windowRect.height/2+30, _windowRect.width/4, _windowRect.height/10),makeButtonImage, "Remake Sprite Sheet");
			_makeSheet.getButton().visible = false;
			_listCallButton = new ButtonClass(new Rectangle(_windowRect.width/10, _windowRect.height/2+35,_windowRect.width*3/10, _windowRect.height/8),listCallButtonImage,"이미지 선택");
			
			
			addChild(_vewImage);
			addChild(_addButton.getButton());
			addChild(_makeSheet.getButton());
			addChild(_listCallButton.getButton());
			addChild(_curSelTextField);
			_addButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_listCallButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
		}
		
		/**
		 * 
		 * @param e
		 *Note @유영선 Window창에 있는 버튼을 클릭 했을때 이벤트 
		 */		
		private function onButtonClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				switch(e.currentTarget)
				{
					case _listCallButton.getButton():
						_listCallButton.clickedONMotion();
						_fileDialg.listDialog(_pngNameArray);
						
						break;
			
					case _addButton.getButton():
						_addButton.clickedONMotion();
						addImage();
						break;
					
					case _makeSheet.getButton():
						_makeSheet.clickedONMotion();
						_stateToast.toast("이미지 병합 중 입니다.");
						var cMakeSpriteSheet : MakeSpriteSheet = new MakeSpriteSheet(_curBitmap);
						
						_cSaveToFile = new SaveToFile(cMakeSpriteSheet.getSheets(),cMakeSpriteSheet.getSheetRects(), cMakeSpriteSheet.getSheetNames());
						_stateToast.toast("이미지 병합 완료 Image 폴더를 확인하세요.");
						break;
				}
			}
			
			else if(e.getTouch(stage,TouchPhase.ENDED))
			{
				switch(e.currentTarget)
				{
					case _listCallButton.getButton():
						_listCallButton.clickedOFFMotion();
						break;
					
					case _addButton.getButton():  //이전 리스트를 보여주기 위한 부분
						_addButton.clickedOFFMotion();
						break;
					
					case _makeSheet.getButton():
						_makeSheet.clickedOFFMotion();
						break;
				}
			}
		}
		/**
		 * Note #유영선 이미지 추가 기능 함수 
		 * 추가 할 이미지들이 있는 폴더 선택
		 */		
		private function addImage() : void
		{
			var file : File = File.applicationDirectory;
			file.browseForOpenMultiple("추가 할 이미지들이 있들을 선택해 주세요");
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, onFilesSelected);
			
			function onFilesSelected(e:FileListEvent):void
			{
				var arr : Array = new Array();
				arr = e.files;
				
				_makeSheet.getButton().visible = true;
				_makeSheet.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
				
				_cAddImageLoader = new LoaderClass(onaddImageToList);	
				_cAddImageLoader.resourceLoad(arr,false);
			}
		}
		
		/**
		 * 
		 * Note @유영선 메모리에 새로운 이미지 추가
		 */		
		private function onaddImageToList(): void
		{	
			for(var i :int = 0; i < _cAddImageLoader.getspriteName().length; i++)
			{
				var newTexture : Texture = Texture.fromBitmap(_cAddImageLoader.getSpriteSheetDictionary()[_cAddImageLoader.getspriteName()[i]]);
				_curTexture.addSubTexure(newTexture,_cAddImageLoader.getspriteName()[i]);
				_curBitmap.addSubBitmap(_cAddImageLoader.getSpriteSheetDictionary()[_cAddImageLoader.getspriteName()[i]],_cAddImageLoader.getspriteName()[i]);
			}
			curTextureToArray();	
		}
		
		private function curTextureToArray() : void
		{
			for(var i: int =0 ; i< _curTexture.getsubTextureName().length; i++)
			{
				_pngNameArray[i] = _curTexture.getsubTextureName()[i];
			}
		}
		
		/**
		 * 
		 * @param spriteName 선택 된 리스튼 버튼에 들어 있는 이미지 이름
		 * Note @유영선 사용자가 선택 한 List버튼에 연관된 이미지를 창에 띠어줍니다
		 */		
		private function drawSprite(spriteName : String) : void
		{
			trace (spriteName);
			 var curSelText : String = "";
			 
			if(_curImage)
			{
				removeChild(_curImage);
			}
			curSelText = "현재 선택 된 이미지 : "+spriteName;
			_curSelTextField.text = curSelText;
			_curSelTextField.x = _listCallButton.getButton().x/2;
			_curSelTextField.y = _listCallButton.getButton().y+_listCallButton.getButton().height;+30;
			_curSelTextField.format.size = 40;
			
			_curImage = new Image(_curTexture.getsubSpriteSheet()[spriteName]);
			_curImage.width =_vewImage.width/4;
			_curImage.height =_vewImage.height/4;
			_curImage.x = _vewImage.width/2 - _curImage.width/2;
			_curImage.y = _vewImage.height/2 - _curImage.height/2;

			addChild(_curImage);
		}
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("이미지 윈도우 해제");

			this.removeChildren();
			this.removeEventListeners();
		}
	}
}