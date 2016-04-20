package com.lpesign.extensions;

import java.util.HashMap;
import java.util.Map;
 
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class ToastContext extends FREContext {

	@Override
    public void dispose() {
        // TODO Auto-generated method stub
 
    }
 
    @Override
    public Map<String, FREFunction> getFunctions() {
        // TODO Auto-generated method stub
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("toast", new ToastFunction());
        return map;
    }

}
