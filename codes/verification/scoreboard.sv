//Scoreboard Class
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(packet,scoreboard) recv;
  
  function new(string name = "scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("Receiver Port",this);
  endfunction
  
  virtual function void write(packet pkt);
    if (pkt.op == RESET)
        `uvm_info(get_type_name(),"SYSTEM RESET DETECTED",UVM_MEDIUM)
    else if(pkt.op == WRITE)
      begin
        
      end
    else if(pkt.op == READ)
      begin
        
      end
      $display("-----------------------------------------------------------------");       
  endfunction
endclass
