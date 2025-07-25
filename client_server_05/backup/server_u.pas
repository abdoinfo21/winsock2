unit server_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows,
  WinSock2;

type

  { Thread }

  Thread = class (TTHread)

    protected
      Procedure Execute;Override;
      Procedure OnRead;
    Public
      Constructor Create (bool:Boolean);
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
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  Form1: TForm1;
  Data:WSAData;
  ListenSocket,AcceptSocket:Tsocket;
  Service:sockAddr_in;
  iResult:Integer;
  str: string;
  th:Thread;

implementation

{$R *.lfm}

{ Thread }

procedure Thread.Execute;
begin
  while not Terminated Do
     OnRead;
  Application.ProcessMessages;
end;

procedure Thread.OnRead;
begin
     SetLength(str, 128);
     if Recv(AcceptSocket, @str[1], 1024, 0) > 0 then
        Form1.Memo1.lines.add('Msg :'+ str)
     else
       Form1.Memo1.Lines.Add('Debug :Server Reciving TimeOut');
end;

constructor Thread.Create(bool: Boolean);
begin
    Suspended:=bool;
    FreeOnTerminate:=True;
    inherited Create(bool);
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
          Procedure OnListen ;
               begin
                  iResult := WSAStartUp(MAKEWORD(2,2),Data);

                th:=Thread.Create(True);
                if iResult <> NO_ERROR Then
                Form1.Memo1.lines.add('Error Loading DLL WinSock');

                ListenSocket := socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
                if ListenSocket = INVALID_SOCKET then
                   Form1.Memo1.lines.add('Listening Fail');

                service.sin_family:=AF_INET;
                Service.sin_addr.S_addr:=INADDR_ANY;
                Service.sin_Port:=htons(8808);

                if bind(ListenSocket,Service,SizeOf(service)) = SOCKET_ERROR then
                   begin
                     Form1.Memo1.lines.add('binding Fail');
                     WSACleanUp;
                   end;
                if listen(listensocket,1) = SOCKET_ERROR then
                   begin
                     Form1.Memo1.lines.add('Listening Error');
                     CloseSocket(ListenSocket);
                     WSACleanUp;
                   end;
                Form1.Memo1.lines.add('listening...');

                AcceptSocket:=Accept(ListenSocket,nil,nil);
                if  AcceptSocket = INVALID_SOCKET then
                    begin
                      Form1.Memo1.lines.add('Accept connection Faild');
                      CloseSocket(ListenSocket);
                      WSACleanUp;
                    end
                else
                    begin
                    Form1.Memo1.lines.add('connection succed');
                    th.Start;
                    end;
          end;
    begin
     With Tthread.CreateAnonymousThread(TProcedure(@OnListen)) do
     begin
      FreeOnTerminate:=True;
        Start;
     end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  len:integer;
  msg:string;
begin
 msg:=edit1.text;
  len:=length(msg);
  Send(AcceptSocket,Pointer(msg)^, len, 0);
  Memo1.lines.add('Server say: '+edit1.Text);
  //edit1.Text:='';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  CloseSocket(ListenSocket);

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key =#13 then
     button2.Click;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
 WSACleanUp;
end;

end.

