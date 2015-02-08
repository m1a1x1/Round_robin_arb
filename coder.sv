module priority_coder

#( 
  parameter REQCNT   = 3,
  parameter REQWIDTH = $clog2( REQCNT )
)

(
  input                       clk_i,
  input                       rst_i,

  input logic  [REQCNT-1:0]   data_i,
  input logic  [REQWIDTH-1:0] prior_i,
  output logic [REQWIDTH-1:0] data_num_o
);

logic [REQCNT-1:0] req_high;
logic [REQCNT-1:0] req_low;

logic [REQWIDTH-1:0] hight_num;
logic [REQWIDTH-1:0] low_num;

logic [REQCNT-1:0] mask_hight;
logic [REQCNT-1:0] mask_low;

assign req_high = data_i & mask_hight;
assign req_low  = data_i & mask_low;

always_comb
  begin
    for( int i = 0; i < REQCNT; i++ )
      begin
        if( i < prior_i )
          begin
             mask_hight[ i ] = 0;
             mask_low[ i ]   = 1;
          end
        else
          begin
            if( i == prior_i )
              begin
                mask_hight[ i ] = 0;
                mask_low[ i ]   = 0;
              end
            else
              begin
                mask_hight[ i ] = 1;
                mask_low[ i ]   = 0;
              end
          end
      end
  end

always_comb
  begin
    for( int i = 0; i < REQCNT; i++ )
      begin
        if( req_high[ i ] )
          begin
            hight_num = i;
            i = REQCNT;
          end
        else
          begin
            hight_num = 0;
          end
      end
  end

always_comb
  begin
    for( int i = 0; i < REQCNT; i++ )
      begin
        if( req_low[ i ] )
          begin
            low_num = i;
            i = REQCNT;
          end
        else
          begin
            low_num = 0;
          end
      end
  end

always_comb
  begin
    data_num_o = 0;
    if( data_i[ prior_i ] )
      begin
        data_num_o = prior_i;
      end
    else
      begin
        if( hight_num != 0 )
          begin
            data_num_o = hight_num + prior_i;
          end
        else
          begin
            data_num_o = low_num;
          end
      end
  end
endmodule
