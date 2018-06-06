/*module i2ctransmitter(txdata,data,txclk,startbit,txreset);
input [15:0]data;
input txclk;
input txreset;
input startbit;
output [18:0]txdata;
parameter tx_initial=0;
parameter txmode=1;
reg state;
wire [15:0]data;
reg [18:0]txdata;
reg parity;
integer i;
initial 
begin 
txdata=18'b000000000000000000;
parity=0;
i=0;
end
always @(posedge txclk)
begin 
  if (txreset==0)
  begin
  state<=0;
  txdata<=0;
  end
  else
  case (state)
    tx_initial: 
       begin
       if (startbit==0)
       begin 
       state<=tx_initial;
       txdata<=0;
       end
       else
       state<=txmode;
       end

     txmode:
       begin  
       txdata[0]=0;
       for (i=1;i<17;i=i+1)
       begin 
       txdata[i]=data[i-1];
       parity = parity^txdata[i];
       end
       txdata[17] = parity;
       txdata[18] = 0;
        state<=tx_initial;
       end
endcase 
end
endmodule 

module tb_transmitter();
reg [15:0]a;
reg b,c,d;
wire [18:0]e;
initial 
begin 
b=1'b0;
c=1'b1;
d=1'b0;
#10 d=1'b1;
end
always
#5 b=~b;
uarttransmitter u1(.txdata(e),.data(a),.txclk(b),.startbit(c),.txreset(d));
initial 
begin 
a=15'b110011001100110;
end
endmodule
*/

module uarttransmitter(txdata,data,txclk,startbit,txreset);

input [7:0]data;
output [11:0]txdata;
input txclk;
input startbit;
input txreset;
parameter tx_initial = 0;
parameter txmode = 1;
reg state;
integer i;
wire [7:0]data;
reg [11:0]txdata;
reg stopbit; 
initial
begin
i=0;
txdata=12'b000000000000;
stopbit = 1'b1;
end
always @(negedge txclk)

begin
  if (txreset==0)
  begin 
  state<=0;
  txdata<=0;

  end
  else

  case (state)
  tx_initial:
    begin  
      if (startbit == 0)
      begin
      state<=tx_initial;
      txdata<=0;
      end

      else 
      state<=txmode;
    end
   txmode:
     begin
     for (i=0;i<=7;i=i+1)
     txdata[i+2]=data[i];
     txdata[0] <= startbit;
     txdata[1] <= 1'b1;
     txdata[10] <= 1'b1;
     txdata[11] <= stopbit;
    
     state<=tx_initial;
     end

  endcase 

end 
endmodule

module tb_transmitter();
reg [10:0]a;
reg b,c,d;
wire [7:0]e;

initial 
begin 
b=1'b0;
c=1'b0;
d=1'b0;
#10 d=1'b1;
end

always
#5 b=~b;
uarttransmitter u1(.txdata(e),.data(a),.txclk(b),.startbit(c),.txreset(d));

initial 
begin 
a=8'b11001111;
end

endmodule
