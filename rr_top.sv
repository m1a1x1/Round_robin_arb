//Descriprion: 
//  Входные сигналы - запросы и их валидность.
//  Выходные сигналы - номер запроса, который был выбран арбитером,
// номер определяется действующим приоритетом, если приоритетного запроса нет - приоритет не меняется
// и на выходе - номер старшего запроса.

module rr_top

#( 
  parameter REQCNT   = 5,
  parameter REQWIDTH = $clog2( REQCNT )
)

(
  input                       clk_i,
  input                       rst_i,

  input        [REQCNT-1:0]   req_i,
  input                       req_val_i,
  output logic [REQWIDTH-1:0] req_num_o
);

logic [REQWIDTH-1:0] prior_w;
logic [REQCNT-1:0] req_w;

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
            if( prior_w == REQCNT - 1 )
              begin
                prior_w <= '0;
              end
            else
              begin
                prior_w <= prior_w + 1;
              end
          end
        else
          begin
            prior_w <= prior_w;
          end
      end
  end

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        req_w <= 0;
      end
    else
      begin
        req_w <= req_i;
      end
  end
  
priority_coder pc(

  .data_i      ( req_w     ),
  .prior_i     ( prior_w   ),
  .data_num_o  ( req_num_o )

);
defparam pc.REQCNT = REQCNT;

endmodule

