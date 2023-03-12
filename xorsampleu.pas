unit xorsampleu;

interface

uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
StdCtrls, Buttons, NeuralNetwork, ExtCtrls, Spin;
type
TXORSample = class(TForm)
LearnBtn: TBitBtn;
Input1: TEdit;
Input2: TEdit;
Output1: TEdit;
nn1: TNeuralNetwork;
RMSedit: TEdit;
RMSImage: TImage;
SpinEdit1: TSpinEdit;
Panel1: TPanel;
MessageBox: TMemo;
Panel2: TPanel;
Label1: TLabel;
Label2: TLabel;
Label3: TLabel;
Label4: TLabel;
Label5: TLabel;
Label6: TLabel;
Label7: TLabel;
DrawNetBtn: TBitBtn;
CalculateBtn: TBitBtn;
SaveNetBtn: TBitBtn;
LoadNetBtn: TBitBtn;
Button1: TButton;
StopLearnBtn: TBitBtn;
OpenDialog1: TOpenDialog;
SaveDialog1: TSaveDialog;
TrainTimesEdt: TEdit;
SaveNetBmpBtn: TBitBtn;
procedure LearnBtnClick(Sender: TObject);
procedure SpinEdit1Change(Sender: TObject);
procedure DrawNetBtnClick(Sender: TObject);
procedure CalculateBtnClick(Sender: TObject);
procedure SaveNetBtnClick(Sender: TObject);
procedure LoadNetBtnClick(Sender: TObject);
procedure Button1Click(Sender: TObject);
procedure StopLearnBtnClick(Sender: TObject);
procedure FormCreate(Sender: TObject);
procedure SaveNetBmpBtnClick(Sender: TObject);
private
{ Private declarations }
public
{ Public declarations }
end;

var
XORSample: TXORSample;
Continue:boolean;
implementation

{$R *.DFM}

procedure TXORSample.LearnBtnClick(Sender: TObject);
var
mininputs:array [0..1] of double;
maxinputs:array [0..1] of double;
minoutputs:array [0..0] of double;
maxoutputs:array [0..0] of double;

input:array[0..1] of double;
Output,Desired:array[0..0] of double;
i,j,k:integer;
a,b:byte;
begin
LearnBtn.Enabled:=false;
StopLearnBtn.Enabled:=true;

if not nn1.Initialized then nn1.Initialize(true);

mininputs[0]:=5; mininputs[1]:=5; maxinputs[0]:=10; maxinputs[1]:=10;
nn1.SetInputMinimums(mininputs); nn1.SetInputMaximums(maxinputs);

{ easier way for setting minimum and maximum input values
NN1.SetAllInputRange(0,1);}

//minoutputs[0]:=0; maxoutputs[0]:=1;
//nn1.SetOutputMinimums(minoutputs); nn1.SetOutputMaximums(maxoutputs);
// easier way for setting minimum and maximum output values
nn1.SetAllOutputRange(5,10);

j:=1;
MessageBox.Lines.Add('Started at '+datetimetostr(now));

Continue:=true;
while (nn1.RMSError*5000>1) or Continue do
begin
if not Continue then exit;

RMSImage.Canvas.Brush.Color:=RGB(58,110,165);
RMSImage.Canvas.Brush.Style:=bsSolid;
RMSImage.Canvas.FillRect(ClientRect);
RMSImage.Canvas.pen.Color:=clRed;
RMSImage.Canvas.TextRect(RMSImage.ClientRect,RMSImage.ClientWidth div
3,RMSImage.ClientHeight-12,'Iteration');
RMSImage.Canvas.TextOut(5,0,'RMS Error');
RMSImage.Canvas.MoveTo(10,10);
RMSImage.Canvas.lineTo(10,RMSImage.ClientHeight-10);
RMSImage.Canvas.MoveTo(10,RMSImage.ClientHeight-10);
RMSImage.Canvas.lineTo(RMSImage.ClientWidth-10,RMSImage.ClientHeight-10);
RMSImage.Canvas.MoveTo(10,RMSImage.ClientHeight-10);

for i:=1 to RMSImage.ClientWidth-20 do
begin
RMSEdit.text:=Format('%20.15f',[nn1.RMSError]);
TrainTimesEdt.Text:=IntToStr(nn1.NumberOfTraining);
RMSImage.Canvas.pen.Color:=clWhite;
RMSImage.Canvas.lineto(i+10,RMSImage.ClientHeight-10-
round(nn1.rmserror*100));
Case j of
1: begin
input[0]:=5; input[1]:=5;
Desired[0]:=5;
end;
2: begin
input[0]:=10; input[1]:=10;
Desired[0]:=5;
end;
3: begin
input[0]:=10; input[1]:=5;
Desired[0]:=10;
end;
4: begin
input[0]:=5; input[1]:=10;
Desired[0]:=10;
end;
end; //Case

if j<=4 then j:=j+1 else j:=1;

application.ProcessMessages;

nn1.SetInputs(input);
nn1.SetExpectedOutputs(Desired);
nn1.Train;
nn1.GetOutputs(Output);
end;
end; //while
MessageBox.Lines.Add('Finished at '+datetimetostr(now));
end;


procedure TXORSample.SpinEdit1Change(Sender: TObject);
begin
nn1.NeuronWidth:=SpinEdit1.Value
end;

procedure TXORSample.DrawNetBtnClick(Sender: TObject);
begin
nn1.DrawNetwork;
end;

procedure TXORSample.CalculateBtnClick(Sender: TObject);
var
input:array[0..1] of double;
Output:array[0..0] of double;
begin
input[0]:=StrToFloat(Input1.text);
input[1]:=StrToFloat(Input2.text);

if nn1.Initialized then
begin
nn1.SetInputs(input);
nn1.Recall;
nn1.GetOutputs(Output);
Output1.Text:=FloatToStr(Output[0]);
end
else showmessage('Network is not initialized.')
end;

procedure TXORSample.SaveNetBtnClick(Sender: TObject);
begin
if SaveDialog1.Execute then
if nn1.SaveNetwork(SaveDialog1.FileName) then
showmessage('Saved Successfully');
end;

procedure TXORSample.LoadNetBtnClick(Sender: TObject);
begin
if OpenDialog1.Execute then
if nn1.LoadNetwork(OpenDialog1.FileName) then
showmessage(' Loaded Successfully');
end;

procedure TXORSample.Button1Click(Sender: TObject);
begin
close
end;

procedure TXORSample.StopLearnBtnClick(Sender: TObject);
begin
StopLearnBtn.Enabled:=false;
LearnBtn.Enabled:=true;
Continue:=false;
end;

procedure TXORSample.FormCreate(Sender: TObject);
begin
StopLearnBtn.Enabled:=false;
end;

procedure TXORSample.SaveNetBmpBtnClick(Sender: TObject);
begin
nn1.DrawNetwork;
nn1.Picture.SaveToFile('c:\delphi\network.bmp');
end;

end.


