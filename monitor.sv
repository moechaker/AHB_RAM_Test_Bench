class monitor;
  
  virtual ahb_if vif;
  transaction trans;
  
  bit [4:0] len;
  
  mailbox #(transaction) mbxms;
  mailbox #(bit [4:0]) mbxgm;
  
  function new(virtual ahb_if vif, mailbox #(transaction) mbxms, mailbox #(bit [4:0]) mbxgm);
    this.vif = vif;
    this.mbxms = mbxms;
    this.mbxgm = mbxgm; 
  endfunction

  task single_tr_wr();
    @(posedge vif.hready);
    @(posedge vif.clk);
    trans.haddr = vif.haddr;
    trans.hwdata = vif.hwdata;
    trans.hwrite = vif.hwrite;
    mbxms.put(trans);
    @(posedge vif.clk);
    $display("[MON] Single Transfer Write: ADDR = %0d DATA = %0d",trans.haddr, trans.hwdata);

  endtask
  
  task single_tr_rd();
    @(posedge vif.hready);
    @(posedge vif.clk);
    trans.haddr = vif.haddr;
    trans.hrdata = vif.hrdata;
    trans.hwrite = vif.hwrite;
    mbxms.put(trans);
    @(posedge vif.clk);
    $display("[MON] Single Transfer Read: ADDR = %0d DATA = %0d",trans.haddr, trans.hrdata);

  endtask
  
  task unspec_len_wr();
    mbxgm.get(len);
    $display("[MON] LEN = %0d",len);
    repeat(len)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hwdata = vif.hwdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
      $display("[MON] Unspecified Length Transfer Write: ADDR = %0d DATA = %0d",trans.haddr, trans.hwdata);
      @(posedge vif.clk);
      

    end
  endtask
  
  task unspec_len_rd();
    mbxgm.get(len);
    $display("[MON] LEN = %0d",len);
    repeat(len)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hrdata = vif.hrdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
	  $display("[MON] Unspecified Length Transfer READ: ADDR = %0d DATA = %0d",trans.haddr, trans.hrdata);
      @(posedge vif.clk);
      

    end
  endtask
  
  task incr_wr(input int count);
    repeat(count)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hwdata = vif.hwdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
      $display("[MON] Increment %0d Transfer Write: ADDR = %0d DATA = %0d",count,trans.haddr, trans.hwdata);
      @(posedge vif.clk);
    end
    
  endtask
  
  task incr_rd(input int count);
    repeat(count)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hrdata = vif.hrdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
      @(posedge vif.clk);
      $display("[MON] Increment %0d Transfer Read: ADDR = %0d DATA = %0d",count,trans.haddr, trans.hrdata);      
    end
    
  endtask
  
  task wrap_wr(input int count);
    repeat(count)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hwdata = vif.hwdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
      @(posedge vif.clk);
      $display("[MON] Wrap %0d Transfer Write: ADDR = %0d DATA = %0d",count,trans.haddr, trans.hwdata);
    end
    
  endtask
  
  task wrap_rd(input int count);
    repeat(count)begin
      @(posedge vif.hready);
      @(posedge vif.clk);
      trans.haddr = vif.next_addr;
      trans.hrdata = vif.hrdata;
      trans.hwrite = vif.hwrite;
      mbxms.put(trans);
      @(posedge vif.clk);
      $display("[MON] Wrap %0d Transfer Read: ADDR = %0d DATA = %0d",count,trans.haddr, trans.hrdata);

    end
    
  endtask
  
  task run();
    trans = new();
    forever begin
      @(posedge vif.clk);
      if(vif.hresetn && vif.hsel && vif.hwrite) begin
        case(vif.hburst)
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
      
      if(vif.hresetn && vif.hsel && !vif.hwrite) begin
        case(vif.hburst)
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