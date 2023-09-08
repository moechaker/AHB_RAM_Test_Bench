class generator;
  
  mailbox #(transaction) mbxgd;
  mailbox #(bit [4:0]) mbxgm;
  event done, drvnext, sconext;
  
  transaction trans;
  
  int count;
  
  function new (mailbox #(transaction) mbxgd, event done, event drvnext, event sconext, int count, mailbox #(bit [4:0]) mbxgm);
    this.mbxgd = mbxgd;
    this.done = done;
    this.drvnext = drvnext;
    this.sconext = sconext;
    this.count = count;
    this.mbxgm = mbxgm;
    trans = new();
  endfunction
  
  task run();
    repeat(count) begin
      assert(trans.randomize) else $error("Randomization Failed!");
      $display("[GEN] hwrite: %0b haddr: %0d hwdata: %0d hburst: %0d hsize: %0d", trans.hwrite,trans.haddr, trans.hwdata, trans.hburst, trans.hsize);
      if(trans.hburst == 3'b001)
        $display("[GEN] LEN = %0d", trans.ulen);
      mbxgd.put(trans.copy);
      mbxgm.put(trans.ulen);
      @drvnext;
      @sconext;
    end
    -> done;
  endtask
  
endclass
