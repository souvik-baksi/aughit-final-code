%init_bot

% create serial communication object on port COM9
arduino=serial('COM9','BaudRate',9600,'DataBits',8,'StopBit',1,'Parity','none'); 
fopen(arduino);