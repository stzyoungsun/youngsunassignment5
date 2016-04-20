package com.lpesign.extensions;

import java.io.File;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.Activity;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;


public class FileDialogFunction implements FREFunction{
	private Activity _flashActivity;
	private FileDialog _fileDialog;
	private Boolean _clickedFlag = false;
	
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub

	        try {
	        	_clickedFlag = arg1[0].getAsBool();
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
	        Toast.makeText(_flashActivity, "file1", Toast.LENGTH_LONG).show();
	        File mPath = new File(Environment.getExternalStorageDirectory() + "//DIR//");
	        _fileDialog = new FileDialog(_flashActivity, mPath);
            
	        _fileDialog.setFileEndsWith(".txt");
	        _fileDialog.addFileListener(new FileDialog.FileSelectedListener() {
                public void fileSelected(File file) {
                    Log.d(getClass().getName(), "selected file " + file.toString());
                }
            });
	        Toast.makeText(_flashActivity, "file2", Toast.LENGTH_LONG).show();
	        _fileDialog.showDialog();
	        return null;
	    }
}
