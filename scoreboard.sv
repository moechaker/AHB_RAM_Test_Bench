class scoreboard;
  transaction trans;
  mailbox #(transaction) mbxms;
  event sconext;
  
  bit [7:0] mem[256] = '{default : 12};
  
  bit [31:0] rdata;
  
  function new(mailbox #(transaction) mbxms, event sconext);
    this.mbxms = mbxms;
    this.sconext = sconext;
  endfunction
  
  task run();
    forever begin
      mbxms.get(trans);
      if(trans.hwrite) begin
        $display("[SCO] : DATA WRITE");
        mem[trans.haddr] = trans.hwdata[7:0];
        mem[trans.haddr + 1] = trans.hwdata[15:8];
        mem[trans.haddr + 2] = trans.hwdata[23:16];
        mem[trans.haddr + 3] = trans.hwdata[31:24]; 
        $display("===============================================");
      end 
      else begin
        rdata = {mem[trans.haddr+3] , mem[trans.haddr+2] , mem[trans.haddr+1] , mem[trans.haddr]};
        if(trans.hrdata == 32'h0c0c0c0c) begin
          $display("[SCO] : EMPTY LOCATION READ");
          $display("===============================================");
        end
        else if(trans.hrdata == rdata) begin
          $display("[SCO] : DATA MATCHED");
          $display("===============================================");
        end
        else begin
          $display("[SCO] : DATA MISMATCHED");
          $display("===============================================");
        end
      end
    
    ->sconext;
      
    end
  endtask
  
endclass