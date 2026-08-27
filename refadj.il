axlCmdRegister( "refadj" 'refadj)

;---Function jkGetRefIDComDir() will get standard information which is need to rotate the REF
;---Include top side components direction (l_nTopCompDir),
;---bottom side components direction (l_nBtmCompDir),
;---top side components' REFDES DBID list(l_dbTopRefDbid),
;---bottom side components' REFDES DBID list(l_dbBtmRefDbid),
procedure( jkGetRefIDComDir(@optional (l_SymList nil))
            if(l_SymList == nil then
        				;l_dbAllSyms = axlDBGetDesign()->symbols
    				else
        				l_dbAllSyms = l_SymList
    					)

;---fill l_nTopCompDir and l_nBtmCompDir with components' direction


           foreach(sym l_dbAllSyms
               if(stringp(sym->refdes);if read something unknown,skip the following steps
                 then
                   if(sym->isMirrored != t ;on top side

                   then
                        l_nTopCompDir = cons(round(sym->rotation) l_nTopCompDir)
                        l_dbAttachedTxt = axlDBGetAttachedText(sym)

                        foreach(txt l_dbAttachedTxt

                                if(txt->layer == "REF DES/SILKSCREEN_TOP"
                                then
                                   l_dbTopRefDbid = cons(txt l_dbTopRefDbid)
                                );end of if (txt->layer == "REF DES/SILKSCREEN_TOP"
                        );end of foreach(txt l_dbAttachedTxt

                   else
                        l_nBtmCompDir = cons(round(sym->rotation) l_nBtmCompDir)
                        l_dbAttachedTxt = axlDBGetAttachedText(sym)

                        foreach(txt l_dbAttachedTxt

                                if(txt->layer == "REF DES/SILKSCREEN_BOTTOM"
                                then
                                   l_dbBtmRefDbid = cons(txt l_dbBtmRefDbid)
                                );end of if(txt->layer == "REF DES/SILKSCREEN_BOTTOM"
                        );end of foreach(txt l_dbAttachedTxt

                   );end of if (sym->isMirrored != t ;on top side
                 else

               );end of if(stringp(sym->refdes)

           );end of foreach(sym l_dbAllSyms

);end of procedure( jkGetRefIDComDir()

procedure( jkRotateTopRef(ll_dbTopRef ll_nTopComDir)
p = outfile("out.txt")
          foreach((dbTopRef nTopComDir) ll_dbTopRef ll_nTopComDir

                 ;get information no need to modify
                 sRefContent = dbTopRef->text
                 dbParent = dbTopRef->parent
                 xy = dbTopRef->parent->xy
                 sRefLayer = dbTopRef->layer
                 bMirror = dbTopRef->isMirrored
                 sJustify = dbTopRef->justify
                 sTxtBlock = dbTopRef->textBlock
                 ;nRefOri = round(dbTopRef->rotation)
	nTopComDir = round(dbParent->rotation)
                 ;if components' direction is not 90 and 270 degree,its REF degree is 0,otherwise is 90
                 ;and if the original refdes's direction is right,skip it
                 ;if(nRefOri != 90 && nRefOri != 0
                   ;then
                     if((nTopComDir > 75 && nTopComDir < 105) || (nTopComDir > 255 && nTopComDir < 285)
                     then
                        nRefDir = 90
                        ptRefxy = list(nth(0,xy)+10 nth(1,xy)-30)
                     else
                        nRefDir = 0
                        ptRefxy = list(nth(0,xy)-30 nth(1,xy)-10)

                     );end of if(nTopComDir > 85 && nTopComDir < 95 || nTopComDir > 265 && nTopComDir < 275

                   ;else
                    ; nRefDir = nRefOri
                 ;);end of if(nRefOri != 90 && nRefOri != 0

                 ;fill the text structure r_textOrientation
                 stTxtOri = make_axlTextOrientation(
                                 ?textBlock sTxtBlock
                                 ?rotation nRefDir
                                 ?mirrored bMirror
                                 ?justify sJustify
                            );end fill structure

                 isCreation = axlDBCreateText(
                            sRefContent
                            ptRefxy
                            stTxtOri
                            sRefLayer
                            dbParent
                            )

                 if( isCreation != nil axlDeleteObject( dbTopRef))

          );end of foreach((dbTopRef nTopComDir) ll_dbTopRef ll_nTopComDir
close(p)
);end of procedure( jkRotateTopRef(ll_dbTopRef ll_nTopComDir)


;---------------------------------------------------------------------------
;----------Rotate Refdes on Btm side----------------------
;---------------------------------------------------------------------------
procedure( jkRotateBtmRef(ll_dbBtmRef ll_nBtmComDir)
          foreach((dbBtmRef nBtmComDir) ll_dbBtmRef ll_nBtmComDir

                 ;get information no need to modify
                 sRefContent = dbBtmRef->text
                 dbParent = dbBtmRef->parent
                 xy = dbBtmRef->parent->xy
                 sRefLayer = dbBtmRef->layer
                 bMirror = dbBtmRef->isMirrored
                 sJustify = dbBtmRef->justify
                 sTxtBlock = dbBtmRef->textBlock
                 ;nRefOri = round(dbBtmRef->rotation)

	nBtmComDir = round(dbParent->rotation)
                 ;if components' direction is not 90 and 270 degree,its REF degree is 0,otherwise is 90
                 ;and if the original refdes's direction is right,skip it
                 ;if(nRefOri != 270 && nRefOri != 0
                   ;then
                     if(nBtmComDir > 85 && nBtmComDir < 95 || nBtmComDir > 265 && nBtmComDir < 275

                     then
                        nRefDir = 270
                        ptRefxy = list(nth(0,xy)-10 nth(1,xy)-30)
                     else
                        nRefDir = 0
                        ptRefxy = list(nth(0,xy)+30 nth(1,xy)-10)

                     );end of if(nBtmComDir > 85 && nBtmComDir < 95 || nBtmComDir > 265 && nBtmComDir < 275

                   ;else
                     ;nRefDir = nRefOri
                 ;);end of if(nRefOri != 270 && nRefOri != 0

                 ;fill the text structure r_textOrientation
                 stTxtOri = make_axlTextOrientation(
                                 ?textBlock sTxtBlock
                                 ?rotation nRefDir
                                 ?mirrored bMirror
                                 ?justify sJustify
                            );end fill structure

                 isCreation = axlDBCreateText(
                            sRefContent
                            ptRefxy
                            stTxtOri
                            sRefLayer
                            dbParent
                            )

                 if( isCreation != nil axlDeleteObject( dbBtmRef))

          );end of foreach((dbBtmRef nBtmComDir) ll_dbBtmRef ll_nBtmComDir

);end of procedure( jkRotateTopRef(ll_dbBtmRef ll_nBtmComDir)

defun( refadj ()
	
	FORMFILE = outfile( "./refadj.form")
	fprintf( FORMFILE "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf( FORMFILE "FORM\n")
	fprintf( FORMFILE "FIXED\n")
	fprintf( FORMFILE "PORT 35 10\n")
	fprintf( FORMFILE "HEADER \"RefAdj V1.0\"\n")
	fprintf( FORMFILE "\n")
    
  fprintf( FORMFILE "TILE\n")
    
  fprintf( FORMFILE "TEXT \"RefAdj V1.0\"\n")
	fprintf( FORMFILE "TLOC  15 2\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
    
	fprintf( FORMFILE "FIELD AllPcb\n")
	fprintf( FORMFILE "FLOC 5 7\n")
	fprintf( FORMFILE "MENUBUTTON \"ALL\" 5 4\n")
  fprintf( FORMFILE "ENDFIELD\n")
  fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "FIELD Select\n")
	fprintf( FORMFILE "FLOC 15 7\n")
	fprintf( FORMFILE "MENUBUTTON \"Select\" 5 4\n")
  fprintf( FORMFILE "ENDFIELD\n")
  fprintf( FORMFILE "\n")
  
	fprintf( FORMFILE "FIELD exit\n")
	fprintf( FORMFILE "FLOC 25 7\n")
	fprintf( FORMFILE "MENUBUTTON \"Exit\" 5 4\n")
  fprintf( FORMFILE "ENDFIELD\n")
  fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "ENDTILE\n")
  fprintf( FORMFILE "\n")
  fprintf( FORMFILE "ENDFORM\n")
	
	close( FORMFILE)
	
	form = (axlFormCreate (gensym) "refadj.form" `("E" "OUTER") `Refadj_Callback t)
	axlFormDisplay( form)
	deleteFile( "refadj.form")
	

	;axlFormDisplay(Form1)
	;axlUIViewFileCreate("test.txt" "TEST" nil)
)

defun( Refadj_Callback (form)
		case( form->curField
				("AllPcb"
					axlVisibleLayer( "BOARD GEOMETRY/OUTLINE" t )
					;axlVisibleLayer( "PIN/TOP" t )
					;axlVisibleLayer( "PIN/BOTTOM" t )
					axlVisibleLayer( "REF DES/SILKSCREEN_TOP" t )
					axlVisibleLayer( "REF DES/SILKSCREEN_BOTTOM" t )
					axlVisibleLayer( "PACKAGE GEOMETRY/SILKSCREEN_TOP" t )
					axlVisibleLayer( "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" t )
					axlVisibleUpdate(nil)
					axlUIWPrint(nil "ALL SYM ADJ")
					l_nTopCompDir = nil
   				l_nBtmCompDir = nil
   				l_dbTopRefDbid = nil
   				l_dbBtmRefDbid = nil
   				if(axlOKToProceed() != t
        		then
            	axlUIWPrint(nil "Finish current command first")
            	;return(nil)
        	else
        			dbCurrentDesign = axlDBGetDesign()
            	jkGetRefIDComDir()
            	jkRotateTopRef(l_dbTopRefDbid l_nTopCompDir)
            	jkRotateBtmRef(l_dbBtmRefDbid l_nBtmCompDir)
            	axlUIWPrint(nil "OK")
   				)
				)
			
        ("Select"
          axlUIWPrint(nil "Please select symbols (Right-click Done to finish)...")
          
          /*mypopup = axlUIPopupDefine( nil
				              (list (list "Done" 'axlFinishEnterFun)
				              (list "Cancel" 'axlCancelEnterFun)
				              )
				              )
          axlUIPopupSet(mypopup)
          ; ★ 设置过滤器只选择 symbols
*/
          axlSetFindFilter(
                        ?enabled (list "symbols")
                       ?onButtons (list "symbols")
                )
                
          axlSelect(?prompt "select symbols:"
                          ?groupMode nil)
          l_selSet = axlGetSelSet()
          ;axlShowObject(l_selSet)
          ;axlClearSelSet()

          ; ★ 检查是否选择了元件
          if(l_selSet == nil then
                          axlUIWPrint(nil "No symbols selected or cancelled!")
                          ;axlUIPopupSet(nil)
                          axlSetFindFilter(?enabled (list "NOALL" "pins" "vias" "symbols" "text") ?onButtons (list "NOALL" "pins" "vias" "symbols" "text"))
                          axlClearSelSet()
                      )
                
                      ; ★ 恢复默认选择状态
          ;axlUIPopupSet(nil)
          axlUIWPrint(nil "Selected %d symbols", length(l_selSet))
                      
                      ; ★ 清空全局变量
                      l_nTopCompDir = nil
                      l_nBtmCompDir = nil
                      l_dbTopRefDbid = nil
                      l_dbBtmRefDbid = nil
                      
                      ; ★ 传入选中的元件列表
                      jkGetRefIDComDir(l_selSet)
                      
                      ; ★ 分别处理顶层和底层
                      if(l_dbTopRefDbid != nil then
                          jkRotateTopRef(l_dbTopRefDbid l_nTopCompDir)
                      )
                      if(l_dbBtmRefDbid != nil then
                          jkRotateBtmRef(l_dbBtmRefDbid l_nBtmCompDir)
                      )
                      
                      axlUIWPrint(nil "RefDes adjustment completed for selected symbols!")
                      axlClearSelSet()
        )
			
				("exit"
					 	axlUIPopupSet(nil)      ; 移除选择弹窗
            axlClearSelSet()        ; 清空选择
            axlFormClose(form)      ; 关闭窗体
				)
			)
)

      
