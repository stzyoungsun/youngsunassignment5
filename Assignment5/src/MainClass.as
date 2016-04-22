package
{
	import com.lpesign.Extension;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import Animaiton.AtlasBitmap;
	import Animaiton.Atlastexture;
	
	import Component.RadioButtonClass;
	
	import Window.AnimationWindow;
	import Window.ImageWindow;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 
	 * @author user
	 * Note @유영선 중심이 되는 Class
	 */	
	public class MainClass extends Sprite
	{
		private var _cLoader : LoaderClass;
		private var _cAnimationWindow : AnimationWindow = null;
		private var _cImageWindow : ImageWindow = null;
		private var _componentAtlas : Atlastexture; 
		
		private var _radioButtons : Vector.<RadioButtonClass>;    //라디오 버튼은  Animation/Image Window를 조절 하는 버튼 이므로 Main에 삽입
		
		private var _exitToast:Extension = new Extension();
		public function MainClass()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize() : void
		{
			
			_cLoader = new LoaderClass(oncompleteLoadImage);	//컴포넌트 이미지 로드
			_cLoader.resourceLoad();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);	//back key 이벤트
			function handleKeys (e : KeyboardEvent) : void
			{
				if(e.keyCode == Keyboard.BACK)
				{
					trace("종료");
					e.preventDefault();
					
					if(_cAnimationWindow.getListCallButton().getButton().visible == true)	//back 눌렀을때 초기화면으로 돌아옴
						backButton();
					else
						_exitToast.exitDialog(true);	//back key 눌렀을때 종료 다이얼로그 출력
				}
			}
		}
		/**
		 *Note @유영선 이미지 로딩 완료 후 AnimationWindow 창 로드  
		 * 
		 */		
		private function oncompleteLoadImage() : void
		{
			//컴포넌트 이미지 AtlasTexture로 생성
			_componentAtlas = new Atlastexture(Texture.fromBitmap(_cLoader.getSpriteSheetDictionary()["Component_Sheet0.png"]),_cLoader.getxmlDictionary()["Component_Sheet0.xml"]);
			initWindow();
		}
		/**
		 * Note @유영선 AnimationWindow 생성
		 * 
		 */		
		private function initWindow() : void 
		{
			_cAnimationWindow = new AnimationWindow(0,30,stage.stageWidth,stage.stageHeight,_componentAtlas.getsubSpriteSheet(),drawRadioButton);
				
			addChild(_cAnimationWindow);
		}
		/**
		 * Note @유영선 두개의 라디오 버튼을 생성  
		 * 
		 */		
		private function drawRadioButton(curTexture : Atlastexture, curBitmap : AtlasBitmap) : void
		{
			if(_cImageWindow)
				_cImageWindow.release();
			else
			{
				_radioButtons = new Vector.<RadioButtonClass>;
				var RadioOFFImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
				var RadioONImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
				
				var RadioOFFImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
				var RadioONImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
				
				_radioButtons[0] = new RadioButtonClass(new Rectangle(30, stage.stageHeight*10/13, stage.stageWidth/14, stage.stageHeight/14), RadioONImageA,RadioOFFImageA,"Animation Mode");
				_radioButtons[1] = new RadioButtonClass(new Rectangle(stage.stageWidth/2+30, stage.stageHeight*10/13,stage.stageWidth/14, stage.stageHeight/14), RadioONImageI,RadioOFFImageI,"Image Mode");	
				_radioButtons[1].swtichClicked(false);
				
				_radioButtons[0].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
				_radioButtons[1].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
				
				addChild(_radioButtons[0].getRadioButton());
				addChild(_radioButtons[1].getRadioButton());
			}
			_cImageWindow = new ImageWindow(0,30,stage.stageWidth,stage.stageHeight,_componentAtlas.getsubSpriteSheet(),curTexture,curBitmap);
			_cImageWindow.visible = false;
			addChild(_cImageWindow);
		}
		/**
		 * 
		 * @param e
		 * Note @유영선 Radio 버튼을 클릭 하였을 때 모드 변경  
		 */		
		private function onRadioClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				if(e.currentTarget == _radioButtons[0].getRadioButton())
				{
					trace("0번 라디오 찍힘");
					_radioButtons[0].swtichClicked(true);
					_radioButtons[1].swtichClicked(false);
					_cAnimationWindow.visible = true;
					_cImageWindow.visible = false;
				}
				else if(e.currentTarget == _radioButtons[1].getRadioButton())
				{
					trace("1번 라디오 찍힘");
					_radioButtons[0].swtichClicked(false);
					_radioButtons[1].swtichClicked(true);
					_cAnimationWindow.visible = false;
					_cImageWindow.visible = true;
				}
				else
					return;
			}
		}
		/**
		 * 
		 * Note @유영선 BackKey를 클릭 하였을 경우 초기화면으로 돌아감
		 */		
		public function backButton() : void
		{
			if(_radioButtons)
			{
				for(var i: int =0; i < _radioButtons.length; i++)
				{
					removeChild(_radioButtons[i].getRadioButton());
					_radioButtons[i].release();
					_radioButtons[i] = null;
					
				}
				_radioButtons = null;
			}
			if(_cAnimationWindow)
			{
				_cAnimationWindow.release();
				_cAnimationWindow = null;
			}
			
			if(_cImageWindow)
			{
				_cImageWindow.release();
				_cImageWindow = null;
			}
			
			initWindow();
		}

		public function release() : void 
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("메인 클래스 해제");
	
			_cAnimationWindow.release();
			_cImageWindow.release();
			_cLoader.release();
			_componentAtlas.release();
			
			_exitToast = null;
			_cLoader = null;
			_cAnimationWindow = null;
				
			this.removeChildren();
			this.removeEventListeners();
			this.dispose();
		}
		
	}
}