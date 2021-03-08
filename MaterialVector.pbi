DeclareModule MaterialVector
	EnumerationBinary
		#Style_Regular = 0
		#Style_Outline
		#Style_Circle
		#Style_Box
		
		#style_rotate_90
		#style_rotate_180
		#style_rotate_270
	EndEnumeration
	
	Enumeration
		#Arrow
		#Chevron
		
		#_LISTSIZE
	EndEnumeration
	
	Declare Draw(icon, x, y, Size, FrontColor, BackColor, Style = #Style_Regular)
EndDeclareModule

Module MaterialVector
	EnableExplicit
	
	;{ Private variables, structures, constants...
	Global Dim Function(#_LISTSIZE)
	
	#Style_NoPath = 16384
	
	;}
	
	;{ Private Procedure Declarations
	Declare AddPathRoundedBox(x, y, Size, Radius, Flag = #PB_Path_Default)
	
	;}
	
	Procedure Draw(icon, x, y, Size, FrontColor, BackColor, Style = #Style_Regular)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5, Half.i = Size/2, Path.i
		
		MovePathCursor(x, y)
		
		If Style & #Style_Circle
			If Style & #Style_Outline
				AddPathCircle(Half, Half, Half - Margin, 0, 360, #PB_Path_Relative)
				VectorSourceColor(BackColor)
				FillPath(#PB_Path_Preserve)
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon), PathWidth * 2, PathWidth * 2, Size - PathWidth * 4, FrontColor, BackColor, Style|#Style_NoPath)
			Else
				AddPathCircle(Half, Half, Half, 0, 360, #PB_Path_Relative)
				VectorSourceColor(FrontColor)
				FillPath()
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon), PathWidth * 2, PathWidth * 2, Size - PathWidth * 4, BackColor, FrontColor, Style|#Style_NoPath)
			EndIf
			StrokePath(PathWidth, Path)
		ElseIf Style & #Style_Box
			If Style & #Style_Outline
				AddPathRoundedBox(Margin, Margin, Size - Margin * 2, Margin, #PB_Path_Relative)
				VectorSourceColor(BackColor)
				FillPath(#PB_Path_Preserve)
				Path = CallFunctionFast(Function(icon), PathWidth * 2, PathWidth * 2, Size - PathWidth * 4, FrontColor, BackColor, Style|#Style_NoPath)
			Else
				AddPathRoundedBox(0, 0, Size, PathWidth, #PB_Path_Relative)
				VectorSourceColor(FrontColor)
				FillPath()
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon), PathWidth * 2, PathWidth * 2, Size - PathWidth * 4, BackColor, FrontColor, Style|#Style_NoPath)
			EndIf
			StrokePath(PathWidth, Path)
		Else
			CallFunctionFast(Function(icon), 0, 0, Size, FrontColor, BackColor, Style)
		EndIf
		
	EndProcedure
	
	; Private procedures
	Procedure Rotation(Style, Size) ; There has to be a better solution, I can't understand why I can't do it with sin and cos...
		Protected Rotation, RotationOffsetX, RotationOffsetY
		If Style & #style_rotate_90
			Rotation = 90
			RotationOffsetY = -Size
		ElseIf Style & #style_rotate_180
			Rotation = 180
			RotationOffsetX = -Size
			RotationOffsetY = -Size
		ElseIf Style & #style_rotate_270
			Rotation = 270
			RotationOffsetX = -Size
		EndIf
		RotateCoordinates(0, 0, Rotation)
		MovePathCursor(RotationOffsetX,RotationOffsetY, #PB_Path_Relative)
		ProcedureReturn Rotation
	EndProcedure
	
	Procedure AddPathRoundedBox(x, y, Size, Radius, Flag = #PB_Path_Default)
		MovePathCursor(x, y + Radius, Flag)
		
		AddPathArc(0, Size - radius, Size, Size - radius, Radius, #PB_Path_Relative)
		AddPathArc(Size - Radius, 0, Size - Radius, - Size, Radius, #PB_Path_Relative)
		AddPathArc(0, Radius - Size, -Size, Radius - Size, Radius, #PB_Path_Relative)
		AddPathArc(Radius - Size, 0, Radius - Size, Size, Radius, #PB_Path_Relative)
		ClosePath()
		
		MovePathCursor(-x,-y-Radius, Flag)
	EndProcedure
	
	Procedure Arrow(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5
		Protected Half.i = Size/2
		
		MovePathCursor(x, y, #PB_Path_Relative)
		
		Protected Rotation = Rotation(Style, Size)
			
		MovePathCursor( Half, PathWidth, #PB_Path_Relative)
		AddPathLine(0, Size - PathWidth, #PB_Path_Relative)
		MovePathCursor(Margin - Half, - Size + Half + Margin, #PB_Path_Relative)
		AddPathLine(Half - Margin, Margin - Half, #PB_Path_Relative)
		AddPathLine(Half - Margin,	Half - Margin, #PB_Path_Relative)
		VectorSourceColor(FrontColor)
		If Not Style & #Style_NoPath
			StrokePath(PathWidth, #PB_Path_Default)
		EndIf
			
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default
	EndProcedure
	
	Procedure Chevron(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5,  Half.i = Size * 0.5
		
		MovePathCursor(x, y, #PB_Path_Relative)
		
		Protected Rotation = Rotation(Style, Size)
		
		MovePathCursor(Margin, Half + PathWidth + Margin, #PB_Path_Relative)
		AddPathLine(Half - Margin, Margin - Half, #PB_Path_Relative)
		AddPathLine(Half - Margin,	Half - Margin, #PB_Path_Relative)
		VectorSourceColor(FrontColor)
		
		If Not Style & #Style_NoPath
			StrokePath(PathWidth, #PB_Path_RoundCorner)
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_RoundCorner|#PB_Path_RoundEnd
	EndProcedure
	
	Procedure NewIconExample(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up) ;< seems to be the correct width to "feel" material design
		
		MovePathCursor(x, y, #PB_Path_Relative)
		
		Protected Rotation = Rotation(Style, Size) ;< call rotation for an automatic setup
		
		If Not Style & #Style_NoPath	;< if needed, draw your paths
			StrokePath(PathWidth, #PB_Path_RoundCorner)
		EndIf
		
		If Rotation ;< return the output to it's original position
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_RoundCorner ; returns the correct path flaf for boxes/circled icons
	EndProcedure
	
	Function(#Arrow) = @Arrow()
	Function(#Chevron) = @Chevron()
	
EndModule































; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 140
; FirstLine = 36
; Folding = P3
; EnableXP
; UseMainFile = Demo.pb