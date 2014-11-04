module priority_coder

#( 
  parameter DATAWIDTH = 3
)

(
  input        [2**DATAWIDTH-1:0] data_i,
  input        [DATAWIDTH-1:0]    prior_i,
  output logic [DATAWIDTH-1:0]    data_num_o
);

always_comb
  begin
    data_num_o = 0;
      if( data_i[ prior_i ] == 1 )
        begin
          data_num_o = prior_i;
        end
      else
        begin
          for( int i = 0;  i < 2**DATAWIDTH; i++ ) 
            begin	 
              if( data_i[ i ] )		
                data_num_o = i;	
            end
        end 
  end

endmodule
