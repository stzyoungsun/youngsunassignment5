package Window
{

	import com.lpesign.Extension;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Animaiton.AnimaitonClip;
	import Animaiton.AtlasBitmap;
	import Animaiton.Atlastexture;
	
	import Component.ButtonClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class AnimationWindow extends Sprite
	{
		private var _cSpriteLoader: LoaderClass;
		
		private var _componentDictionary: Dictionary;
		
		private var _windowRect : Rectangle;
		
		private var _startButton : ButtonClass;
		private var _stopButton : ButtonClass;
		private var _loadSpriteButton : ButtonClass;
		private var _listCallButton : ButtonClass;
		
		private var _fastButton : ButtonClass;
		private var _slowButton : ButtonClass;
		private var _vewImage : Image;
		
		
		private var _loadFile:File = new File(); 
		private var _cClip : AnimaitonClip;
		
		private var _createImagewindow : Function;
		private var _viewButtonCnt : int = 0;
		
		private var _fpsTextField : TextField; 
		private var _fpsCount : int =30;
		private var _pngNameArray : Array = new Array();
		
		private var _fileDialg:Extension; 
		
		private var _curSelTextField : TextField;
		/**
		 * 
		 * @param posx 윈도우 x 값
		 * @param posy 윈도우 y 값
		 * @param width 윈도우 가로
		 * @param height 윈도우 세로
		 * @param componentDictionary 로드된 컴포넌트 이미지 들
		 * @param createImagewindow 스프라이트 시트 후 라디오 버튼, 이미지 윈도우를 생성하기 위한 함수
		 * 
		 */		
		public function AnimationWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary, createImagewindow : Function)
		{
			_fileDialg= new Extension(drawSprite);
			_windowRect = new Rectangle(posx, posy, width, height);
			
			_curSelTextField = new TextField(_windowRect.width,_windowRect.height/20,"");
			
			_componentDictionary = componentDictionary;
			_createImagewindow = createImagewindow;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
			_fpsTextField= new TextField(_windowRect.width/5,_windowRect.height/20,"fps : 0");
			_fpsTextField.format.size = 50;
		}
		/**
		 * 
		 * @param e
		 * Note @유영선 Window창에 그리는 이벤트
		 */		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			
			_vewImage = new Image(_componentDictionary["Window.png"]);
			
			var startImage:Image = new Image(_componentDictionary["Start.png"]);
			var stopImage:Image = new Image(_componentDictionary["Stop.png"]);
			var nextImage:Image = new Image(_componentDictionary["Next.png"]);
			var prevImage:Image = new Image(_componentDictionary["prev.png"]);
			var loadImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			var ListCallButtonImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			
			var fastImage:Image = new Image(_componentDictionary["fast.png"]);
			var slowImage:Image = new Image(_componentDictionary["down.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2;
			//버튼 클래스 안에 Image 객체 해제 존재
			_startButton = new ButtonClass(new Rectangle(_windowRect.width*6/10, _windowRect.height*3/5, _windowRect.width/14, _windowRect.height/14),startImage);
			_stopButton = new ButtonClass(new Rectangle(_windowRect.width*8/10, _windowRect.height*3/5, _windowRect.width/14, _windowRect.height/14),stopImage);
			
			_loadSpriteButton = new ButtonClass(new Rectangle(_windowRect.width/10, _windowRect.height/2+35,_windowRect.width*3/10, _windowRect.height/8),loadImage,"LoadDic SpriteSheets");
			_listCallButton = new ButtonClass(new Rectangle(_windowRect.width/10, _windowRect.height/2+35,_windowRect.width*3/10, _windowRect.height/8),ListCallButtonImage,"SprteSheet 선택");
			
			_fastButton = new ButtonClass(new Rectangle(_windowRect.width*8/10, _windowRect.height/2+30, _windowRect.width/14, _windowRect.height/14),fastImage);
			_slowButton = new ButtonClass(new Rectangle(_windowRect.width*6/10,_windowRect.height/2+30, _windowRect.width/14, _windowRect.height/14),slowImage);
			
			_startButton.getButton().visible = false;
			_stopButton.getButton().visible = false;
			_fastButton.getButton().visible = false;
			_slowButton.getButton().visible = false;
			_listCallButton.getButton().visible = false;
			
			_fpsTextField.x = _windowRect.width/30;
			_fpsTextField.y = _windowRect.height/30;
			
		
			addChild(_vewImage);
			addChild(_startButton.getButton());
			addChild(_stopButton.getButton());
			addChild(_loadSpriteButton.getButton());
			addChild(_fastButton.getButton());
			addChild(_slowButton.getButton());
			addChild(_fpsTextField);
			addChild(_listCallButton.getButton());
			addChild(_curSelTextField);
			
			_loadSpriteButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_startButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_stopButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_fastButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_slowButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_listCallButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			
			_componentDictionary = null;
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
					case _loadSpriteButton.getButton():
						_loadSpriteButton.clickedONMotion();
						CreateAnimation();
						break;
					case _listCallButton.getButton():
						_listCallButton.clickedONMotion();
						_fileDialg.listDialog(_pngNameArray);
						break;	
					case _startButton.getButton():
						_startButton.clickedONMotion();
						_fpsTextField.text = "fps : " + _fpsCount as String;
						_cClip.getTimer().start();
						
						break;
					case _stopButton.getButton():
						_stopButton.clickedONMotion();
						_fpsTextField.text = "fps : 0";
						_cClip.getTimer().stop();
						break;
					case _fastButton.getButton():
						_fastButton.clickedONMotion();
						if(_fpsCount >= 60)
							_fpsCount = 60;
						else
							_fpsCount++;
						_fpsTextField.text = "fps : " + _fpsCount as String;
						_cClip.getTimer().delay = 1000/_fpsCount;
						break;
					case _slowButton.getButton():
						_slowButton.clickedONMotion();
						if(_fpsCount <= 1)
							_fpsCount = 1;
						else
							_fpsCount--;
						_fpsTextField.text = "fps : " + _fpsCount as String;
						_cClip.getTimer().delay = 1000/_fpsCount;	
						break;
					case _cClip:
						_fileDialg.spriteActivity(_cClip.getSpriteSheet().bitmapData);
						break
				}
			}
			else if(e.getTouch(stage,TouchPhase.ENDED))
			{
				switch(e.currentTarget)
				{
					case _loadSpriteButton.getButton():
						_loadSpriteButton.clickedOFFMotion();		
						break;
					case _listCallButton.getButton():
						_listCallButton.clickedOFFMotion();
						break;
					case _startButton.getButton():
						_startButton.clickedOFFMotion();
						break;
					case _stopButton.getButton():
						_stopButton.clickedOFFMotion();
						break;
					case _fastButton.getButton():
						_fastButton.clickedOFFMotion();
						break;
					case _slowButton.getButton():
						_slowButton.clickedOFFMotion();
						break;
				}
			}
		}
		/**
		 * Note @유영선 AnmaionSheet 선택
		 * 
		 */		
		private function CreateAnimation() : void
		{
			_loadFile = File.applicationDirectory;
			_loadFile.browseForOpenMultiple("Select SpriteSheet PNG Files");
			_loadFile.addEventListener(FileListEvent.SELECT_MULTIPLE, onFilesSelected);
		}
		/**
		 * 
		 * @param e
		 * CSpriteLoader로 선택 된 시트와 xml 로더 시작
		 */		
		private function onFilesSelected(e:FileListEvent):void
		{
			_loadFile.removeEventListener(flash.events.Event.SELECT, onFilesSelected);
		
			var arr : Array = new Array();
			arr = e.files;
			_cSpriteLoader = new LoaderClass(onloadList);
			_cSpriteLoader.resourceLoad(arr)
				
			arr = null;
			_loadFile = null;
		}
		
		/**
		 * List를 등록하기 위한 함수 
		 * 
		 */		
		private function onloadList(): void
		{	
	
			for(var i: int =0 ; i< _cSpriteLoader.getspriteName().length; i++)
			{
				_pngNameArray[i] = _cSpriteLoader.getspriteName()[i];
			}

			trace("Sprite Sheet 로드 완료");
			removeChild(_loadSpriteButton.getButton());
			_loadSpriteButton.getButton().removeEventListeners();
			
			_listCallButton.getButton().visible = true;
		}

		/**
		 * 
		 * @param spriteName 선택 된 Sprtie의 Subtexture의 이름
		 * 리스트 버튼 클릭 시 Srptie 이미지 출력
		 */		
		private function drawSprite(spriteName : String) : void
		{
			var curSelText : String = "";
			
			var spritexml : String = spriteName.replace("png","xml");
			var subTexture : Atlastexture = new Atlastexture(Texture.fromBitmap(_cSpriteLoader.getSpriteSheetDictionary()[spriteName]),_cSpriteLoader.getxmlDictionary()[spritexml]);
			var subBitmap : AtlasBitmap = new AtlasBitmap(_cSpriteLoader.getSpriteSheetDictionary()[spriteName],_cSpriteLoader.getxmlDictionary()[spritexml]);
			
			curSelText = "현재 선택 된 SpriteSheet : "+spriteName;
			_curSelTextField.text = curSelText;
			_curSelTextField.x = _listCallButton.getButton().x/2;
			_curSelTextField.y = _listCallButton.getButton().y+_listCallButton.getButton().height+_startButton.getButton().height/2;
			_curSelTextField.format.size = 40;
			
			_fastButton.getButton().visible = true;
			_slowButton.getButton().visible = true;
			
			trace(spriteName);
			if(_cClip)
			{
				removeChild(_cClip);
				_cClip.release();
				_startButton.getButton().visible = true;
				_stopButton.getButton().visible = true;
				_createImagewindow(subTexture,subBitmap);
			}
			else
			{
				_startButton.getButton().visible = true;
				_stopButton.getButton().visible = true;
				_createImagewindow(subTexture, subBitmap);
			}
				
			_cClip= new AnimaitonClip(subTexture.getsubVector(),30,drawAnimation,_cSpriteLoader.getSpriteSheetDictionary()[spriteName]);
			_cClip.addEventListener(TouchEvent.TOUCH,onButtonClick);
			_cClip.width =_vewImage.width/4;
			_cClip.height =_vewImage.height/4;
			_cClip.x = _vewImage.width/2 - _cClip.width/2;
			_cClip.y = _vewImage.height/2 - _cClip.height/2;
			 
			addChild(_cClip);
			
			subTexture.release();
			subTexture = null;
			
			subBitmap.release();
			subBitmap = null;
			
		}
		/**
		 * 
		 * @param _textures 쪼개진 Sheet 이미지 들
		 * @Clip에 texture를 타이머에따라 변경
		 */		
		private function drawAnimation(_textures : Texture) : void
		{
			_cClip.texture = _textures;
		}
		
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("애니매이션 윈도우 해제");
			if(_stopButton)
			{
				_stopButton.release();
				_stopButton = null;
			}
			if(_cClip)
			{
				_cClip.release();
				_cClip = null;
			}
			if(_loadSpriteButton)
			{
				_loadSpriteButton.release();
				_loadSpriteButton = null;
			}
			if(_startButton)
			{
				_startButton.release();
				_startButton = null;
			}
			if(_listCallButton)
			{
				_listCallButton.release();
				_listCallButton = null;
			}
			
			if(_curSelTextField)
			{
				_curSelTextField.dispose();
				_curSelTextField = null;
			}
			if(_vewImage)
			{
				_vewImage.dispose();
				_vewImage = null;
			}
			
			this.removeChildren();
			this.removeEventListeners();
		}
		
	public function getListCallButton() : ButtonClass
	{
			return _listCallButton;
		}
	}
		
}