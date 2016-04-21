package com.lpesign.extensions;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.os.Bundle;
import android.util.Log;
import android.view.View;


public class SpriteActivity extends Activity{
	private static String TAG = "AirImagePicker";
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);		
		Log.d(TAG, "[AirImagePickerActivity] Entering onActivityResult");
		byte[] arr = getIntent().getByteArrayExtra("image");
		Bitmap bm = BitmapFactory.decodeByteArray(arr, 0, arr.length);
		
		Log.d(TAG, "[AirImagePickerActivity] 액티비티 안에서 bitmap" + bm.getWidth());
		
		setContentView(new DrawView(this,bm));
		 //Toast.makeText(Extension.sContext.getActivity(), "000000", Toast.LENGTH_LONG).show();
	}
	
	 private class DrawView extends View {
	        private Bitmap _spriteBitmap;
	        
	        public DrawView(android.content.Context context, Bitmap bm) {
	            super(context);
	            _spriteBitmap = bm;
	        }
	 
	        protected void onDraw(Canvas canvas) {

	            canvas.drawBitmap(_spriteBitmap, 0, 0, null);
	            Log.d(TAG, "[AirImagePickerActivity] 캔버스 안에서 bitmap" + _spriteBitmap.getWidth());
	        
	        }
	    }
	 
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		Log.d(TAG, "[AirImagePickerActivity] Entering onActivityResult");
		
		super.onActivityResult(requestCode, resultCode, data);
	
		
		Log.d(TAG, "[AirImagePickerActivity] Exiting onActivityResult");
	}
	
	@Override
	protected void onDestroy()
	{
		Log.d(TAG, "[AirImagePickerActivity] Entering onDestroy");
		
		super.onDestroy();
		
		Log.d(TAG, "[AirImagePickerActivity] Exiting onDestroy");
	}

}
