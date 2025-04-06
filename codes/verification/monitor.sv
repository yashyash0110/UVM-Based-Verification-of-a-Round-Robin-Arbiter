//Monitor Class
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  packet pkt;
  virtual arb_intf arbif;
  
  uvm_analysis_port #(packet) mon_port;
  
  function new(string name = "monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual arb_intf)::get(this,"","arbif",arbif))
      `uvm_error(get_type_name(),"Unable to access Interface")
    else
      `uvm_info(get_type_name(),"Successfully got access to Interface",UVM_MEDIUM)
    
    mon_port = new("Monitor Port",this);
  
  endfunction
    
  virtual task run_phase(uvm_phase phase);
    forever
      begin
        #20;
        if(!reset)
          begin
            pkt.op = RESET;
            `uvm_info(get_type_name(),"System Reset Detected",UVM_MEDIUM)
            mon_port.write(pkt);
          end
        else if (reset)
          begin
            pkt.REQ = arbif.REQ;
            foreach(arbif.master_in_data[i])
              pkt = packet::type_id::create("pkt",this);
              begin
                if(arbif.master_in_data[i].write) //WRITE
                  begin
                    pkt.op = WRITE;
                    pkt.master_in_data[i].wdata = arbif.master_in_data[i].wdata;
                    pkt.master_in_data[i].addr = arbif.master_in_data[i].addr;
                    pkt.master_in_data[i].write = arbif.master_in_data[i].write;
              		`uvm_info(get_type_name(),$sformatf("DATA WRITE wdata:%0h addr:%0h write:%0d",pkt.master_in_data[i].wdata,pkt.master_in_data[i].addr,pkt.master_in_data[i].write),UVM_MEDIUM)
                  end 
                else if(!(arbif.master_in_data[i].write)) //READ
                  begin
                    pkt.op = READ;
                    pkt.rdata = arbif.rdata;
                    pkt.rdata_ack = arbif.rdata_ack;
                    pkt.master_in_data[i].addr = arbif.master_in_data[i].addr;
                    pkt.master_in_data[i].write = arbif.master_in_data[i].write;
                    `uvm_info(get_type_name(),$sformatf("DATA READ rdata:%0h addr:%0h read_ack:%0d write:%0d",pkt.rdata,pkt.master_in_data[i].addr,pkt.rdata_ack,pkt.master_in_data[i].write),UVM_MEDIUM)
                  end
                mon_port.write(pkt);
              end
          end
      end
  endtask
endclass
