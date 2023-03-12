program xorprojectconsole;

{$APPTYPE CONSOLE}

uses
  NeuralNetwork,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

Var

i,j:integer;

NN1:TNeuralNetwork;

Inputs,Outputs:array of double;

begin

  NN1:=TNeuralNetwork.create(Application); //Create component run time
  SetLength(Inputs,2); SetLength(Outputs,1); //Set array for inputs and outputs
  NN1.Network.Clear; // Clear network structure
  NN1.Network.Add('2'); // Number of inputs
  NN1.Network.Add('3'); // Number of hidden neurons
  NN1.Network.Add('1'); // Number of outputs

  NN1.Initialize(true); // Initialize network

  // Set Minimum and Maximum inputs and outputs

  NN1.SetAllInputRange(0,1); NN1.SetAllOutputRange(0,1);

  for i:=1 to 150000 do //train network for 150000 iterations
  begin
    Inputs[0]:=random(2); Inputs[1]:=random(2); //Specify inputs
    NN1.SetInputs(Inputs); //Set inputs specified above
    Outputs[0]:=Round(Inputs[0]) xor round(Inputs[1]);
    NN1.SetExpectedOutputs(Outputs); //Set expected outputs
    NN1.Train; //Train
  end;

  //Write RMS Error for network

  writeln('RMS ERROR:'+Format('%20.15f',[nn1.RMSError]));

  // Querying network
  for i:=0 to 1 do
    for j:=0 to 1 do
    begin
      Inputs[0]:=i; Inputs[1]:=j; //Specify inputs
      NN1.GetOutputsFromInputs(inputs,Outputs); //Obtain outputs from network
      writeln('i:'+IntToStr(i)+' j:'+IntToStr(j)+Format('%20.15f',[Outputs[0]]));
    end;

  NN1.SaveNetwork('xortrial.net'); //Save Network

  NN1.free; //Free Network component
readln;

end.


