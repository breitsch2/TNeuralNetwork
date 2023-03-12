unit NeuralNetwork;
interface
//First Developed in 1999 B. Gültekin Çetiner
//Slight changes made in 2023 B. Gültekin Çetiner

Uses
Windows,SysUtils,Types, Classes,Vcl.StdCtrls,Vcl.Graphics,Vcl.Controls,Vcl.ExtCtrls,vcl.Dialogs,
  ShellAPI,
  Messages,
  IniFiles;

Type

NWFH=record
                       CR:string[84];
                       KTMNSYS:byte;
                       KTMNLR:string[19];
                       OO:double;
                       MO:double;
                       NTR:Longint;
                       TRDT:TDateTime;
                  end;
NWWT=record
                    Value:Double;
               end;


  TNeuralNetwork = class(TImage)
  private
    { Private declarations }
    FNetHeader:NWFH;
    FWeightsinFile:NWWT;
    FClsblr:Boolean;
    FNumberOfTraining:Longint;
    FLearningRate : double;
    FMomentumRate : double;
    FRMSError : double;
    FNetwork : TStringList;
    ro : array of array of double;
    RoBias:array of array of double;
    BiasChange:array of array of double;
    MinimumInputs : array of double;
    MaximumInputs : array of double;
    MinimumOutputs : array of double;
    MaximumOutputs : array of double;
    Desired : array of double;
    Difference : array of double;
    Neurons : array of array of double;
    FWeights : array of array of array of double;
    WeightChange : array of array of array of double;
    Biases : array of array of double;
    FInputNumber:integer;
    FOutputNumber:integer;
    FLayersNumber:integer;
    FInitialized:boolean;
    FErrorCodes:integer;
    FNeuronWidth:integer;
    Procedure RefreshNetworkImage;
    Procedure Dimensionalize;
    procedure SetNeuronsinLayers(value:tstringlist);
    Procedure ForwardProcessing;
    function ScaledValue(Value,Min,Max:double):double;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor create (AOWner : TComponent); override;
    destructor destroy; override;
    Procedure Train;
    Procedure SetInputs(const Inputs : array of double);
    Procedure SetExpectedOutputs(const Outputs: array of double);
    Procedure GetOutputs(Var Outputs: array of double);
    Procedure Initialize(Randomized:Boolean);
    Procedure GetOutputsFromInputs(const Inputs : array of double; var Outputs : array of double);
    Procedure Recall;
    Procedure SetInputMinimums(const InputMinimums : array of double);
    Procedure SetInputMaximums(const InputMaximums : array of double);
    Procedure SetOutputMinimums(const OutputMinimums : array of double);
    Procedure SetOutputMaximums(const OutputMaximums : array of double);
    Procedure SetAllOutputRange(Minimum,Maximum:double);
    Procedure SetAllInputRange(Minimum,Maximum:double);
    Procedure DrawNetwork;
    Function LoadNetwork(FileName:string):Boolean;
    Function SaveNetwork(FileName:string):Boolean;
  published
    { Published declarations }
    property LearningRate : double read FLearningRate write FLearningRate;
    property MomentumRate : double read FMomentumRate write FMomentumRate;
    property Network:TStringList read FNetwork write SetNeuronsinLayers;
    property NumberOfInputs:integer read FInputNumber;
    property NumberOfOutputs:integer read FOutputNumber;
    property NumberOfLayers:integer read FLayersNumber;
    property Initialized:boolean read FInitialized;
    property RMSError:double read FRMSError;
    property NeuronWidth:integer read FNeuronWidth write FNeuronWidth;
    property NumberOfTraining:longint read FNumberOfTraining;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional', [TNeuralNetwork]);
end;

{ TNeuralNetwork }

procedure TNeuralNetwork.SetNeuronsinLayers(Value: TStringList);
begin
  FNetwork.Assign(Value);
end;
{
procedure TNeuralNetwork.SetLogs(Value: TStringList);
begin
  Flogs.Assign(Value);
end;
}

function TNeuralNetwork.ScaledValue(Value,Min,Max:double):double;
begin
     if (Max-Min)=0 then
     begin
        Result:=Value;
     end
     else Result:=(Value-min)/(Max-Min);
end;

procedure TNeuralNetwork.Dimensionalize;
var
  i, j : integer;
begin        {***** SET MATRIX SIZES *****}
Try
  //FNumberOfTraining:=0;
  
  FLayersNumber:=FNetwork.Count;
  FInputNumber:=StrToInt(FNetwork[0]);
  FOutputNumber:=StrToInt(FNetwork[FLayersNumber-1]);
  FInitialized:=true;

  SetLength(Neurons,FNetwork.Count);
  SetLength(ro,FNetwork.Count);
  for i:=0 to High(Neurons) do
  begin
    SetLength(Neurons[i],StrToInt(FNetwork.Strings[i]));
    SetLength(ro[i],StrToInt(FNetwork.Strings[i]));
  end;

  SetLength(Biases,FNetwork.Count-1);
  SetLength(BiasChange,FNetwork.Count-1);
  for i:=0 to High(Biases) do
  begin
    SetLength(Biases[i],StrToInt(FNetwork.Strings[i+1]));
    SetLength(BiasChange[i],StrToInt(FNetwork.Strings[i+1]));
  end;

  SetLength(FWeights,FNetwork.Count-1);
  SetLength(WeightChange,FNetwork.Count-1);
  for i:=0 to High(FWeights) do
  begin
    SetLength(FWeights[i],StrToInt(FNetwork.Strings[i]));
    SetLength(WeightChange[i],StrToInt(FNetwork.Strings[i]));
    for j:=0 to High(FWeights[i]) do
    begin
      SetLength(FWeights[i,j],StrToInt(FNetwork.Strings[i+1]));
      SetLength(WeightChange[i,j],StrToInt(FNetwork.Strings[i+1]));
    end;
  end;
  SetLength(Desired,StrToInt(FNetwork.Strings[fnetwork.Count-1]));
  SetLength(Difference,StrToInt(FNetwork.Strings[fnetwork.Count-1]));

  SetLength(MinimumInputs,StrToInt(FNetwork.Strings[0]));
  SetLength(MaximumInputs,StrToInt(FNetwork.Strings[0]));

  SetLength(MinimumOutputs,StrToInt(FNetwork.Strings[fnetwork.Count-1]));
  SetLength(MaximumOutputs,StrToInt(FNetwork.Strings[fnetwork.Count-1]));
Except on EStringListError do raise Exception.Create('Error in Network Structure');
end; //Except

end;

constructor TNeuralNetwork.create(AOWner: TComponent);
begin
  inherited create(AOwner);

  FClsblr:=true;
 
  FNetwork:=TStringList.Create;
  FInitialized:=false;
  FLearningRate :=0.9;
  FMomentumRate :=0.39;
  Width := 120;
  Height :=120;
  NeuronWidth:=5;
  FRMSError:=1;
  FNumberOfTraining:=0;
end;

destructor TNeuralNetwork.destroy;
begin
  FNetwork.Free;
  inherited;
end;

procedure TNeuralNetwork.Train;
var
  i, j, k : integer; TotalRo,TotalRoBias : double;
begin
  Recall;
  FNumberOfTraining:=FNumberOfTraining+1;
  FRMSError:=0;
  for i:=0 to high(Desired) do
  begin
    Difference[i]:=Desired[i]-Neurons[high(Neurons),i];
    FRMSError:=FRMSError+sqr(Difference[i]);
  end;
  FRMSError:=FRMSError/2;
  {***** ro for output *****}
  i:=high(Neurons);
  for j:=0 to high(Difference) do
  begin
    ro[i,j]:=(1-Neurons[i,j])*Neurons[i,j]*Difference[j];
  end;

  {***** ro for other layers *****}
  for i:=high(Neurons)-1 downto 1 do
    for j:=0 to high(Neurons[i]) do
    begin
      TotalRo := 0;
      for k:=0 to high(Neurons[i+1]) do
      begin
        TotalRo:=TotalRo+ro[i+1,k]*FWeights[i,j,k];

      end;
      ro[i,j]:=(1-Neurons[i,j])*Neurons[i,j]*TotalRo;
    end;
  {***** change for output weight *****}
  for i:=high(Neurons)-1 downto 0 do
    for j:=0 to high(Neurons[i]) do
      for k:=0 to high(Neurons[i+1]) do
      begin
        WeightChange[i,j,k]:=FLearningRate*ro[i+1,k]*Neurons[i,j]+FMomentumRate*WeightChange[i,j,k];
        FWeights[i,j,k]:=FWeights[i,j,k]+WeightChange[i,j,k];
      end;
end;

procedure TNeuralNetwork.ForwardProcessing;
var
  i,j,k:integer;
  NetWeight : double;
begin
  for i:=1 to high(Neurons) do
    for j:=0 to high(Neurons[i]) do
    begin
      NetWeight := 0;
      for k:=0 to high(Neurons[i-1]) do
      begin
        NetWeight := NetWeight + Neurons[i-1,k] * FWeights[i-1,k,j];
      end;

      Neurons[i,j]:=1/(1+exp(-NetWeight-Biases[i-1,j]));
    end;

    {
for i:=0 to High(FWeights) do
  for j:=0 to High(FWeights[i]) do
      for k:=0 to High(FWeights[i,j]) do
           Flogs.Add('New FWeights['+IntTostr(i)+','+IntTostr(j)+','+ IntTostr(k)+')='+FloatTostr(FWeights[i,j,k]));

  for i:=0 to High(Biases) do
    for j:=0 to High(Biases[i]) do
      Flogs.Add('New Bias('+IntTostr(i)+','+IntTostr(j)+')='+FloatTostr(Biases[i,j]));
     }
end;

Procedure TNeuralNetwork.Recall;
Begin
     ForwardProcessing;
end;

procedure TNeuralNetwork.Initialize(Randomized:Boolean);
var
  i,j,k:integer;
begin
  FNumberOfTraining:=0;
  Dimensionalize;
  if Randomized then Randomize;
  {***** Giving random values to FWeights and biases *****}
  for i:=0 to High(FWeights) do
    for j:=0 to High(FWeights[i]) do
      for k:=0 to High(FWeights[i,j]) do
        begin
           FWeights[i,j,k]:=random(4);
        end;
  for i:=0 to High(Biases) do
    for j:=0 to High(Biases[i]) do
    begin
      Biases[i,j]:=random(4);
    end;
end;

Function TNeuralNetwork.LoadNetwork(FileName:string):Boolean;
Var
   Successfull:boolean;   F:TextFile;
   i,j,k:integer;         FirstLine:string;
   NwCount,Katman:integer;      Res1,Res2:integer;
   Dosya1:File of NWFH;
   Dosya2:File of NWWT;
   ExtKonum:integer;
begin
if not FClsblr then
begin
     LoadNetwork:= false;
     ShowMessage('You can load network if you are registered')
end else
begin
  Try
   Successfull:=true;
   FileName:=AnsiUpperCase(FileName); AssignFile(Dosya1,FileName);
   ExtKonum:=pos('.NET',FileName); delete(FileName,ExtKonum,4);
   AssignFile(Dosya2,FileName+'.dat');
   {$I-} Reset(Dosya1); {$I+} Res1:=IOResult;
   {$I-} Reset(Dosya2); {$I+} Res2:=IOResult;
   if Res1<>0 then
   begin
         Successfull:=false;
         raise exception.Create('Error in opening Network Definition file');
   end
   else if Res2<>0 then
   begin
         Successfull:=false;
         raise exception.Create('Error in opening Network data file');
   end
   else
   begin
        FNetwork.Clear;
        // File Format

        Read(Dosya1,FNetHeader); //Read(Dosya1,FirstLine);
        FLayersNumber:=FNetHeader.KTMNSYS;
        FLearningRate:=FNetHeader.OO;
        FMomentumRate:=FNetHeader.MO;
        FNumberOfTraining:=FNetHeader.NTR;
	NwCount:=FNetHeader.KTMNSYS;
        for i:=0 to NwCount-1 do
        begin
            Katman:=Ord(FNetHeader.KTMNLR[i+1]);
            FNetwork.Add(IntToStr(Katman));
        end;
        FNetwork:=FNetwork;
        closefile(Dosya1);
        Dimensionalize;

        for i:=0 to High(FWeights) do
           for j:=0 to High(FWeights[i]) do
              for k:=0 to High(FWeights[i,j]) do
              begin
                   Read(Dosya2,FWeightsinFile);
                   FWeights[i,j,k]:=FWeightsinFile.Value;
              end;

        for i:=0 to High(Biases) do
           for j:=0 to High(Biases[i]) do
           begin
                Read(Dosya2,FWeightsinFile);
		Biases[i,j]:=FWeightsinFile.Value;
           end;

        for i:=0 to High(Neurons[0]) do //All inputs range
        begin
	    Read(dosya2,FWeightsinFile);
            MinimumInputs[i]:=FWeightsinFile.Value;
	    Read(dosya2,FWeightsinFile);
            MaximumInputs[i]:=FWeightsinFile.Value;
        end;
        for i:=0 to High(Desired) do
        begin
	    Read(dosya2,FWeightsinFile);
	    MinimumOutputs[i]:=FWeightsinFile.Value;
	    Read(dosya2,FWeightsinFile);
	    MaximumOutputs[i]:=FWeightsinFile.Value;
        end;
        closefile(Dosya2);
   end;
   LoadNetwork:= Successfull;
except
  on E: Exception do
         begin
            if not ((Res1<>0) or (Res2<>0)) then
               raise Exception.Create('Unrecognized File');
         end;
  end;
end;
end;

Function TNeuralNetwork.SaveNetwork(FileName:string):Boolean;
Var
   Successfull:boolean;
   F:TextFile;
   i,j,k:integer;
   Dosya1:File of NWFH;
   Dosya2:File of NWWT;
   ExtKonum:integer;
begin
if not FClsblr then
begin
     SaveNetwork:= false;
     ShowMessage('You can save network if you are registered')
end
else
begin
Successfull:=true;
   FileName:=AnsiUpperCase(FileName); AssignFile(Dosya1,FileName);
   ExtKonum:=pos('.NET',FileName); delete(FileName,ExtKonum,4);
   AssignFile(Dosya2,FileName+'.dat');
   {$I-}
   Rewrite(Dosya1); Rewrite(Dosya2);
   {$I+}
   if IOResult<>0 then Successfull:=false
   else
   begin
        // File Saving Format
        FNetHeader.KTMNSYS:=FNetwork.Count;
        FNetHeader.OO:=FLearningRate;
        FNetHeader.MO:=FMomentumRate;
        FNetHeader.NTR:=FNumberOfTraining;
        FNetHeader.TRDT:=Now;
        FNetHeader.KTMNLR:='';
        for i:=0 to FNetwork.Count-1 do
                   FNetHeader.KTMNLR:=FNetHeader.KTMNLR+Chr(StrToInt(FNetwork[i]));

        Write(Dosya1,FNetHeader); closefile(Dosya1);


        for i:=0 to High(FWeights) do
           for j:=0 to High(FWeights[i]) do
              for k:=0 to High(FWeights[i,j]) do
              begin
                         FWeightsinFile.Value:=FWeights[i,j,k];
                         Write(Dosya2,FWeightsinFile);
              end;

        for i:=0 to High(Biases) do
           for j:=0 to High(Biases[i]) do
           begin
               FWeightsinFile.Value:=Biases[i,j];
               Write(Dosya2,FWeightsinFile);
           end;

        for i:=0 to High(Neurons[0]) do //All inputs range
        begin
            FWeightsinFile.Value:=MinimumInputs[i];
            Write(Dosya2,FWeightsinFile);
            FWeightsinFile.Value:=MaximumInputs[i];
            Write(Dosya2,FWeightsinFile);
        end;
        for i:=0 to High(Desired) do
        begin
             FWeightsinFile.Value:=MinimumOutputs[i];
             Write(Dosya2,FWeightsinFile);
             FWeightsinFile.Value:=MaximumOutputs[i];
             Write(Dosya2,FWeightsinFile);
        end;
        closefile(Dosya2);
   end;
   SaveNetwork:= Successfull;
end;
end;

Procedure TNeuralNetwork.RefreshNetworkImage;
Var
   i,j,k:integer;
   Sol,Sag,Ust,Alt,GridX,GridY:integer;
   HucreSayisi:integer;
   str1:string;
   X1,X2,Y1,Y2:integer;
   KoordX,KoordY:array of array of integer;
   Altmi:boolean;

Begin
    if not FInitialized then
    begin
        raise Exception.Create('First, you have to Initialize the Network');
        exit;
    end;

    Sol:=ClientRect.Left; Sag:=ClientRect.Right;
    Ust:=ClientRect.Top; Alt:=ClientRect.Bottom;
    Canvas.pen.Color:=clBlack;
    Canvas.Rectangle(Sol,Ust,Sag,Alt);

    GridY:=Trunc((Alt-Ust)/Network.Count);
    SetLength(KoordX,Network.Count); SetLength(KoordY,Network.Count);

    for i:=1 to Network.Count do
    begin
        HucreSayisi:=StrToInt(Network[i-1]);
        GridX:=Trunc((Sag-Sol)/HucreSayisi);
        SetLength(KoordX[i-1],HucreSayisi); SetLength(KoordY[i-1],HucreSayisi);
        for j:=0 to StrToInt(Network[i-1])-1 do
        begin
             X1:=GridX div 2+GridX*(j)-FNeuronWidth; Y1:=GridY*i-FNeuronWidth-GridY div 2;
             X2:=GridX div 2+GridX*(j)+FNeuronWidth; Y2:=GridY*i+FNeuronWidth-GridY div 2;
             KoordX[i-1,j]:=X1+(X2-X1) div 2;
             KoordY[i-1,j]:=Y1+(Y2-Y1) div 2;
        end;
    end;

    for i:=0 to Network.Count-2 do
      for j:=0 to StrToInt(Network[i])-1 do
           for k:=0 to StrToInt(Network[i+1])-1 do
           begin
               Canvas.pen.Color:= clSilver; //RGB(random(255),random(255),random(255));
               Canvas.pen.Width:=1;
               Canvas.MoveTo(KoordX[i,j],KoordY[i,j]);
               Canvas.LineTo(KoordX[i+1,k],KoordY[i+1,k]);
           end;
    for i:=1 to Network.Count do
        for j:=0 to StrToInt(Network[i-1])-1 do
        begin
           Canvas.brush.Color:=clNavy; //RGB(random(255),random(255),random(255));
           Canvas.ellipse(KoordX[i-1,j]-FNeuronWidth,KoordY[i-1,j]-FNeuronWidth,KoordX[i-1,j]+FNeuronWidth,KoordY[i-1,j]+FNeuronWidth);
        end;

   for i:=0 to StrToInt(Network[0])-1 do
   begin
        Canvas.pen.Color:=clBlack;
        Canvas.pen.Width:=1;
        Canvas.MoveTo(KoordX[0,i],KoordY[0,i]-FNeuronWidth*3);
        Canvas.LineTo(KoordX[0,i],KoordY[0,i]-FNeuronWidth);
        Canvas.moveTo(KoordX[0,i],KoordY[0,i]-FNeuronWidth); // ok sað ucu
        Canvas.LineTo(KoordX[0,i]+FNeuronWidth,KoordY[0,i]-FNeuronWidth*2);
        Canvas.moveTo(KoordX[0,i],KoordY[0,i]-FNeuronWidth); // ok sol ucu
        Canvas.LineTo(KoordX[0,i]-FNeuronWidth,KoordY[0,i]-FNeuronWidth*2);
   end;
                  j:=Network.count-1;

   for i:=0 to StrToInt(Network[Network.count-1])-1 do
   begin
        Canvas.pen.Color:=clBlack;
        Canvas.pen.Width:=1;
        Canvas.MoveTo(KoordX[j,i],KoordY[j,i]-FNeuronWidth*3+FNeuronWidth*3);
        Canvas.LineTo(KoordX[j,i],KoordY[j,i]-FNeuronWidth+FNeuronWidth*3);
        Canvas.moveTo(KoordX[j,i],KoordY[j,i]-FNeuronWidth+FNeuronWidth*3); // ok sað ucu
        Canvas.LineTo(KoordX[j,i]+FNeuronWidth,KoordY[j,i]-FNeuronWidth*2+FNeuronWidth*3);
        Canvas.moveTo(KoordX[j,i],KoordY[j,i]-FNeuronWidth+FNeuronWidth*3); // ok sol ucu
        Canvas.LineTo(KoordX[j,i]-FNeuronWidth,KoordY[j,i]-FNeuronWidth*2+FNeuronWidth*3);
   end;
End;

Procedure TNeuralNetwork.DrawNetwork;
Var
   i:integer;
Begin
     Canvas.Brush.Color:=clWhite; //RGB(58,110,165);
     Canvas.Brush.Style:=bsSolid;
     Canvas.FillRect(ClientRect);
     RefreshNetworkImage;
End;

Procedure TNeuralNetwork.SetInputMinimums(const InputMinimums : array of double);
var
  i : integer;
Begin
  for i:=0 to High(Neurons[0]) do
           MinimumInputs[i]:=InputMinimums[i];
end;

Procedure TNeuralNetwork.SetAllInputRange(Minimum,Maximum:double);
var
  i:integer;
begin
  for i:=0 to High(Neurons[0]) do
  begin
        MinimumInputs[i]:=Minimum;
        MaximumInputs[i]:=Maximum;
  end;
end;

Procedure TNeuralNetwork.SetAllOutputRange(Minimum,Maximum:double);
var
  i : integer;
Begin
  for i:=0 to High(Desired) do
  begin
      MinimumOutputs[i]:=Minimum;
      MaximumOutputs[i]:=Maximum;
  end;
end;

Procedure TNeuralNetwork.SetOutputMaximums(const OutputMaximums : array of double);
var
  i : integer;
Begin
  for i:=0 to High(Desired) do
        MaximumOutputs[i]:=OutputMaximums[i];
end;

Procedure TNeuralNetwork.SetOutputMinimums(const OutputMinimums : array of double);
var
  i : integer;
Begin
    for i:=0 to High(Desired) do
          MinimumOutputs[i]:=OutputMinimums[i];
end;

Procedure TNeuralNetwork.SetInputMaximums(const InputMaximums : array of double);
var
  i : integer;
Begin
    for i:=0 to High(Neurons[0]) do
          MaximumInputs[i]:=InputMaximums[i];
end;

procedure TNeuralNetwork.SetExpectedOutputs(const Outputs: array of double);
var
  i:integer; OKIDOK:boolean;
begin
  OKIDOK:=false;
  for i:=0 to High(Desired) do
     if MinimumOutputs[i]<>MaximumOutputs[i] then OKIDOK:=true;
  if OKIDOK then
   for i:=0 to High(Desired) do
    Desired[i]:=ScaledValue(Outputs[i],MinimumOutputs[i],MaximumOutputs[i])
  else for i:=0 to High(Desired) do
    Desired[i]:=Outputs[i];
end;

procedure TNeuralNetwork.SetInputs(const Inputs: array of double);
var
  i : integer; OKIDOK:boolean;
begin
  OKIDOK:=false;
  for i:=0 to High(Neurons[0]) do
      if (MinimumInputs[i]<>MaximumOutputs[i]) then OKIDOK:=true;
  if OKIDOK then
    for i:=0 to High(Neurons[0]) do
       Neurons[0,i]:=ScaledValue(Inputs[i],MinimumInputs[i],MaximumInputs[i])
    else for i:=0 to High(Neurons[0]) do
        Neurons[0,i]:=Inputs[i]
end;

procedure TNeuralNetwork.GetOutputs(Var Outputs: array of double);
Var
   i:integer;
begin
  for i:=0 to FOutputNumber-1 do
        Outputs[i]:=Neurons[high(Neurons),i];

  for i:=0 to FOutputNumber-1 do
        Outputs[i]:=Outputs[i]*(MaximumOutputs[i]-MinimumOutputs[i])+MinimumOutputs[i];
end;

procedure TNeuralNetwork.GetOutputsFromInputs(const Inputs:array of double; var Outputs:array of double);
var
  i:integer;
begin
  SetInputs(Inputs);
  ForwardProcessing;

    for i:=0 to FOutputNumber-1 do
        Outputs[i]:=Neurons[high(Neurons),i];
end;

end.
