class transaction;
  
  rand bit [4:0] ulen;
  bit [31:0] hwdata;
  rand bit [31:0] haddr;
  rand bit [2:0] hsize;
  rand bit [2:0] hburst;
  bit hresetn;
  rand bit hwrite;
  bit [1:0] htrans;
  bit [1:0] hresp;
  bit hready;
  bit [31:0] hrdata;  
  
  constraint haddr_c{
  	haddr == 5;
  }
  
  constraint hsize_c{
  	hsize == 3'b010;
  }
  ////BURST TYPE
  constraint hburst_c{
  	hburst == 3'b001;
  }

  constraint hwrite_c{
    hwrite dist {1:/50, 0:/50};
    //hwrite == 0;
  }
  
  constraint ulen_c {
    ulen == 5;
  }
  
  function transaction copy();
    copy = new();
    copy.hwdata = this.hwdata;
    copy.haddr = this.haddr;
    copy.hsize = this.hsize;
    copy.hburst = this.hburst;
    copy.hwrite = this.hwrite;
    copy.htrans = this.htrans;
    copy.hresp = this.hresp;
    copy.hready = this.hready;
    copy.hrdata = this.hrdata;
    copy.ulen = this.ulen;
  endfunction
  
 
endclass
