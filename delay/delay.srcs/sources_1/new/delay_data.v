`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module delay_data #( 
parameter BUS_WIDTH_IN_BYTES = 2 //Data bus width in bytes.
)
(
input wire                             ACLK,
input wire                             ARESETN,
input wire [15:0]                      delay,
input wire                             enable,
// input axi
output wire                            s_axis_tready,
input  wire                            s_axis_tvalid,
input  wire [8*BUS_WIDTH_IN_BYTES-1:0] s_axis_tdata,
input  wire [BUS_WIDTH_IN_BYTES-1:0]   s_axis_tstrb,
input  wire [BUS_WIDTH_IN_BYTES-1:0]   s_axis_tkeep,

// output axi

input  wire                            m_axis_tready,
output wire                            m_axis_tvalid,
output wire [8*BUS_WIDTH_IN_BYTES-1:0] m_axis_tdata,
output wire [BUS_WIDTH_IN_BYTES-1:0]   m_axis_tstrb,
output wire [BUS_WIDTH_IN_BYTES-1:0]   m_axis_tkeep

);

  reg       [15:0]                     counter = 0; 
 //internal data
  reg       [8*BUS_WIDTH_IN_BYTES-1:0] m_axis_tdata_int  = 0;
  reg       [BUS_WIDTH_IN_BYTES-1:0]   m_axis_tkeep_int  = 0;
  reg       [BUS_WIDTH_IN_BYTES-1:0]   m_axis_tstrb_int  = 0;
  reg                                  m_axis_tvalid_int = 0; 
  reg                                  s_axis_tready_int = 0;
  
always @( posedge ACLK ) begin
    if ( !ARESETN ) begin
        m_axis_tdata_int  <= 0;
        m_axis_tkeep_int  <= 0;
        m_axis_tstrb_int  <= 0;
        s_axis_tready_int <= 0;
        m_axis_tvalid_int <= 0;
        counter           <= 0;
     end else begin
        s_axis_tready_int <= m_axis_tready;
    if      ( !enable )       
                counter <= 1'b0;
    else if ( enable && s_axis_tready && s_axis_tvalid ) 
                counter <= counter + 1'b1;
                
       if ( s_axis_tready && s_axis_tvalid && counter >= delay ) begin
            m_axis_tvalid_int <= s_axis_tvalid;
            m_axis_tdata_int  <= s_axis_tdata;
            counter           <= counter;
       end
           else if( !s_axis_tvalid ) m_axis_tvalid_int <= 0;
           
       if ( s_axis_tready && s_axis_tvalid ) begin
            m_axis_tkeep_int <= s_axis_tkeep;
            m_axis_tstrb_int <= s_axis_tstrb;
      end     
    end   
end 

// assign outputs of internal reg
assign m_axis_tdata  = m_axis_tdata_int;
assign m_axis_tkeep  = m_axis_tkeep_int;
assign m_axis_tstrb  = m_axis_tstrb_int; 
assign m_axis_tvalid = m_axis_tvalid_int;
assign s_axis_tready = s_axis_tready_int;

endmodule
