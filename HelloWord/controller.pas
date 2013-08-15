unit controller;

//{$mode objfpc}{$H+}
{$mode Delphi}

interface

uses
  Dialogs, Forms,
  LclIntf, LMessages, LclType, LResources, DynLibs,
  Classes, SysUtils, libpluginstype;

const
  css_PLUGIN_NAME = 'Hellooww Word Plugin';
  css_VERSION = '0.0.0';
  css_VENDOR = 'AksiIDE';

type

  { THelloWord }
  THelloWord = class( TAksiIDEPlugin)
  private
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    procedure BeforeDestruction; override;

    procedure FunctionOne( Sender: TObject); cdecl;
    procedure FunctionTwo( Sender: TObject); cdecl;
    procedure TestOpenFile( Sender: TObject); cdecl;
    procedure TestGetText( Sender: TObject); cdecl;
    procedure TestReplaceText( Sender: TObject); cdecl;
    procedure TestInsertText( Sender: TObject); cdecl;
    procedure TestDownload( Sender: TObject); cdecl;
    procedure About( Sender: TObject); cdecl;
  end;

var
  pluginHelloWord : THelloWord;

implementation

uses formtest;

{ THelloWord }

procedure THelloWord.FunctionOne(Sender: TObject); cdecl;
begin
  showmessage( 'one');
end;

procedure THelloWord.FunctionTwo(Sender: TObject); cdecl;
begin
  ShowMessage( 'this is function two');
end;

procedure THelloWord.TestOpenFile(Sender: TObject); cdecl;
var
  lsFileName : string;
begin
  lsFileName:= ExtractFilePath(Application.ExeName) + 'plugins/core/helloword.txt';
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_FILEOPEN, LPARAM( pchar( lsFileName)));
end;

procedure THelloWord.TestGetText(Sender: TObject); cdecl;
var
  lrEditorInfo: TEditorInfo;
begin
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_EDITOR_GETTEXT, LPARAM( @lrEditorInfo) );
  if lrEditorInfo.status = 1 then Exit; // no file openned
  if not lrEditorInfo.is_selected then Exit; //
  ShowMessage( 'text:'#13#10 + lrEditorInfo.text_selected);
end;

procedure THelloWord.TestReplaceText(Sender: TObject); cdecl;
var
  lsS : string;
begin
  lsS := 'STRING REPLACEMENT';
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_EDITOR_REPLACETEXT, LPARAM( pchar( lsS)));
end;

procedure THelloWord.TestInsertText(Sender: TObject); cdecl;
var
  lsS : string;
begin
  lsS := 'Hellooww Word.... Welcome to AksiIDE';
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_EDITOR_INSERTTEXT, LPARAM( pchar( lsS)));
end;

procedure THelloWord.TestDownload(Sender: TObject); cdecl;
var
  lrDownloadInfo : TDownloadInfo;
begin
  lrDownloadInfo.download_type := 0;
  //lrDownloadInfo.url:= 'http://localhost/files/file.tar.gz';
  //lrDownloadInfo.url:= 'http://id.dl.aksiide.com/try/AksiIDE-update-bin.tar.gz';
  //lrDownloadInfo.targetdir:= 'T:\teMP\';
  lrDownloadInfo.url:= 'http://app.aksiide.com/test.tar.gz';
  lrDownloadInfo.targetdir:= GetUserDir;
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_TOOLS_DOWNLOAD, LPARAM( @lrDownloadInfo));
end;

procedure THelloWord.About(Sender: TObject); cdecl;
begin
  if fFormTest = nil then fFormTest := TfFormTest.Create( Application );
  fFormTest.Show;
end;

constructor THelloWord.Create;
begin
  inherited;
  // your code
  PluginName:= css_PLUGIN_NAME;
  Version:= css_VERSION;

  AddFunction( 'function One', FunctionOne);
  AddFunction( 'function Two', FunctionTwo);
  AddFunction( '-');
  AddFunction( 'Test Open File', TestOpenFile);
  AddFunction( 'Test Insert Text to Editor', TestInsertText);
  AddFunction( 'Test GET SELECTED Text from Editor', TestGetText());
  AddFunction( 'Test REPLACE SELECTED Text', TestReplaceText());
  AddFunction( 'Test Download', TestDownload());
  AddFunction( '-');
  AddFunction( '&Example open Form', About);
end;

destructor THelloWord.Destroy;
begin
  // your code
  inherited Destroy;
end;

procedure THelloWord.BeforeDestruction;
begin
  // your code
  inherited BeforeDestruction;
end;

end.

