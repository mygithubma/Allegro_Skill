axlCmdRegister("clinecut" 'cline_cut)


defun(getSegmentIntersection (p1 p2 p3 p4)
  let((x1 y1 x2 y2 x3 y3 x4 y4 denominator ua ub x y result (eps 1e-9))
    
    x1 = car(p1)
    y1 = cadr(p1)
    x2 = car(p2)
    y2 = cadr(p2)
    x3 = car(p3)
    y3 = cadr(p3)
    x4 = car(p4)
    y4 = cadr(p4)
    
    denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    
    result = nil  ; 默认返回 nil
    
    if(denominator != 0 then
      ua = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / float(denominator)
      ub = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / float(denominator)
      
      if(ua >= (-eps) && ua <= (1.0+eps) && ub >= (-eps) && ub <= (1.0+eps) then
        x = x1 + ua * (x2 - x1)
        y = y1 + ua * (y2 - y1)
        result = list(x y)
      )
    )
    
    result  ; 返回交点坐标或 nil 值
  )
)



defun(cline_cut ()
  
  	
      	if(axlLayerGet("MANUFACTURING/CUTLINE") then        ; 检查是否已存在 MANUFACTURING/CUTLINE 图层
        axlUIWPrint(nil "MANUFACTURING/CUTLINE 已存在")
   	 else
        axlLayerCreateNonConductor("MANUFACTURING/CUTLINE")                        ; 创建 MANUFACTURING/CUTLINE 图层
        axlUIWPrint(nil "MANUFACTURING/CUTLINE 已创建")
      )
                          
      axlVisibleLayer("MANUFACTURING/CUTLINE" t)                      ; 显示 MANUFACTURING/CUTLINE 图层
      axlVisibleUpdate(nil)                                                                ; 刷新视图
    
    
    start_point = axlEnterPoint( ?prompts "Select start_point")
    
    when( start_point
                    ;axlUIWPrint("Select end_point")
                    end_point = axlEnterPoint( ?prompts "Select end_point")
                    when( end_point
                                    cutLine =axlDBCreateLine( list(start_point,end_point),0.0,"manufacturing/cutline")
                        )
        )
    axlUIWPrint(nil "CUTLINE start: %L" start_point)
    axlUIWPrint(nil "CUTLINE end: %L" end_point)
    
    
    
    axlClearSelSet()
    axlSetFindFilter(         ?enabled (list "clinesegs")
                              ?onButtons (list "clinesegs")      
                     )
                            
    mypopup = axlUIPopupDefine(nil (list (list "Done" 'axlFinishEnterFun) (list "Cancel" 'axlCancelEnterFun)))
    axlUIPopupSet(mypopup)                                        
    axlSelect(   ?prompt "select clinesegs:"
                 ?groupMode nil
                 
             )
    clinelist = axlGetSelSet()
    when(clinelist
    	;mark = axlDBTransactionStart() ; 开始数据库事务（可选）
     	;axlDBTransactionMark(mark)
    	
    	foreach(segDb clinelist
        axlHighlightObject(segDb)  ; 高亮对象
    	axlUIWPrint(nil "TYPE: %s" segDb->objType)
    	axlUIWPrint(nil "PRO: %L" segDb->? ?)				
    	start_xy = car(segDb->startEnd)
    	end_xy = cadr(segDb->startEnd)				
    	dx = car(end_xy) - car(start_xy)
    	dy = cadr(end_xy) - cadr(start_xy)				
    	if(( dx != 0) && (dy!=0) then
    		k=dy/dx
    		
    	else
    		k=0
    		)
    		
    	seg_length = sqrt(dx*dx + dy*dy)		
    	axlUIWPrint(nil "cline start: %L" start_xy)
    	axlUIWPrint(nil "cline end: %L" end_xy)
    	axlUIWPrint(nil "cline length: %L" seg_length)
    	axlUIWPrint(nil "cline k: %L" k)
    	intersection = getSegmentIntersection(start_point,end_point,start_xy,end_xy)
    	if(( dx != 0) && (dy!=0) then
    		intersection2=list(car(intersection)-10,cadr(intersection)-10*k)
    		)
    	if(( dx == 0) then
    		intersection2=list(car(intersection),cadr(intersection)-10)
    		)
    	if(( dy == 0) then
    		intersection2=list(car(intersection)-10,cadr(intersection))
    		)
    	
    	parent_clinesegs = segDb->parent
    
    	seg_net = parent_clinesegs->net
    	seg_layer = parent_clinesegs->layer
    	seg_width = segDb->width
    
    	axlUIWPrint(nil "CLINE NET: %L" seg_net)
    	axlUIWPrint(nil "CLINE LAYER: %L" seg_layer)
   	 	axlUIWPrint(nil "CLINE WIDTH: %L" seg_width)	
   	 	
     	when( intersection
                    axlUIWPrint(nil "切割点: %L" intersection)
                    axlDeleteObject(segDb)
                    new_seg1 = axlPathStart(list(start_xy,intersection),seg_width)
                    new_seg2 = axlPathStart(list(end_xy,intersection2),seg_width)
                    axlDBCreatePath(new_seg1 seg_layer seg_net)
                    axlDBCreatePath(new_seg2 seg_layer seg_net)
                    ;;axlDBCreateLine(list(start_xy,intersection),seg_width,seg_layer,seg_net)
                    ;;axlDBCreateLine(list(end_xy,intersection2),seg_width,seg_layer,seg_net)
                    ;;axlShowObject( clinelist)
        	)	
    	)   
    	;axlDBTransactionCommit(mark)
    	;axlDBTransactionOops(mark)
    	axlVisibleUpdate(t)
    	;axlUIWPrint(nil "Highlighted %d clinesegs" length(clinelist))
		)

  )