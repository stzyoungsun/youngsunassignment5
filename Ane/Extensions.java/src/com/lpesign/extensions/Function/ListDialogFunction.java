package com.lpesign.extensions;

import java.io.File;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.adobe.fre.FREArray;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.Toast;

public class ListDialogFunction implements FREFunction{
	private FREContext _flashContext;
	private String[]  _convertArg;
	
	@Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {
        // TODO Auto-generated method stub
		 _flashContext = arg0;
		 
        try {

        	_convertArg = new String[(int)((FREArray)arg1[0]).getLength()];
        	
        	for(int i =0; i < ((FREArray)arg1[0]).getLength(); i ++)
        	{	
        		
        		_convertArg[i] = ((FREArray)arg1[0]).getObjectAt(i).getAsString();
        	}
        		
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
  
        
        AlertDialog.Builder builder = new AlertDialog.Builder(_flashContext.getActivity());
    	
        builder.setTitle("ȭ�鿡 ��� �� ������ Ŭ�����ּ���.");
        
        builder.setItems(_convertArg,
                new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int whichButton) {
                    // �� ����Ʈ�� ���������� 
                		
                	Toast.makeText(_flashContext.getActivity(), "num : " + whichButton , Toast.LENGTH_LONG).show();	
                	_flashContext.dispatchStatusEventAsync("eventCode",_convertArg[whichButton]);
                }
                });
        builder.show();
        
        

             
        return null;
        
	}
	
}
