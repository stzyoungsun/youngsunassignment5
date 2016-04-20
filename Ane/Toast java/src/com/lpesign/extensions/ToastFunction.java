package com.lpesign.extensions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.widget.Toast;

public class ToastFunction implements FREFunction {

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
	        
	        if(message.equals("exit"))
	        {
	        	Toast.makeText(_flashActivity, "exit in", Toast.LENGTH_LONG).show();
	        	  AlertDialog.Builder ab = new AlertDialog.Builder(arg0.getActivity());
	        	  ab.setTitle("Á¾·á Ã¢");
	        	  ab.setPositiveButton("Ok", new OnClickListener() {
	        		  
	  				@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						_flashActivity.onBackPressed();
					}
				}).setNegativeButton("Cancel", new OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						return;
					}
				});
	        	 
	        	  ab.show();
	        }
	        return null;
	    }
	 
	 	
}
