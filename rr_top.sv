//Descriprion: 
//  Р’С…РѕРґРЅС‹Рµ СЃРёРіРЅР°Р»С‹ - Р·Р°РїСЂРѕСЃС‹ Рё РёС… РІР°Р»РёРґРЅРѕСЃС‚СЊ.
//  Р’С‹С…РѕРґРЅС‹Рµ СЃРёРіРЅР°Р»С‹ - РЅРѕРјРµСЂ Р·Р°РїСЂРѕСЃР°, РєРѕС‚РѕСЂС‹Р№ Р±С‹Р» РІС‹Р±СЂР°РЅ Р°СЂР±РёС‚РµСЂРѕРј,
// РЅРѕРјРµСЂ РѕРїСЂРµРґРµР»СЏРµС‚СЃСЏ РґРµР№СЃС‚РІСѓСЋС‰РёРј РїСЂРёРѕСЂРёС‚РµС‚РѕРј, РµСЃР»Рё РїСЂРёРѕСЂРёС‚РµС‚РЅРѕРіРѕ Р·Р°РїСЂРѕСЃР° РЅРµС‚ - РїСЂРёРѕСЂРёС‚РµС‚ РЅРµ РјРµРЅСЏРµС‚СЃСЏ
// Рё РЅР° РІС‹С…РѕРґРµ - РЅРѕРјРµСЂ СЃС‚Р°СЂС€РµРіРѕ Р·Р°РїСЂРѕСЃР°.

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
  output logic [REQWIDTH-1:0] req_num_o,
  output logic                req_num_val_o

);

logic [REQWIDTH-1:0] prior_w;
logic [REQCNT-1:0] req_w;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        prior_w       <= '0;
        req_num_val_o <= '0;
      end
    else
      begin
        if( req_val_i )
          begin
            if( prior_w == REQCNT - 1 )
              begin
                prior_w <= 0;
              end
            else
              begin
                for( int i = 0; i < REQCNT; i ++ )
                  begin
                    if( ( i > req_num_o ) && ( req_i[ i ] ) )
                      begin
                        prior_w       <= i;
                        req_num_val_o <= '1;
                        i = REQCNT;
                      end
                  end
              end
          end
      end
  end

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        req_w <= '0;
      end
    else
      begin
        req_w <= req_i;
      end
  end
  
priority_coder pc(

  .clk_i       ( clk_i     ),
  .rst_i       ( rst_i     ),

  .data_i      ( req_w     ),
  .prior_i     ( prior_w   ),
  .data_num_o  ( req_num_o )

);
defparam pc.REQCNT = REQCNT;

endmodule

