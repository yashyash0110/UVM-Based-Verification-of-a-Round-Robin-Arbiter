//Test Class
class test extends uvm_test;
  `uvm_component_utils(test)
  
  env envmt;
  write_data sq1;
  read_data sq2;
  write_read sq3;
  write_read_random sq4;
  reset_dut sq5;
  
  function new(string name = "test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envmt = env::type_id::create("envmt",this);
    sq1 = write_data::type_id::create("sq1");
    sq2 = read_data::type_id::create("sq2");
    sq3 = write_read::type_id::create("sq3");
    sq4 = write_read_random::type_id::create("sq4");
    sq5 = reset_dut::type_id::create("sq5");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    sq1.start(envmt.agnt.seqr);
    #20;
    phase.drop_objection(this);
  endtask
  
endclass
