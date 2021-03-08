IncludeFile "MaterialVector.pbi"

Global FrontColor = RGBA(16, 16, 20, 255), BackColor = RGBA(255, 255, 255, 255)

Procedure Update()
	Protected Icon = GetGadgetState(1)
	
	StartVectorDrawing(CanvasVectorOutput(0))
	AddPathBox(0, 0, VectorOutputWidth(), VectorOutputHeight())
	VectorSourceColor(BackColor)
	FillPath()

	MaterialVector::Draw(Icon, 10, 10, 16, FrontColor, BackColor)
	MaterialVector::Draw(Icon, 30, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline)
	MaterialVector::Draw(Icon, 50, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Box)
	MaterialVector::Draw(Icon, 70, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline)
	MaterialVector::Draw(Icon, 90, 10, 16, FrontColor, BackColor, MaterialVector::#Style_Circle)
	
	MaterialVector::Draw(Icon, 10, 45, 32, FrontColor, BackColor, MaterialVector::#style_rotate_90)
	MaterialVector::Draw(Icon, 50, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_90)
	MaterialVector::Draw(Icon, 90, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_90)
	MaterialVector::Draw(Icon, 130, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_90)
	MaterialVector::Draw(Icon, 170, 45, 32, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_90)
	
	MaterialVector::Draw(Icon, 10, 100, 64, FrontColor, BackColor, MaterialVector::#style_rotate_180)
	MaterialVector::Draw(Icon, 80, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_180)
	MaterialVector::Draw(Icon, 150, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_180)
	MaterialVector::Draw(Icon, 220, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_180)
	MaterialVector::Draw(Icon, 290, 100, 64, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_180)
	
	MaterialVector::Draw(Icon, 10, 200, 96, FrontColor, BackColor, MaterialVector::#style_rotate_270)
	MaterialVector::Draw(Icon, 120, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_270)
	MaterialVector::Draw(Icon, 230, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Box|MaterialVector::#style_rotate_270)
	MaterialVector::Draw(Icon, 340, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#Style_Outline|MaterialVector::#style_rotate_270)
	MaterialVector::Draw(Icon, 450, 200, 96, FrontColor, BackColor, MaterialVector::#Style_Circle|MaterialVector::#style_rotate_270)
	StopVectorDrawing()
EndProcedure

OpenWindow(0, 0, 0, 560, 380, "Material Vector Gallery", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
SetWindowColor(0, #White)
CanvasGadget(0, 0, 40, 560, 340)

ComboBoxGadget(1, 10, 10, 120, 20)
AddGadgetItem(1, -1, "Arrow")
AddGadgetItem(1, -1, "Chevron")

SetGadgetState(1,0)

Update()

BindGadgetEvent(1,@Update(), #PB_EventType_Change)

Repeat
	WaitWindowEvent()
ForEver
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 34
; Folding = -
; EnableXP