class driver;
  transaction trans;
  mailbox #(transaction) mbxgd;
  virtual ahb_if vif;
  event drvnext;
  
  function new (mailbox #(transaction) mbxgd, virtual ahb_if vif, event drvnext);
    this.mbxgd = mbxgd;
    this.vif = vif;
    this.drvnext = drvnext;
  endfunction
  
  task reset();
    vif.hresetn <= 1'b0;
    repeat(10) @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    $display("[DRV] RESET DONE!");
  endtask
  
  task single_tr_wr();
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= $urandom_range(1,100);
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    
    ->drvnext;
    
    $display("[DRV] Single Transfer Write: ADDR = %0d DATA = %0d",trans.haddr, vif.hwdata);
  endtask
  
  task single_tr_rd();
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= 0;
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    
    ->drvnext;
    
    $display("[DRV] Single Transfer Read: ADDR = %0d",trans.haddr);
  endtask
  
  task unspec_len_wr();
    
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= $urandom_range(1,100);
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Unspecified Length Transfer Write: ADDR = %0d DATA = %0d",trans.haddr, vif.hwdata);
    $display("[drv]  THIS IS TRANS LEN = %0d",trans.ulen);
    repeat(trans.ulen -1) begin
      
	  vif.hwdata <= $urandom_range(1,100);
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Unspecified Length Transfer Write: ADDR = %0d DATA = %0d",trans.haddr, vif.hwdata);
    end
    
    -> drvnext;
    
  endtask
  
  
  task unspec_len_rd();
    
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= 0;
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Unspecified Length Transfer Read: ADDR = %0d",trans.haddr);
    
    repeat(trans.ulen -1) begin
	  vif.hwdata <= 0;
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Unspecified Length Transfer Read: ADDR = %0d",trans.haddr);
    end
    
    -> drvnext;
    
  endtask
  
  task incr_wr(input int count);
    
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= $urandom_range(1,100);
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Increment %0d Transfer Write: ADDR = %0d DATA = %0d",count,trans.haddr, vif.hwdata);
    
    repeat(count-1) begin
	  vif.hwdata <= $urandom_range(1,100);
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Increment %0d Transfer Write: ADDR = %0d DATA = %0d",count, trans.haddr, vif.hwdata);
    end
    
    -> drvnext;
    
    
  endtask
  
  task incr_rd(input int count);
   
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= 0;
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Increment %0d Transfer Read: ADDR = %0d DATA = %0d",count,trans.haddr, vif.hwdata);
    
    repeat(count-1) begin
	  vif.hwdata <= 0;
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Increment %0d Transfer Read: ADDR = %0d DATA = %0d",count, trans.haddr, vif.hwdata);
    end
    
    -> drvnext;
    
    
  endtask
  
  task wrap_wr(input int count);
    
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= $urandom_range(1,100);
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Wrap %0d Transfer Write: ADDR = %0d DATA = %0d",count,trans.haddr, vif.hwdata);
    
    repeat(count-1) begin
	  vif.hwdata <= $urandom_range(1,100);
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Wrap %0d Transfer Write: ADDR = %0d DATA = %0d",count, trans.haddr, vif.hwdata);
    end
    
    -> drvnext;
    
  endtask
  
  task wrap_rd(input int count);
    
    @(posedge vif.clk);
    vif.hresetn <= 1'b1;
    vif.hwrite <= trans.hwrite;
    vif.hsel <= 1'b1;
    vif.hburst <= trans.hburst;
    vif.hsize <= trans.hsize;
    vif.haddr <= trans.haddr;
    vif.hwdata <= 0;
    vif.htrans <= 2'b00;
    
    @(posedge vif.hready);
    @(posedge vif.clk);
    $display("[DRV] Wrap %0d Transfer Read: ADDR = %0d DATA = %0d",count,trans.haddr, vif.hwdata);
    
    repeat(count-1) begin
	  vif.hwdata <= 0;
      vif.htrans <= 2'b01;
      @(posedge vif.hready);
      @(posedge vif.clk);
      $display("[DRV] Wrap %0d Transfer Read: ADDR = %0d DATA = %0d",count, trans.haddr, vif.hwdata);
    end
    
    -> drvnext;
    
    
  endtask
  
  task run();
    forever begin
      mbxgd.get(trans);
      if(trans.hwrite) begin
        case(trans.hburst)
          3'b000: single_tr_wr();
          3'b001: unspec_len_wr();
          3'b010: wrap_wr(4);
          3'b011: incr_wr(4);
          3'b100: wrap_wr(8);
          3'b101: incr_wr(8);
          3'b110: wrap_wr(16);
          3'b111: incr_wr(16);
        endcase
      end 
      else begin
        case(trans.hburst)
          3'b000: single_tr_rd();
          3'b001: unspec_len_rd();
          3'b010: wrap_rd(4);
          3'b011: incr_rd(4);
          3'b100: wrap_rd(8);
          3'b101: incr_rd(8);
          3'b110: wrap_rd(16);
          3'b111: incr_rd(16);
        endcase
      end
      
    end
  endtask
endclass
           
/*0b000 SINGLE Single transfer burst
0b001 INCR Incrementing burst of undefined length
0b010 WRAP4 4-beat wrapping burst
0b011 INCR4 4-beat incrementing burst
0b100 WRAP8 8-beat wrapping burst
0b101 INCR8 8-beat incrementing burst
0b110 WRAP16 16-beat wrapping burst
0b111 INCR16 16-beat incrementing burst*/
