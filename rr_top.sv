//Descriprion: 
//  Входные сигналы - запросы и их валидность.
//  Выходные сигналы - номер запроса, который был выбран арбитером,
// номер определяется действующим приоритетом, если приоритетного запроса нет - приоритет не меняется
// и на выходе - номер старшего запроса.

module rr_top

#( 
  parameter DATAWIDTH = 3
)

(
  input                           clk_i,
  input                           rst_i,

  input        [2**DATAWIDTH-1:0] req_i,
  input                           req_val_i,
  output logic [DATAWIDTH-1:0]    req_num_o
);

logic [DATAWIDTH-1:0] prior_w;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        prior_w <= '0;
      end
    else
      begin
        if( req_val_i )
          begin
            if( req_i[ prior_w ] )
              begin
                prior_w <= prior_w + 1;
              end
            else
              begin
                prior_w <= prior_w;
              end
          end
      end
  end

priority_coder pc(

  .data_i      ( req_i     ),
  .prior_i     ( prior_w   ),
  .data_num_o  ( req_num_o )

);
  defparam pc.DATAWIDTH = DATAWIDTH;

endmodule
