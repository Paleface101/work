`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module delay_data #(parameter n = 2 //,//Data bus width in bytes.
//w=1, 
//t=n%w, 
/*b=n-(t*w)*/)
(
input wire ACLK,
input wire [15:0] delay,
output wire       enable,
// input axi
output wire  s_axis_tready,
input  wire  s_axis_tvalid,
input  wire [8*n-1:0] s_axis_tdata,
input  wire [n-1:0] s_axis_tstrb,
input  wire [n-1:0] s_axis_tkeep,

// output axi

input  wire           m_axis_tready,
output wire           m_axis_tvalid,
output wire [8*n-1:0] m_axis_tdata,
output wire [n-1:0]   m_axis_tstrb,
output wire [n-1:0]   m_axis_tkeep

);

 reg [15:0] counter; 
 reg EN;
 //internal data
  reg [8*n-1:0] m_axis_tdata_int;
  reg [n-1:0]   m_axis_tkeep_int;
  reg [n-1:0]   m_axis_tstrb_int;
  reg           m_axis_tvalid_int; 
  reg           s_axis_tready_int;
  
always @(posedge ACLK ) begin

    m_axis_tvalid_int <= s_axis_tvalid ;
    s_axis_tready_int <= m_axis_tready;
    
    if (s_axis_tready & s_axis_tvalid) begin
        counter <= counter + 1'b1;
         m_axis_tkeep_int  <= s_axis_tkeep;
         m_axis_tstrb_int  <= s_axis_tstrb;
        if (counter >= delay)  
         EN <= 1'b1;
        else 
         EN <= 1'b0;
    end
    if (~s_axis_tvalid)
       counter <= 0;
       
       
     if (s_axis_tready & s_axis_tvalid & EN) begin
         m_axis_tdata_int  <= s_axis_tdata;

     end  
end

assign m_axis_tdata  = m_axis_tdata_int;
assign m_axis_tkeep  = m_axis_tkeep_int;
assign m_axis_tstrb  = m_axis_tstrb_int; 
assign m_axis_tvalid = m_axis_tvalid_int ;
//assign m_axis_tready = m_axis_tready_int ;
assign s_axis_tready = s_axis_tready_int;
assign enable        = EN;

endmodule
