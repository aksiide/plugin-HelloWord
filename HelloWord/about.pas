unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls;

type

  { TfAbout }

  TfAbout = class(TForm)
    btn_Close: TBitBtn;
    Memo1: TMemo;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fAbout: TfAbout;

implementation

{$R *.lfm}

{ TfAbout }

procedure TfAbout.btn_CloseClick(Sender: TObject);
begin
  close;
end;

procedure TfAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if key = 27 then begin
    key := 0;
    close;
  end;
end;

end.

