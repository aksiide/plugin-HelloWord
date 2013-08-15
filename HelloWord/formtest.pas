unit formtest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ButtonPanel;

type

  { TfFormTest }

  TfFormTest = class(TForm)
    lst: TListBox;
    pnl_Button: TButtonPanel;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mnu_testpluginmenu: TMenuItem;
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fFormTest: TfFormTest;

implementation

uses libpluginstype;

{$R *.lfm}

{ TfFormTest }

procedure TfFormTest.OKButtonClick(Sender: TObject);
begin
  ___log( 'form ok');
  close;
end;

procedure TfFormTest.CloseButtonClick(Sender: TObject);
begin
  ___log( 'form close');
  close;
end;

procedure TfFormTest.CancelButtonClick(Sender: TObject);
begin
  ___log( 'form cancel');
  close;
end;

initialization
  fFormTest := nil;

end.

