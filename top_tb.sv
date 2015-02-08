module r_r_arb_top_tb;

<<<<<<< HEAD
parameter REQCNT = 4;
=======
parameter REQCNT = 16;
>>>>>>> FETCH_HEAD

logic                        clk;
logic                        rst;

logic [REQCNT-1:0]           req;
logic                        req_val;
logic [$clog2( REQCNT )-1:0] req_num;

//clock generation:
initial
  begin
    clk = 0;
    forever
      begin
        #10 clk = !clk;
      end
  end

//testing:
initial
  begin
    rst = 0;
    #1 rst = 1;
    #1 rst = 0;
    req = 0;
    #250
    @( posedge clk );
    //all_req;
    //hard_tst;
    random_req;
  end 


  
//diferent tests:

//test #1:
task all_req;
  begin
    req = 2**REQCNT-1;
    forever
      begin
        @( posedge clk );
        req[ req_num ] = 0;
      end
  end
endtask

//test #2:
task random_req;
  begin
    @( posedge clk );
    req = {$random} % 2**REQCNT;
    forever
      begin
<<<<<<< HEAD
        @( negedge clk );
=======
        @( posedge clk );
>>>>>>> FETCH_HEAD
        keep_one;
        gen_rand_new;
      end
  end
endtask

<<<<<<< HEAD
int tmp2;
=======

>>>>>>> FETCH_HEAD
task keep_one;
  begin
    req[ req_num ] = {$random} % 2;
  end
endtask

task gen_rand_new;
<<<<<<< HEAD
  begin
    for( int i = 0; i < REQCNT; i++ )
      begin
        if( ( i != req_num ) && ( req[ i ] == 0 ) )
          begin
            req[ i ] = {$random} % 2;
          end
      end
  end
endtask
  
//gen. req_val:
initial
=======
>>>>>>> FETCH_HEAD
  begin
    for( int i = 0; i < REQCNT; i++ )
      begin
        if( ( i != req_num ) && ( req[ i ] == 0 ) )
          begin
            req[ i ] = {$random} % 2;
          end
      end
  end
endtask


//test #3:

task hard_tst;
  begin
    for( int i = REQCNT/2; i < REQCNT; i++ )
      begin
        req[ i ] = 1;
      end
  end
endtask
//gen. req_val:
always_comb
  begin
    req_val = |(req);
  end
//statistics - counting maximum time reqest waited to be done
logic [REQCNT-1:0][31:0] req_time_cnt;
int                      max_wait;
int                      cnt_test;
initial 
  begin
    req_time_cnt = 0;
    cnt_test     = 0;
    forever
      begin
        @( posedge clk )
          max_wait = req_time_cnt[ 0 ];
          for( int i = 0; i < REQCNT; i++)
            begin
              if( ( i == req_num ) || ( req[ i ] == 0 ) )
                begin   
                  req_time_cnt[ i ] = 0;
                end
              else
                begin
                  if( req[ i ] == 1 )
                    begin
                      req_time_cnt[ i ] = req_time_cnt[ i ] + 1; // reqest done
                    end
                end
              if( max_wait < req_time_cnt[ i ] )
                begin
                  max_wait = req_time_cnt[ i ];
                end		
            end
      end
  end    

int max_of_all_time;

initial
  begin
    max_of_all_time = 0;
    forever
      begin
<<<<<<< HEAD
      @( negedge clk )
=======
      @( posedge clk )
>>>>>>> FETCH_HEAD
        if( max_of_all_time < max_wait )
          begin
            max_of_all_time = max_wait;
          end
      end
  end

rr_top DUT(

  .clk_i         ( clk       ),
  .rst_i         ( rst       ),

  .req_i         ( req       ),
  .req_num_o     ( req_num   ),
  .req_num_val_o (           )

);
defparam DUT.REQCNT = REQCNT;

endmodule
