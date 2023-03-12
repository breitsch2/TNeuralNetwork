object XORSample: TXORSample
  Left = 198
  Top = 104
  Caption = 'XORSample'
  ClientHeight = 466
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 533
    Top = 64
    Width = 58
    Height = 20
    Caption = 'Input 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 533
    Top = 88
    Width = 58
    Height = 20
    Caption = 'Input 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object nn1: TNeuralNetwork
    Left = 251
    Top = 56
    Width = 174
    Height = 201
    LearningRate = 0.900000000000000000
    MomentumRate = 0.390000000000000000
    Network.Strings = (
      '2'
      '3'
      '2'
      '1')
    NeuronWidth = 30
  end
  object RMSImage: TImage
    Left = 253
    Top = 258
    Width = 478
    Height = 188
  end
  object Label3: TLabel
    Left = 295
    Top = 1
    Width = 99
    Height = 20
    Caption = 'Neuron Size'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 485
    Top = 234
    Width = 90
    Height = 20
    Caption = 'RMS Error:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 485
    Top = 212
    Width = 158
    Height = 20
    Caption = 'Number of Training:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 440
    Top = 136
    Width = 312
    Height = 40
    Caption = 
      'Inputs and Outputs Use '#39'5'#39's as minimum, and '#39'10'#39's as maximum val' +
      'ues'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object LearnBtn: TBitBtn
    Left = 251
    Top = 24
    Width = 100
    Height = 25
    Caption = 'Learn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = LearnBtnClick
  end
  object Input1: TEdit
    Left = 594
    Top = 64
    Width = 66
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = '0'
  end
  object Input2: TEdit
    Left = 594
    Top = 88
    Width = 66
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Text = '0'
  end
  object Output1: TEdit
    Left = 595
    Top = 112
    Width = 65
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object RMSedit: TEdit
    Left = 575
    Top = 234
    Width = 155
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = 'not available yet'
  end
  object SpinEdit1: TSpinEdit
    Left = 395
    Top = 0
    Width = 57
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MaxValue = 15
    MinValue = 1
    ParentFont = False
    TabOrder = 5
    Value = 3
    OnChange = SpinEdit1Change
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 466
    Align = alLeft
    TabOrder = 6
    object MessageBox: TMemo
      Left = 1
      Top = 41
      Width = 247
      Height = 424
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 247
      Height = 40
      Align = alTop
      TabOrder = 1
      object Label4: TLabel
        Left = 75
        Top = 9
        Width = 82
        Height = 20
        Caption = 'Messages'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10485760
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object DrawNetBtn: TBitBtn
    Left = 663
    Top = 0
    Width = 100
    Height = 25
    Caption = 'Draw Network'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = DrawNetBtnClick
  end
  object CalculateBtn: TBitBtn
    Left = 457
    Top = 112
    Width = 137
    Height = 25
    Caption = 'Calculate Output'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = CalculateBtnClick
  end
  object SaveNetBtn: TBitBtn
    Left = 558
    Top = 0
    Width = 105
    Height = 25
    Caption = 'Save Network'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = SaveNetBtnClick
  end
  object LoadNetBtn: TBitBtn
    Left = 453
    Top = 0
    Width = 105
    Height = 25
    Caption = 'Load Network'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = LoadNetBtnClick
  end
  object Button1: TButton
    Left = 668
    Top = 64
    Width = 94
    Height = 72
    Caption = 'Close Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = Button1Click
  end
  object StopLearnBtn: TBitBtn
    Left = 349
    Top = 24
    Width = 104
    Height = 25
    Caption = 'Stop Learning'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = StopLearnBtnClick
  end
  object TrainTimesEdt: TEdit
    Left = 648
    Top = 212
    Width = 82
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 13
    Text = 'not available yet'
  end
  object SaveNetBmpBtn: TBitBtn
    Left = 452
    Top = 24
    Width = 311
    Height = 25
    Caption = 'Save Network Image as Bitmap'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = SaveNetBmpBtnClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Network Files|*.Net'
    Left = 432
    Top = 64
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'net'
    Filter = 'Network Files|*.Net'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 464
    Top = 64
  end
end
