unit libpluginstype;

{$mode objfpc}{$H+}

interface

uses
  Menus, Dialogs, Forms,
  LclIntf, LMessages, LclType, LResources, DynLibs,
  Classes, SysUtils;
  
const
  ci_FileOpen = 1; // call from startaksiide

  LM_AKSIIDE_USER = LM_USER + 100;
  LM_AKSIIDE_LOG = LM_AKSIIDE_USER + 1;

  WM_AKSIIDE_USER = (WM_USER + 1001);
  WM_AKSIIDE_DESTROY = WM_AKSIIDE_USER + 01;

  WM_AKSIIDE_FILENEW = WM_AKSIIDE_USER + 11;
  WM_AKSIIDE_FILEOPEN = WM_AKSIIDE_USER + 12;
  WM_AKSIIDE_FILECLOSE = WM_AKSIIDE_USER + 13;
  WM_AKSIIDE_FILESAVE = WM_AKSIIDE_USER + 14;

  WM_AKSIIDE_PROJECTOPEN = WM_AKSIIDE_USER + 21;
  WM_AKSIIDE_PROJECTCLOSE = WM_AKSIIDE_USER + 22;

  WM_AKSIIDE_TOOLS_DOWNLOAD = WM_AKSIIDE_USER + 31;

  WM_AKSIIDE_EDITOR_GETTEXT = WM_AKSIIDE_USER + 51;
  WM_AKSIIDE_EDITOR_REPLACETEXT = WM_AKSIIDE_USER + 52;
  WM_AKSIIDE_EDITOR_INSERTTEXT = WM_AKSIIDE_USER + 53;

  // message
  WM_AKSIIDE_LOG = (WM_USER + 1101);
  WM_AKSIIDE_NOTIFICATION = (WM_USER + 1102);

  CI_NAME_LENGTH = 64;

  css_plugin_address_init = 'init';
  css_plugin_address_info = 'info';
  css_plugin_address_getfunctionlist = 'getfunctionlist';


type
  TPluginInfo = record
    name:string;
    filename : string;
    version : string;
    vendor : string;
    menustr : string;
    pointer: TLibHandle;
  end;

  TPluginCallResult = record
    err : integer;
    message : widestring;
    ptr : Pointer;
  end;
  TPluginInstallResult = record
    err : integer;
    message : widestring;
    name : widestring;
    vendor : widestring;
    version : widestring;
  end;
  TPluginInitResult = record
    err : integer;
    PluginType : integer; //0:default
    message : widestring;
    name : widestring;  // description
    vendor : widestring;
    version : widestring;
    menustr : widestring; //parent menu: blank -> default; example: 'Tools|SubMenu' --> 'Tools|SubMenu|PluginNAme'
  end;

  TDownloadInfo = record
    download_type: integer;
    url: widestring;
    targetdir:widestring;
  end;

  TEditorInfo = record
    status : integer; //1: no file openned;
    filename : widestring;
    line : integer;
    col : integer;
    is_selected : boolean;
    text_selected: widestring;
  end;

  TNotificationInfo = record
    caption : widestring;
    message : widestring;
  end;

  //TPluginCallTemplate = procedure( var1:integer; var var2:TPluginInitResult); cdecl;
  TPluginCallInit = function( pwAppHandle : HWND; var par2:TPluginInitResult) : TPluginInitResult; cdecl;
  TPluginCall = function( pwAppHandle : HWND; var poResult: TPluginCallResult) : Pointer; cdecl;
  TPluginMessageHandler = function(  plParam: LPARAM; pwParam: WPARAM; msg: Integer) : LRESULT; cdecl;

  PFUNCPROCEDURE = procedure(Sender: TObject) of object;cdecl;
  PFUNCSHORTCUTKEY = ^TShortcutKey;
  TShortcutKey = record
    IsCtrl : Boolean;
    IsAlt  : Boolean;
    IsShift: Boolean;
    Key    : Char;
  end;
  TFunctionItem = record
    name : array[ 0..CI_NAME_LENGTH-1] of WChar;
    proc : PFUNCPROCEDURE;
    ShortcutKey: PFUNCSHORTCUTKEY;
  end;

  { TAksiIDEPlugin }

  TAksiIDEPlugin = class (TObject)
    PluginName : widestring;
    Version : widestring;
    FunctionList : array of TFunctionItem;
    Menu : TMenuItem;
  protected
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    procedure BeforeDestruction; override;

    procedure AddFunction( Name: WideString; const Proc: PFUNCPROCEDURE = nil; const ShortcutKey: char = #0; const Shift: TShiftState = []);

    function Ping:string;
//  property
//    Name: string read FName write FName;

  end;

var
  ptrPlugin : pointer;
  AppHandle : HWND;

procedure ___log( const psMessage:string);
procedure ___log( const piI:integer);
procedure ___notification( const psCaption, psMessage:string);
function  ___RegisterPlugin( poObject:pointer = nil):boolean;
function  getfunctionlist( var riCount:integer):pointer;cdecl; export;

implementation

procedure ___log( const psMessage:string);
var
  pcMsg : pchar;
begin
//  pcMsg := StrAlloc( Length( psMessage)+1);
//  StrCopy( pcMsg, PChar( psMessage));
  pcMsg := pchar( psMessage);
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_LOG, LPARAM( pcMsg));
//  StrDispose( pcMsg);
end;

procedure ___log( const piI:integer);
begin
  try
    ___log( IntToStr( piI));
  except
  end;
end;

procedure ___notification( const psCaption, psMessage:string);
var
  lrNotification : TNotificationInfo;
begin
  lrNotification.caption:= psCaption;
  lrNotification.message:= psMessage;
  SendMessage( AppHandle, LM_AKSIIDE_USER, WM_AKSIIDE_NOTIFICATION, LPARAM( @lrNotification));
end;

function ___RegisterPlugin( poObject: pointer = nil): boolean;
begin
  Result := false;
  if poObject = nil then Exit;
//  ShowMessage( 'register:' + TAksiIDEPlugin( poObject^).PluginName);

  ptrPlugin := poObject;
  Result := true;
end;

function GetFunctionList(var riCount: integer): pointer; cdecl;
begin
  riCount := 0;
  Result := nil;
  if ptrPlugin = nil then Exit;

  riCount := Length( TAksiIDEPlugin( ptrPlugin^).FunctionList);
  Result := ptrPlugin;
end;



{ TAksiIDEPlugin }

constructor TAksiIDEPlugin.Create;
begin
  inherited;
  //
end;

destructor TAksiIDEPlugin.Destroy;
begin
  //
  inherited Destroy;
end;

procedure TAksiIDEPlugin.BeforeDestruction;
begin
  //
  inherited BeforeDestruction;
end;

procedure TAksiIDEPlugin.AddFunction(Name: WideString;
  const Proc: PFUNCPROCEDURE; const ShortcutKey: char; const Shift: TShiftState
  );
var
  laFunction : TFunctionItem;
begin
  fillchar( laFunction, sizeof( laFunction), 0);
  laFunction.name := Name;
  laFunction.proc:= Proc;

  SetLength( FunctionList, Length( FunctionList) + 1);
  FunctionList[ Length( FunctionList)-1] := laFunction;
end;

function TAksiIDEPlugin.Ping: string;
begin
  Result := 'pong';

end;


exports
  getfunctionlist;

initialization
  ptrPlugin := nil;


end.

