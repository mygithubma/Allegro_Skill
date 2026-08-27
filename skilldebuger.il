axlCmdRegister( "skilldebuger" 'skill_debuger)

defun( skill_debuger ()
	
	FORMFILE = outfile( "./skilldebuger.form")
	fprintf( FORMFILE "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf( FORMFILE "FORM\n")
	fprintf( FORMFILE "FIXED\n")
	fprintf( FORMFILE "PORT 40 20\n")
	fprintf( FORMFILE "HEADER \"Skill Debuger V1.0\"\n")
	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "TILE\n")
	fprintf( FORMFILE "TEXT \"Skill Debuger\"\n")
	fprintf( FORMFILE "TLOC  20 2\n")
	fprintf( FORMFILE "ENDTEXT\n\n")
	
	; �ļ�·����ʾ��
	fprintf( FORMFILE "FIELD file\n")
	fprintf( FORMFILE "FLOC 5 5\n")
	fprintf( FORMFILE "LIST \"\" 28 5\n")
	fprintf( FORMFILE "OPTIONS multiselect\n")
	fprintf( FORMFILE "ENDFIELD\n")
	fprintf( FORMFILE "\n")
	
	; �ļ�ѡ��ť
	fprintf( FORMFILE "FIELD browse\n")
	fprintf( FORMFILE "FLOC 34 5\n")
	fprintf( FORMFILE "MENUBUTTON \"...\" 6 4\n")
	fprintf( FORMFILE "ENDFIELD\n")
	fprintf( FORMFILE "\n")
	
	; ���������
	fprintf( FORMFILE "TEXT \"Password:\"\n")
	fprintf( FORMFILE "TLOC 5 13\n")
	fprintf( FORMFILE "ENDTEXT\n")
	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "FIELD password\n")
	fprintf( FORMFILE "FLOC 10 13\n")
	fprintf( FORMFILE "STRFILLIN 21 15\n")
	fprintf( FORMFILE "ENDFIELD\n")
	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "FIELD load\n")
	fprintf( FORMFILE "FLOC 5 16\n")
	fprintf( FORMFILE "MENUBUTTON \"Load\" 12 4\n")
	fprintf( FORMFILE "ENDFIELD\n")
	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "FIELD exit\n")
	fprintf( FORMFILE "FLOC 25 16\n")
	fprintf( FORMFILE "MENUBUTTON \"Exit\" 12 4\n")
	fprintf( FORMFILE "ENDFIELD\n")
	fprintf( FORMFILE "\n")
	
	fprintf( FORMFILE "ENDTILE\n")
	fprintf( FORMFILE "\n")
	fprintf( FORMFILE "ENDFORM\n")
	
	close( FORMFILE)
	
	form = (axlFormCreate (gensym) "skilldebuger.form" `("E" "OUTER") `SkillDebuger_Callback t)
	axlFormDisplay( form)
	deleteFile( "skilldebuger.form")

)

defun( SkillDebuger_Callback (form)
	case(form->curField
		("browse"
			; ���ļ�ѡ��Ի��򣬹���.il�ļ�
			let( (file)
				file = axlDMFileBrowse(nil nil ?optFilters "Skill files(*.il *.ile)|*.il;*.ile|")
				printf("Selected file: %s\n" file)
				when( file
					; ����վɼ�¼
					;axlFormListDeleteAll( form "file")
					; ���ӵ��б�ĩβ
					axlFormListAddItem( form "file" file -1)
				)
			)
		)
		("load"
			let( (selItems filePath password)
				; ��ȡ�б�ѡ����Ŀ�б�
				selItems = axlFormListGetSelItems( form "file")
				filePath = car(selItems)
				axlUIWPrint(nil "FilePath: %L" filePath)
				password = axlFormGetField(form "password")
				axlUIWPrint(nil "Password enter: %L" password)

				
				; �ж�·������������Ч�ļ�
				if( filePath && isFile(filePath) then
					(if (password && password != "")
                load(filePath, password)
                load(filePath)
            )
					axlUIConfirm( strcat("Success Load: \n" filePath))
				else
					axlUIConfirm( "Please Select .il file!!!")
					)

				)
		)
		("exit"
			axlFormClose( form)
		)
	)
)