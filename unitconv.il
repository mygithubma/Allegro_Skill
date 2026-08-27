
axlCmdRegister( "unitconv" '_unit_conv)

defun( _unit_conv ()
	
	FORMFILE = outfile( "./unitconv.form")
	fprintf( FORMFILE "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf( FORMFILE "FORM\n")
	fprintf( FORMFILE "FIXED\n")
	fprintf( FORMFILE "PORT 40 10\n")
	fprintf( FORMFILE "HEADER \"Unit Conv V1.0\"\n")
	fprintf( FORMFILE "\n")
	
    fprintf( FORMFILE "TILE\n")
	
	fprintf( FORMFILE "TEXT \"Unitconv(mm/mil)\"\n")
	fprintf( FORMFILE "TLOC  12 2\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
	
	fprintf( FORMFILE "FIELD mm\n")
	fprintf( FORMFILE "FLOC 5 5\n")
    fprintf( FORMFILE "REALFILLIN 10 100\n")
    fprintf( FORMFILE "ENDFIELD\n")
    fprintf( FORMFILE "\n")
    
    fprintf( FORMFILE "TEXT \"mm\"\n")
	fprintf( FORMFILE "TLOC  17 5\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
    
    fprintf( FORMFILE "TEXT \"=\"\n")
	fprintf( FORMFILE "TLOC  20 5\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
	
	fprintf( FORMFILE "FIELD mil\n")
	fprintf( FORMFILE "FLOC 25 5\n")
    fprintf( FORMFILE "REALFILLIN 10 100\n")
    fprintf( FORMFILE "ENDFIELD\n")
    fprintf( FORMFILE "\n")
    
    fprintf( FORMFILE "TEXT \"mil\"\n")
	fprintf( FORMFILE "TLOC  37 5\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
	
	
	fprintf( FORMFILE "FIELD clear\n")
	fprintf( FORMFILE "FLOC 5 7\n")
	fprintf( FORMFILE "MENUBUTTON \"Clear\" 6 4\n")
    fprintf( FORMFILE "ENDFIELD\n")
   	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "FIELD exit\n")
	fprintf( FORMFILE "FLOC 25 7\n")
	fprintf( FORMFILE "MENUBUTTON \"Exit\" 6 4\n")
    fprintf( FORMFILE "ENDFIELD\n")
   	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "ENDTILE\n")
    fprintf( FORMFILE "\n")
    fprintf( FORMFILE "ENDFORM\n")
	
	close( FORMFILE)
	
	form = (axlFormCreate (gensym) "unitconv.form" `("E" "OUTER") `Unitconv_Callback t)
	axlFormDisplay( form)
    axlFormSetDecimal(form "mil" 4)
    axlFormSetDecimal(form "mm" 4)
	deleteFile( "unitconv.form")

	;axlFormDisplay(Form1)
	;axlUIViewFileCreate("test.txt" "TEST" nil)
)

(defun Unitconv_Callback (form)
(prog ()
		case( form->curField
				("mm"
					mm = form->curValue
					mil = axlMKSConvert( mm "MM" "MILS")
					axlFormSetField( form "mil" mil)
				t)
				
				("mil"
					mil = form->curValue
					mm = axlMKSConvert( mil "MILS" "MM")
					axlFormSetField( form "mm" mm)
				t)
				
				("clear"
					axlFormSetField( form "mm" nil)
					axlFormSetField( form "mil" nil)
				t)
				("exit"
					axlFormClose(form)
				t)
			)
)
)		
       

	