module uartreceiver(rxdata,rxclk,rxreset,startbit,data);

input [7:0]data;
input rxclk;
input rxreset;
input startbit;
output [10:0]rxdata;
parameter rx_initial=0;
parameter rxmode=1;
reg state;
wire [7:0]data;
reg [10:0]rxdata;
reg parity;
integer i;

initial 
begin 
rxdata=10'b0000000000;
parity=0;
i=0;
end

always @(posedge rxclk)

begin 

  if (rxreset==0)
  begin
  state<=0;
  rxdata<=0;
  end

  else
  case (state)

    rx_initial: 
       begin
       if (startbit==1)
       begin 
       state<=rx_initial;
       rxdata<=0;
       end
       else
       state<=rxmode;
       end

     rxmode:
       begin  
       rxdata[0]=0;
       for (i=1;i<=8;i=i+1)
       begin 
       rxdata[i]=data[i-1];
       parity = parity^rxdata[i];
       end
       rxdata[9] = parity;
       rxdata[10] = 0;
        state<=rx_initial;
       end

endcase
 
end
endmodule 


module tb_receiver ();
reg [7:0]p;
reg q,r,s;
wire [10:0]t;
initial 
begin 
p=1'b0;
q=1'b0;
r=1'b0;
#10 r = 1'b1;
s=1'b0;
end
always 
#5 q=~q;
uartreceiver u1(.rxdata(t),.rxclk(q),.rxreset(r),.startbit(s),.data(p));
initial 
begin 
p=8'b11001100;
end
endmodule 
