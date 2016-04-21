package com.lpesign.extensions.Function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.Activity;
import android.widget.Toast;

public class ToastFunction implements FREFunction{
	private Activity _flashActivity;
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	
	        CharSequence message = "";
	        
	        try {
	            message = arg1[0].getAsString();
	            _flashActivity = arg0.getActivity();	
	        } catch (IllegalStateException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FRETypeMismatchException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FREInvalidObjectException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FREWrongThreadException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        }
	        Toast.makeText(_flashActivity, message, Toast.LENGTH_LONG).show();
	        
	        
	        return null;
	    }
}
