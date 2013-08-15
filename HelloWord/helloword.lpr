library helloword;

{ $mode objfpc}{$H+}

uses
//  dynlibs,
	Classes, messages, SysUtils, LCLType, LCLIntf, LMessages,
  Forms, Interfaces, Dialogs,
  formtest, controller, libpluginstype, about;


function init( pwAppHandle : HWND; var prPluginInfo:TPluginInitResult) : TPluginInitResult; cdecl; export;
begin
  AppHandle:= pwAppHandle;
  Application.Initialize;
  ___log( 'PlugIn Init: ' + css_PLUGIN_NAME);

  with prPluginInfo do begin
    err:= 0;
    PluginType:= 0; // normal plugin
    name:= css_PLUGIN_NAME;
    version:=css_VERSION;
    vendor:= css_VENDOR;
    //menustr:= 'Sample Menu|Sample SubMenu';
    menustr:= '';
  end;
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_FILEOPEN, 0);

  pluginHelloWord := THelloWord.Create;
  ___RegisterPlugin( @pluginHelloWord);

  Result.message := 'init done';

end;

function message_handler( plParam: LPARAM; pwParam: WPARAM; msg: Integer): LRESULT; cdecl; export;
var
  lsS, lsFileName : string;
begin
  if plParam <> LM_AKSIIDE_USER then Exit;
  case pwParam of
    WM_AKSIIDE_FILEOPEN : begin
      lsFileName := strpas( pchar( msg));
      //___log( 'open file --> ' + lsFileName);
    end;
    WM_AKSIIDE_FILECLOSE : begin
      lsFileName := strpas( pchar( msg));
    end;
    WM_AKSIIDE_PROJECTOPEN : begin
      lsFileName := strpas( pchar( msg));
    end;
    WM_AKSIIDE_PROJECTCLOSE : begin
      lsFileName := strpas( pchar( msg));
    end;
    WM_AKSIIDE_DESTROY : begin
      // free your memory
    end;
  end;
  //_log( 'message receive' + IntToStr(pwParam));
end;

function info( pwAppHandle : HWND; var poResult: TPluginCallResult) : Pointer; cdecl; export;
begin
  if fAbout = nil then fAbout := TfAbout.Create( Application);
  fAbout.Show;
  poResult.err:= 0;
  Result := nil;
end;

exports
  init, message_handler, info
{$ifdef linux}
, getfunctionlist
{$endif}
{$IFDEF DARWIN}  {OS X}
  Init name '_Init',  {For use with LoadLibrary}
{$ENDIF}
  ;

begin
end.


