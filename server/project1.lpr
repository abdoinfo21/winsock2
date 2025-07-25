program project1;

uses
   Windows,WinSock2;

var
  Data:WSAData;
  ListenSocket,AcceptSocket:Tsocket;
  Service:sockAddr_in;
  iResult:Integer;

begin
  iResult := WSAStartUp(MAKEWORD(2,2),Data);

  if iResult <> NO_ERROR Then
  Writeln('Error Loading DLL WinSock');

  ListenSocket := socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
  if ListenSocket = INVALID_SOCKET then
     writeln('Listening Fail');

  service.sin_family:=AF_INET;
  Service.sin_addr.S_addr:=INADDR_ANY;
  Service.sin_Port:=htons(8808);

  if bind(ListenSocket,Service,SizeOf(service)) = SOCKET_ERROR then
     begin
       Writeln('binding Fail');
       WSACleanUp;
     end;
  if listen(listensocket,1) = SOCKET_ERROR then
     begin
       writeln('Listening Error');
       CloseSocket(ListenSocket);
       WSACleanUp;
     end;
  writeln('listening...');

  AcceptSocket:=Accept(ListenSocket,nil,nil);
  if  AcceptSocket = INVALID_SOCKET then
      begin
        writeln('connction Faild');
        CloseSocket(ListenSocket);
        WSACleanUp;
      end
  else
      writeln('connction succed');
        CloseSocket(ListenSocket);
        WSACleanUp;
       readln;
end.

