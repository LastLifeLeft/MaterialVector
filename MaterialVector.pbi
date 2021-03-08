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
		#Plus
		#Minus
		#Video
		#Person
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
	Declare AddPathRoundedBox(x, y, Width, Height, Radius, Flag = #PB_Path_Default)
	;}
	
	Procedure Draw(icon, x, y, Size, FrontColor, BackColor, Style = #Style_Regular)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5, Half.i = Size/2, Path.i
		
		MovePathCursor(x, y)
		
		If Style & #Style_Circle
			If Style & #Style_Outline
				AddPathCircle(Half, Half, Half - Margin, 0, 360, #PB_Path_Relative)
				VectorSourceColor(BackColor)
				FillPath(#PB_Path_Preserve)
				VectorSourceColor(FrontColor)
				StrokePath(PathWidth, #PB_Path_Default)
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon),  x + PathWidth * 2, y + PathWidth * 2, Size - PathWidth * 4, FrontColor, BackColor, Style!#Style_Outline|#Style_NoPath)
			Else
				AddPathCircle(Half, Half, Half, 0, 360, #PB_Path_Relative)
				VectorSourceColor(FrontColor)
				FillPath()
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon),  x + PathWidth * 2, y + PathWidth * 2, Size - PathWidth * 4, BackColor, FrontColor, Style|#Style_NoPath)
			EndIf
			StrokePath(PathWidth, Path)
		ElseIf Style & #Style_Box
			If Style & #Style_Outline
				AddPathRoundedBox(Margin, Margin, Size - Margin * 2, Size - Margin * 2, Margin, #PB_Path_Relative)
				VectorSourceColor(BackColor)
				FillPath(#PB_Path_Preserve)
				VectorSourceColor(FrontColor)
				StrokePath(PathWidth, #PB_Path_Default)
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon), x + PathWidth * 2, y + PathWidth * 2, Size - PathWidth * 4, FrontColor, BackColor, Style!#Style_Outline|#Style_NoPath)
			Else
				AddPathRoundedBox(0, 0, Size, Size, PathWidth, #PB_Path_Relative)
				VectorSourceColor(FrontColor)
				FillPath()
				MovePathCursor(x, y)
				Path = CallFunctionFast(Function(icon),  x + PathWidth * 2, y + PathWidth * 2, Size - PathWidth * 4, BackColor, FrontColor, Style|#Style_NoPath)
			EndIf
			StrokePath(PathWidth, Path)
		Else
			CallFunctionFast(Function(icon), x, y, Size, FrontColor, BackColor, Style)
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
		
	Procedure AddPathRoundedBox(x, y, Width, Height, Radius, Flag = #PB_Path_Default)
		MovePathCursor(x, y + Radius, Flag)
		
		AddPathArc(0, Height - radius, Width, Height - radius, Radius, #PB_Path_Relative)
		AddPathArc(Width - Radius, 0, Width - Radius, - Height, Radius, #PB_Path_Relative)
		AddPathArc(0, Radius - Height, -Width, Radius - Height, Radius, #PB_Path_Relative)
		AddPathArc(Radius - Width, 0, Radius - Width, Height, Radius, #PB_Path_Relative)
		ClosePath()
		
		MovePathCursor(-x,-y-Radius, Flag)
	EndProcedure
	
	Procedure Arrow(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5, Half.i = Size * 0.5
		
		MovePathCursor(x, y)
		
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
		
		MovePathCursor(x, y)
		
		Protected Rotation = Rotation(Style, Size)
		
		MovePathCursor(Margin, Half + PathWidth + Margin, #PB_Path_Relative)
		AddPathLine(Half - Margin, Margin - Half, #PB_Path_Relative)
		AddPathLine(Half - Margin,	Half - Margin, #PB_Path_Relative)
		VectorSourceColor(FrontColor)
		
		If Not Style & #Style_NoPath
			StrokePath(PathWidth, #PB_Path_RoundCorner|#PB_Path_RoundEnd)
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_RoundCorner|#PB_Path_RoundEnd
	EndProcedure
	
	Procedure Plus(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up),  Half.i = Size * 0.5
		
		MovePathCursor(x, y)
		VectorSourceColor(FrontColor)
		
		Protected Rotation = Rotation(Style, Size)
		
		If Style & #Style_Outline
			
			MovePathCursor(Half - PathWidth, PathWidth, #PB_Path_Relative)
			AddPathLine(0, Half - PathWidth * 2, #PB_Path_Relative)
			AddPathLine(PathWidth * 2 - Half, 0, #PB_Path_Relative)
			AddPathLine(0, PathWidth * 2, #PB_Path_Relative)
			AddPathLine(Half - PathWidth * 2, 0, #PB_Path_Relative)
			AddPathLine(0, Half - PathWidth * 2, #PB_Path_Relative)
			AddPathLine(PathWidth * 2,0, #PB_Path_Relative)
			AddPathLine(0, PathWidth * 2 - Half , #PB_Path_Relative)
			AddPathLine(Half - PathWidth * 2, 0, #PB_Path_Relative)
			AddPathLine(0, - PathWidth * 2, #PB_Path_Relative)
			AddPathLine(PathWidth * 2 - Half, 0, #PB_Path_Relative)
			AddPathLine(0, PathWidth * 2 - Half, #PB_Path_Relative)
			ClosePath()
			
			StrokePath(PathWidth, #PB_Path_Default)
		Else
			
			MovePathCursor(Half, PathWidth, #PB_Path_Relative)
			AddPathLine(0, Size - PathWidth * 2, #PB_Path_Relative)
			
			MovePathCursor(PathWidth - Half, PathWidth - Half, #PB_Path_Relative)
			AddPathLine(Size - PathWidth * 2, 0, #PB_Path_Relative)
			
			If Not Style & #Style_NoPath
				StrokePath(PathWidth, #PB_Path_Default)
			EndIf
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default
	EndProcedure
	
	Procedure Minus(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Half.i = Size * 0.5
		
		MovePathCursor(x, y)
		VectorSourceColor(FrontColor)
		
		Protected Rotation = Rotation(Style, Size)
		
		If Style & #Style_Outline
			MovePathCursor(PathWidth, Half - PathWidth, #PB_Path_Relative)
			AddPathBox(0,0, Size - PathWidth * 2, PathWidth * 2,  #PB_Path_Relative)
			StrokePath(PathWidth, #PB_Path_Default)
		Else
			MovePathCursor(PathWidth, Half, #PB_Path_Relative)
			AddPathLine(Size - PathWidth * 2, 0, #PB_Path_Relative)

			If Not Style & #Style_NoPath
				StrokePath(PathWidth, #PB_Path_Default)
			EndIf
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default
	EndProcedure
	
	Procedure Video(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5, Half.i = Size * 0.5
		
		MovePathCursor(x, y)
		VectorSourceColor(FrontColor)
		
		Protected Rotation = Rotation(Style, Size)
		
		MovePathCursor(Size - Margin, PathWidth * 2 + Margin, #PB_Path_Relative)
		AddPathLine(0, PathWidth * 4, #PB_Path_Relative)
		AddPathLine(- PathWidth * 2 - Margin, - PathWidth * 2, #PB_Path_Relative)
		ClosePath()
		FillPath()
		
		If Rotation ; Couldn't figure a way out of this since fillpath reset the cursor position...
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		MovePathCursor(x, y)
		
		Rotation(Style, Size)
		
		If Style & #Style_Outline
			AddPathRoundedBox(Margin, PathWidth * 2 + Margin, Size - PathWidth * 3, PathWidth * 4, Margin * 0.33, #PB_Path_Relative)
			StrokePath(PathWidth, #PB_Path_Default)
		Else
			AddPathRoundedBox(0, PathWidth * 2, Size - PathWidth * 2, PathWidth * 5, Margin, #PB_Path_Relative)
			FillPath()
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default
	EndProcedure	
	
	Procedure Person(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up), Margin.i = PathWidth * 0.5, Half.i = Size * 0.5
		
		MovePathCursor(x, y)
		VectorSourceColor(FrontColor)
		
		Protected Rotation = Rotation(Style, Size)
		
		If Style & #Style_Outline
			MovePathCursor(PathWidth + Margin, Size - PathWidth * 4, #PB_Path_Relative)
			AddPathLine(0, PathWidth * 2, #PB_Path_Relative)
			AddPathLine(Size - PathWidth * 3, 0, #PB_Path_Relative)
			AddPathLine(0, - PathWidth * 2, #PB_Path_Relative)
			AddPathEllipse(- (Size - PathWidth * 3) * 0.5, Margin * 0.5, (Size - PathWidth * 3) * 0.5 , PathWidth, 180, 360, #PB_Path_Relative)
			
			AddPathCircle(- (Size - PathWidth * 3) * 0.5, - PathWidth * 3 - Margin, PathWidth, 0, 360, #PB_Path_Relative)
			
			StrokePath(PathWidth, #PB_Path_Default)
		Else
			MovePathCursor(PathWidth + Margin, Size - PathWidth * 4, #PB_Path_Relative)
			AddPathLine(0, PathWidth * 2, #PB_Path_Relative)
			AddPathLine(Size - PathWidth * 3, 0, #PB_Path_Relative)
			AddPathLine(0, - PathWidth * 2, #PB_Path_Relative)
			AddPathEllipse(- (Size - PathWidth * 3) * 0.5, 0, (Size - PathWidth * 3) * 0.5 , PathWidth, 180, 360, #PB_Path_Relative)
			
			AddPathCircle(- (Size - PathWidth * 3) * 0.5, - PathWidth * 3, PathWidth + Margin, 0, 360, #PB_Path_Relative)

			FillPath(#PB_Path_Winding)
		EndIf
		
		If Rotation
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default ; returns the correct path flaf for boxes/circled icons
	EndProcedure
	
	Procedure NewIconExample(x, y, Size, FrontColor, BackColor, Style)
		Protected PathWidth.i = Round(Size * 0.1, #PB_Round_Up) ;< seems to be the correct width to "feel" material design
		
		MovePathCursor(x, y)
		VectorSourceColor(FrontColor)
		
		Protected Rotation = Rotation(Style, Size) ;< call rotation for an automatic setup
		
		If Not Style & #Style_NoPath	;< if needed, draw your paths
			StrokePath(PathWidth, #PB_Path_Default)
		EndIf
		
		If Rotation ;< return the output to it's original position
			RotateCoordinates(0, 0, -Rotation)
		EndIf
		
		ProcedureReturn #PB_Path_Default ; returns the correct path flaf for boxes/circled icons
	EndProcedure
	
	Function(#Arrow) = @Arrow()
	Function(#Chevron) = @Chevron()
	Function(#Plus) = @Plus()
	Function(#Minus) = @Minus()
	Function(#Video) = @Video()
	Function(#Person) = @Person()
	
EndModule

CompilerIf #PB_Compiler_IsMainFile ;Gallery
	Global FrontColor = RGBA(16, 16, 20, 255), BackColor = RGBA(255, 255, 255, 255)
	
	Procedure Update()
		Protected Icon = GetGadgetState(1)
		StartVectorDrawing(CanvasVectorOutput(0))
		AddPathBox(0, 0, VectorOutputWidth(), VectorOutputHeight())
		VectorSourceColor(BackColor)
		FillPath()
		
		MaterialVector::Draw(Icon, 10, 10, 16, FrontColor, BackColor)
		MaterialVector::Draw(Icon, 30, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 50, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 70, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Box)
		MaterialVector::Draw(Icon, 90, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 110, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Circle)
		
		MaterialVector::Draw(Icon, 10, 45, 32, FrontColor, BackColor, MaterialVector::#style_rotate_90)
		MaterialVector::Draw(Icon, 50, 45, 32, FrontColor, BackColor, MaterialVector::#style_rotate_90|MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 90, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_90)
		MaterialVector::Draw(Icon, 130, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_90)
		MaterialVector::Draw(Icon, 170, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_90)
		MaterialVector::Draw(Icon, 210, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_90)
		
		MaterialVector::Draw(Icon, 10, 100, 64, FrontColor, BackColor, MaterialVector::#style_rotate_180)
		MaterialVector::Draw(Icon, 80, 100, 64, FrontColor, BackColor, MaterialVector::#style_rotate_180|MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 150, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_180)
		MaterialVector::Draw(Icon, 220, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_180)
		MaterialVector::Draw(Icon, 290, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_180)
		MaterialVector::Draw(Icon, 360, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_180)
		
		MaterialVector::Draw(Icon, 10, 200, 96, FrontColor, BackColor, MaterialVector::#style_rotate_270)
		MaterialVector::Draw(Icon, 120, 200, 96, FrontColor, BackColor, MaterialVector::#style_rotate_270|MaterialVector::#Style_Outline)
		MaterialVector::Draw(Icon, 230, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_270)
		MaterialVector::Draw(Icon, 340, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_270)
		MaterialVector::Draw(Icon, 450, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_270)
		MaterialVector::Draw(Icon, 560, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_270)
		StopVectorDrawing()
	EndProcedure
	
	Procedure Close()
		End
	EndProcedure
	
	OpenWindow(0, 0, 0, 670, 360, "Material Vector Gallery", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	SetWindowColor(0, #White)
	CanvasGadget(0, 0, 40, 670, 320)
	
	ComboBoxGadget(1, 10, 10, 120, 20)
	AddGadgetItem(1, -1, "Arrow")
	AddGadgetItem(1, -1, "Chevron")
	AddGadgetItem(1, -1, "Plus")
	AddGadgetItem(1, -1, "Minus")
	AddGadgetItem(1, -1, "Video")
	AddGadgetItem(1, -1, "Person")
	
	SetGadgetState(1,0)
	
	Update()
	
	BindGadgetEvent(1,@Update(), #PB_EventType_Change)
	BindEvent(#PB_Event_CloseWindow, @Close())
	
	Repeat
		WaitWindowEvent()
	ForEver
CompilerEndIf


























; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 287
; FirstLine = 114
; Folding = vk0
; EnableXP