`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

module tb;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  event done;
  event drvnext;
  event sconext;
  
  mailbox #(transaction) mbxgd;
  mailbox #(transaction) mbxms;
  mailbox #(bit [4:0]) mbxgm;
  
  int count = 3;
  
  ahb_if vif();
  ahb_slave dut(vif.clk,vif.hwdata,vif.haddr,vif.hsize,vif.hburst,vif.hresetn,vif.hsel,vif.hwrite,vif.htrans,vif.hresp,vif.hready,vif.hrdata);
  
  initial begin
    vif.clk <= 0;
  end
  
  always #5 vif.clk <= ~vif.clk;
  
  
  initial begin
    mbxgd = new();
    mbxms = new();
    mbxgm = new();
    
    gen = new(mbxgd,done,drvnext,sconext,count,mbxgm);
    drv = new(mbxgd,vif,drvnext);
    mon = new(vif,mbxms,mbxgm);
    sco = new(mbxms,sconext);
    
  end
    
  initial begin
    drv.reset();
    
    fork 
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
	
    wait(gen.done.triggered);
    $finish();
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end
  
  assign vif.next_addr = dut.next_addr;
  
endmodule