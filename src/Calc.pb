;
; pb-calc
; Copyright 2021, Rafael Nigmatullin
; Released under the MIT License
; https://github.com/kuvalda4g/pb-calc
;

Global start.b = 1
Global last_command.s = ""
Global result.d = 0

; calculate result
Procedure Calculate(value.d)
  Select last_command
    Case "+"
      result = result + value
    Case "–"
      result = result - value
    Case "*"
      result = result * value
    Case "÷"
      result = result / value
  EndSelect
  SetGadgetText(0, StrD(result) + " ")
EndProcedure

; numbers
Procedure NumberButtonHandler()
  If start
    SetGadgetText(0, "")
    start = 0
  EndIf
  num.s = GetGadgetText(EventGadget())
  SetGadgetText(0, RTrim(GetGadgetText(0), " ") + num + " ")
EndProcedure

; commands
Procedure CommandButtonHandler()
  command.s = GetGadgetText(EventGadget())

  If start
    If command = "–"
      SetGadgetText(0, "- ")
      start = 0
    EndIf
  Else
    If command = "="
      Calculate(ValD(RTrim(GetGadgetText(0), " ")))
      last_command = command
    ElseIf command = "."
      SetGadgetText(0, RTrim(GetGadgetText(0), " ") + ". ")
    Else
      result = ValD(RTrim(GetGadgetText(0), " "))
      last_command = command
      start = 1
    EndIf
  EndIf
EndProcedure

If OpenWindow(0, 100, 200, 320, 280, "Calc", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  ; fonts
  LoadFont(0, "Tahoma", 14)
  LoadFont(1, "Tahoma", 32)
  SetGadgetFont(#PB_Default, FontID(0))

  ; gui
  TextGadget(0, 11, 14, 298, 58, "0 ", #PB_Text_Right | #PB_Text_Border)
  SetGadgetFont(0, FontID(1))

  ; button size
  btn_w.i = 72
  btn_h.i = 45

  ButtonGadget(1, 10,  82, btn_w, btn_h, "7")
  ButtonGadget(2, 86,  82, btn_w, btn_h, "8")
  ButtonGadget(3, 162, 82, btn_w, btn_h, "9")
  ButtonGadget(11, 238, 82, btn_w, btn_h, "÷")

  ButtonGadget(4, 10,  130, btn_w, btn_h, "4")
  ButtonGadget(5, 86,  130, btn_w, btn_h, "5")
  ButtonGadget(6, 162, 130, btn_w, btn_h, "6")
  ButtonGadget(12, 238, 130, btn_w, btn_h, "*")

  ButtonGadget(7,  10,  178, btn_w, btn_h, "1")
  ButtonGadget(8,  86,  178, btn_w, btn_h, "2")
  ButtonGadget(9,  162, 178, btn_w, btn_h, "3")
  ButtonGadget(13, 238, 178, btn_w, btn_h, "–")

  ButtonGadget(10, 10,  226, btn_w, btn_h, "0")
  ButtonGadget(14, 86,  226, btn_w, btn_h, ".")
  ButtonGadget(15, 162, 226, btn_w, btn_h, "=")
  ButtonGadget(16, 238, 226, btn_w, btn_h, "+")

  ; bind a callback
  For g = 1 To 10
    BindGadgetEvent(g, @NumberButtonHandler())
  Next

  For g = 11 To 16
    BindGadgetEvent(g, @CommandButtonHandler())
  Next

  ; event loop
  Repeat
    Event = WaitWindowEvent()

    If Event = #PB_Event_CloseWindow
      Quit = 1
    EndIf

  Until Quit = 1

EndIf

End

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP
; Executable = ..\Calc.exe