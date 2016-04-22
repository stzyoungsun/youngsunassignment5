package Component
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class RadioButtonClass
	{
		/**
		 *Note @유영선 Radio 버튼 구현 (버튼 옆에 글씨까지 합쳐서 Radio 버튼)
		 */		
		private var _radioButton : Sprite;
		private var _radioButtonRect : Rectangle;
		private var _radioButtonONImage : Image;
		private var _radioButtonOFFImage : Image;
		private var _radioButtonText : String;
		private var _clickedFlag : Boolean = true;
		
		public function RadioButtonClass(radioButtonRect : Rectangle, radioButtonONImage : Image, radioButtonOFFImage: Image, radioButtonText : String)
		{
			_radioButtonRect = radioButtonRect;
			_radioButtonONImage = radioButtonONImage;
			_radioButtonOFFImage = radioButtonOFFImage;
			_radioButtonText = radioButtonText;
			
			createRadioButton();
		}
		
		public function getRadioButton() : Sprite
		{
			return _radioButton;
		}
		
		private function createRadioButton() : void 
		{
			_radioButton = new Sprite();
			
			_radioButton.x = _radioButtonRect.x;
			_radioButton.y = _radioButtonRect.y;
			
			if(_radioButtonRect.width != 0)
			{
				_radioButtonONImage.width = _radioButtonRect.width;
				_radioButtonOFFImage.width = _radioButtonRect.width;
			}
			if(_radioButtonRect.height != 0)
			{
				_radioButtonONImage.height = _radioButtonRect.height;
				_radioButtonOFFImage.height = _radioButtonRect.height;
			}
				
			
			_radioButton.addChild(_radioButtonONImage);
			
			// TextField 객체 생성
		
			
			var textField:TextField = new TextField(_radioButtonONImage.width*4, _radioButtonONImage.height, _radioButtonText);
			textField.format.size = 38;
			textField.x = _radioButtonONImage.width*2;
			textField.border = true;
			// 버튼 객체의 자식으로 등록
			_radioButton.addChild(textField);
		}
		
		public function swtichClicked(clickedFlag : Boolean) : void
		{
			_clickedFlag = clickedFlag;
			
			if(clickedFlag == false)
			{
				_radioButton.removeChild(_radioButtonONImage);
				_radioButton.addChild(_radioButtonOFFImage);
			}
			else
			{
				_radioButton.removeChild(_radioButtonOFFImage);
				_radioButton.addChild(_radioButtonONImage);
			}
		}
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("라디오 클래스 해제");
			_radioButton.removeChildren();
			_radioButton.removeEventListeners();
			_radioButtonRect = null;
			_radioButtonONImage.dispose();
			_radioButtonONImage = null;
			_radioButtonOFFImage.dispose();
			_radioButtonOFFImage =null;
			
		}
	}
}