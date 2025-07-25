program client;

uses
  windows,Winsock2;

var
 Data:WSAData;
 ConnectSocket:TSocket;
 iResult:integer;
 ClientService:SockAddr_in;
 NameHost:Pchar;
 str1:string;

begin
     str1:='';
 iResult:=WSAStartUp(MAKEWORD(2,2),Data);
 if iResult <> NO_ERROR then
    Writeln('loaading winsock DLL Error');

 ConnectSocket:=Socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
 if ConnectSocket = INVALID_SOCKET then
    begin
      Writeln('Creating Socket Error');
      WSACleanUp;
    end;
 ClientService.sa_family:=AF_INET;
 ClientService.sin_addr.S_addr:=Inet_Addr('127.0.0.1');
 ClientService.sin_port:=htons(8808);

 iResult := Connect(ConnectSocket,ClientService,SizeOf(ClientService));
 if iResult=SOCKET_ERROR then
    begin
     Writeln('Connection Error ');
    end;
    Send(ConnectSocket, 'Message1 received', 16, 0);
    Writeln('Msg sent ');
    SetLength(str1, 16);
    if Recv(ConnectSocket, @str1[1], 16, 0) > 0 then
        writeln('Msg :'+ str1)
    else
       writeln('client : time out');
     iResult := CloseSocket(ConnectSocket);
     if iResult = SOCKET_ERROR then
        begin
         Writeln('Socket can''t Closed');
         WSACleanUp;
        end;
  WSACleanUp;
     readln();
end.

