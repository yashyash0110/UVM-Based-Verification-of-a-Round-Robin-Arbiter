//Driver Class
class driver extends uvm_driver#(packet);
  `uvm_component_utils(driver)
  
  packet pkt;
  virtual arb_intf arbif;
  
  function new(string name = "driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual arb_intf)::get(this,"","arbif",arbif))
      `uvm_error(get_type_name(),"Unable to access Interface")
    else
      `uvm_info(get_type_name(),"Successfully got access to Interface",UVM_MEDIUM)
  endfunction
  
  task reset_dut();
      begin
        arbif.REQ <= 4'b0000;
        foreach(arbif.master_in_data[i])
        begin
          arbif.master_in_data[i].wdata = 'h0;
          arbif.master_in_data[i].addr = 'h0;
          arbif.master_in_data[i].write = 'b0;
        end
        arbif.rdata <= 32'h0000_0000;
        arbif.rdata_ack <= 1'b0;
        `uvm_info(get_type_name(),"System Reset: Start of Simulation",UVM_MEDIUM)@(posedge clk);
      end
  endtask
  
  task drive();
    reset_dut();
    forever begin
      seq_item_port.get_next_item(pkt);
      
      if (pkt.op == RESET)
        begin
          reset <= 1'b0;
          @(posedge clk);
          reset <= 1'b1;
        end
      
      else if (pkt.op == WRITE)
        begin
          arbif.REQ <= pkt.REQ;
          foreach(pkt.master_in_data[i])
            begin
              arbif.master_in_data[i].wdata <= pkt.master_in_data[i].wdata;
              arbif.master_in_data[i].addr <= pkt.master_in_data[i].addr;
              arbif.master_in_data[i].write <= pkt.master_in_data[i].write;
              `uvm_info(get_type_name(),$sformatf("DATA WRITE wdata:%0h addr:%0h write:%0d",pkt.master_in_data[i].wdata,pkt.master_in_data[i].addr,pkt.master_in_data[i].write),UVM_MEDIUM)
            end
          @(posedge clk);
        end
      else if (pkt.op == READ)
        begin
          arbif.REQ <= pkt.REQ;
          foreach(pkt.master_in_data[i])
            begin
              arbif.master_in_data[i].addr <= pkt.master_in_data[i].addr;
              arbif.master_in_data[i].write <= pkt.master_in_data[i].write;
              `uvm_info(get_type_name(),$sformatf("DATA READ rdata:%0h addr:%0h ack:%0d write:%0d",pkt.rdata,pkt.master_in_data[i].addr,pkt.rdata_ack,pkt.master_in_data[i].write),UVM_MEDIUM);
            end
          arbif.rdata <= pkt.rdata;
          arbif.rdata_ack <= pkt.rdata_ack;
          @(posedge clk);
        end
      seq_item_port.item_done();
    end
  endtask
  
  virtual task run_phase(uvm_phase phase);
    drive();
  endtask
  
endclass
