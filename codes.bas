Attribute VB_Name = "codes"
Sub stockdata1()
'declaring the variable
Dim ws As Worksheet
Dim count As Integer
Dim total_volume As Double
Dim last_row As Double
Dim first_row As Long
Dim startcell As Range
Dim col1 As Long
Dim col2 As Long




' loop for accessing all sheets
 For Each ws In Worksheets
    
    ws.Activate
    
 'initialize the starcell as A1
 Set startcell = ws.Range("A1")
   
   ' to name the specific columns of each sheet
   With ws
   
    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Quarterly Change"
    ws.Cells(1, 11).Value = "Percent Change"
    ws.Cells(1, 12).Value = "Total Stock Volume"
    ws.Cells(2, 15).Value = "Greatest % Increase"
    ws.Cells(3, 15).Value = "Greatest % Decrease"
    ws.Cells(4, 15).Value = "Greatest Total volume"
    ws.Cells(1, 16).Value = "Ticker"
     ws.Cells(1, 17).Value = "value"
     ws.Cells(1, 2).Value = "<Date>"
 End With
 
 ' initialize the variables
    table_row = 2
    total_volume = 0
    col1 = 18
    col2 = 17
    first_row = 2
  'the last row of data in the sheet
   last_row = ws.Cells(Rows.count, 1).End(xlUp).Row
   
    
 
  'loop for going throught the data
 
  For i = 2 To last_row
          'calculate the quarterly change
          ws.Range("J" & i + 1).Value = startcell.Offset(i + 1, col2).Value - startcell.Offset(i, col1).Value
          
          'in case the open price is different by zero
          If startcell.Offset(i, col1).Value <> 0 Then
          
          'calculate the percent change
          ws.Range("K" & i + 1).Value = ws.Range("J" & i + 1).Value / startcell.Offset(i, col1).Value
         
        Else
        ' if open price is zero the the system displays zero as value
            ws.Range("K" & i + 1).Value = 0
        End If
         
         'incrementation
         first_row = i + 1
         
         'putting the color according to the condition
         Select Case ws.Range("J" & i + 1).Value
         Case Is > 0 ' green
         ws.Range("J" & i + 1).Interior.Color = vbGreen
         
         Case Is < 0  'red
         ws.Range("J" & i + 1).Interior.Color = RGB(255, 0, 0)
         
         Case Else ' white
          ws.Range("J" & i + 1).Interior.Color = vbWhite
         
          End Select
         
   
             
  'condition in case the ticker name change
     If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
       'finding the ticker name
        volume_Name = ws.Cells(i, 1).Value
        'total volume
        total_volume = total_volume + ws.Cells(i, 7).Value
       
     'display data in excel
     ws.Range("i" & table_row).Value = volume_Name
     ws.Range("l" & table_row).Value = total_volume
     
     'this column helps to calculate each first(open) value after the ticker name change
     ws.Range("s" & table_row + 1).Value = Cells(i + 1, 3).Value
     'this is one display the last(close) value for each ticker name
    ws.Range("r" & table_row + 1).Value = Cells(i, 6).Value
     
     'increment row
     table_row = table_row + 1
     
      'reset the volume
      total_volume = 0
     
     Else
     'add volume
     total_volume = total_volume + ws.Cells(i, 7).Value
     
     
   End If
   
 Next i
 
    ' finding the quaterly change value from first row
    ws.Range("J" & 2).Value = ws.Range("R" & 3).Value - ws.Range("C" & 2).Value
    
    'finding the percent change value from the first row
       ws.Range("K" & 2).Value = ws.Range("J" & 2).Value / ws.Range("C" & 2).Value
       
       'using the colors according to the condition given
          If ws.Range("J" & 2).Value > 0 Then
           ws.Range("J" & 2).Interior.Color = vbGreen
           ElseIf ws.Range("J" & 2).Value < 0 Then
            ws.Range("J" & 2).Interior.Color = RGB(255, 0, 0)
            Else
             ws.Range("J" & 2).Value.Interior.Color = vbWhite
           
           End If
           'hiding the unnecessary colmuns that helped to calculate
            ws.Columns("r").EntireColumn.Hidden = True
             ws.Columns("s").EntireColumn.Hidden = True
             
       ' calclate the max and min
        ws.Range("Q2") = WorksheetFunction.Max(ws.Range("K2:K" & last_row))
        ws.Range("Q3") = WorksheetFunction.Min(ws.Range("K2:K" & last_row))
        ws.Range("Q4") = WorksheetFunction.Max(ws.Range("L2:L" & last_row))

        ' to avoid the first row
        increase_number = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("K2:K" & last_row)), ws.Range("K2:K" & last_row), 0)
        decrease_number = WorksheetFunction.Match(WorksheetFunction.Min(ws.Range("K2:K" & last_row)), ws.Range("K2:K" & last_row), 0)
        volume_number = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("L2:L" & last_row)), ws.Range("L2:L" & last_row), 0)

        ' diplays total, greatest % of increase and decrease
        ws.Range("P2") = ws.Cells(increase_number + 1, 9)
        ws.Range("P3") = ws.Cells(decrease_number + 1, 9)
        ws.Range("P4") = ws.Cells(volume_number + 1, 9)
 Next ws


End Sub



