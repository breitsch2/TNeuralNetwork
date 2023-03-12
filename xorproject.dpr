program xorproject;

uses
  Vcl.Forms,
  xorsampleu in 'xorsampleu.pas' {xorsample};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Txorsample, xorsample);
  Application.Run;
end.
