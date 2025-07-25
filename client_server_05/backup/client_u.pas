unit client_u;

{$mode objfpc}{$H+}

interface

uses
  Classes,windows, SysUtils, Forms, Controls, Graphics,winsock2, Dialogs, StdCtrls;

type

  { Thread }

  Thread = class (TTHread)
   protected
     procedure Execute;override;
     procedure OnRead;
   public
     Constructor Create(boll:Boolean);
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  var
 Data:WSAData;
 ConnectSocket:TSocket;
 iResult:integer;
 ClientService:SockAddr_in;
 NameHost:Pchar;
 str1:string;
 th:Thread;

implementation

{$R *.lfm}

{ Thread }

procedure Thread.Execute;
begin
    while not Terminated Do
      begin
        OnRead;
        sleep(10);
        //Application.ProcessMessages;
      end;
end;

procedure Thread.OnRead;
begin
   SetLength(str1, 128); //you have to set the length of the string before reciving
    if Recv(ConnectSocket, @str1[1], 128, 0) > 0 then
        Form1.memo1.lines.add('Ser(ver :'+ str1)
    else
       Form1.memo1.lines.add('client : Reciving time out');
end;

constructor Thread.Create(boll: Boolean);
begin
   Suspended:=boll;
   FreeOnTerminate:=True;
  inherited Create(boll);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   str1:='';
   th:=Thread.Create(True);
 iResult:=WSAStartUp(MAKEWORD(2,2),Data);
 if iResult <> NO_ERROR then
    memo1.lines.add('loaading winsock DLL Error');

 ConnectSocket:=Socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
 if ConnectSocket = INVALID_SOCKET then
    begin
      memo1.lines.add('Creating Socket Error');
      WSACleanUp;
    end;
 ClientService.sa_family:=AF_INET;
 ClientService.sin_addr.S_addr:=Inet_Addr('127.0.0.1');
 ClientService.sin_port:=htons(8808);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   iResult := Connect(ConnectSocket,ClientService,SizeOf(ClientService));
 if iResult=SOCKET_ERROR then
    begin
     memo1.lines.add('Connection Error ');
    end
 else
 begin
  memo1.lines.add('Connected......');
 th.Start;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  msg :string ;
begin
 msg:=edit1.text;
  Send(ConnectSocket,Pointer(Msg)^, 128, 0);   //Send(ConnectSocket, Pointer(Msg)^, Length(Msg), 0);
    memo1.lines.add('Server : '+ msg);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  iResult := CloseSocket(ConnectSocket);
     if iResult = SOCKET_ERROR then
        begin
         memo1.lines.add('Socket can''t Closed');
        end;

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
    WSACleanUp;
end;

end.

