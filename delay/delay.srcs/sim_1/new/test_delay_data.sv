`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2021 11:26:20
// Design Name: 
// Module Name: test_delay_data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_delay_data(); 
parameter BUS_WIDTH_IN_BYTES = 2; 
logic clk;
logic ARESETN;
logic enable;
logic [15:0] delay;
logic [8*BUS_WIDTH_IN_BYTES-1:0] DATA_IN;
logic [8*BUS_WIDTH_IN_BYTES-1:0] DATA_OUT;

logic m_axis_tready;
logic s_axis_tvalid;

logic s_axis_tready;
logic m_axis_tvalid;

logic [BUS_WIDTH_IN_BYTES-1:0] s_axis_tkeep;
logic [BUS_WIDTH_IN_BYTES-1:0] s_axis_tstrb;

logic [BUS_WIDTH_IN_BYTES-1:0] m_axis_tkeep;
logic [BUS_WIDTH_IN_BYTES-1:0] m_axis_tstrb;



initial begin
clk   = 0;
delay = 50;
enable = 0;
ARESETN = 1;


s_axis_tkeep  = 0;
s_axis_tstrb  = 0;
m_axis_tready = 1;
s_axis_tvalid = 0;


fork
//changing enable signal----------------------

begin
// case (a) changing the valid signal when the counter is running

#30 enable = 1;
#320 enable = 0;

// case (b) a valid signal disappears at the last counter clock cycle

#50 enable         = 1;
#150 enable         = 0;

// case (c) a valid signal disappears at the last counter clock cycle

#50 enable          = 1;
#200 enable         = 0;
end

//changing the valid signal----------------------
begin
// case (a) changing the valid signal when the counter is running
   
#80  @ (posedge clk)  s_axis_tvalid = 1; 
#20  @ (posedge clk)  s_axis_tvalid = 0;
#20  @ (posedge clk)  s_axis_tvalid = 1;
    
#30  @(posedge clk) s_axis_tvalid = 0;
  
#60  @(posedge clk) s_axis_tvalid = 1;
#100 @(posedge clk) s_axis_tvalid = 0;


// case (b) a valid signal disappears at the last counter clock cycle
#50  @(posedge clk) s_axis_tvalid  = 1;
#139 @(posedge clk) s_axis_tvalid  = 0;

// case (c) a valid signal disappears at the last counter clock cycle
#340 @(posedge clk) s_axis_tvalid  = 1;
#400 @(posedge clk) s_axis_tvalid  = 0;
  
end

begin
#80 @(posedge clk) s_axis_tkeep = 1;
#80 @(posedge clk) s_axis_tstrb = 3;

#10 @(posedge clk) s_axis_tkeep = 3;
#10 @(posedge clk) s_axis_tstrb = 2;

#10 @(posedge clk) s_axis_tkeep  = 0;
#10 @(posedge clk) s_axis_tstrb = 0;

#10 @(posedge clk) s_axis_tkeep  = 1;
#10 @(posedge clk) s_axis_tstrb = 3;
end

/*begin 
#30  m_axis_tready = 1; 
#80 m_axis_tready = 0;
#100 m_axis_tready = 1;
#100 m_axis_tready = 0;
#100 m_axis_tready = 1;
#100 m_axis_tready = 0;


#100 m_axis_tready  = 1;
#200 m_axis_tready  = 0;

#260 m_axis_tready  = 1;
#400 m_axis_tready  = 0;
end*/

begin
repeat (100000) begin // 10 повторений
      @ (posedge clk); // negedge clk
      s_axis_tkeep  = $random;
      s_axis_tstrb  = $random;
       
   end 
end

join
//------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------




#700 @(posedge clk) m_axis_tready = 0;



end

always begin
   #1 clk = !clk; 
end
// counter signal  as input data 
always_ff @( posedge clk) begin
    if (s_axis_tready & s_axis_tvalid)
    DATA_IN  <= DATA_IN + 1; 
    else DATA_IN  <= 0;
end

/*always_ff @( posedge clk) begin
    if (s_axis_tready & s_axis_tvalid)
    s_axis_tkeep   <= s_axis_tkeep + 1; 
    else s_axis_tkeep   <= 0;
end

always_ff @( posedge clk) begin
    if (s_axis_tready & s_axis_tvalid)
    s_axis_tstrb   <= s_axis_tstrb + 1; 
    else s_axis_tstrb  <= 0;
end*/


delay_data DD (.ACLK(clk), .s_axis_tdata(DATA_IN),.m_axis_tdata(DATA_OUT),
.*) ;//outputs
endmodule
