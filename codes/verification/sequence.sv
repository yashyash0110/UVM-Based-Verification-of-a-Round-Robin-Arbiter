//Sequences Class
class write_data extends uvm_sequence#(packet);
  `uvm_object_utils(write_data)
  
  packet pkt;
  
  function new(input string name = "write_data");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        pkt = packet::type_id::create("pkt");
        pkt.addr_c.constraint_mode(1);
        pkt.write_by_op_c.constraint_mode(1);

        start_item(pkt);
        pkt.op = WRITE;
        pkt.randomize();
        finish_item(pkt);
      end
  endtask
  
endclass

///////////////////////////////////////////////////////////

class read_data extends uvm_sequence#(packet);
  `uvm_object_utils(read_data)
  
  packet pkt;
  
  function new(input string name = "read_data");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        pkt = packet::type_id::create("pkt");
        pkt.addr_c.constraint_mode(1);
        pkt.write_by_op_c.constraint_mode(1);

        start_item(pkt);
        pkt.randomize();
        pkt.op = READ;
        finish_item(pkt);
      end
  endtask
  
endclass

///////////////////////////////////////////////////////////

class write_read extends uvm_sequence#(packet);
  `uvm_object_utils(write_read)
  
  packet pkt;
  
  function new(input string name = "write_read");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        pkt = packet::type_id::create("pkt");
        pkt.addr_c.constraint_mode(1);
        pkt.write_by_op_c.constraint_mode(1);
        
        start_item(pkt);
        pkt.randomize();
        pkt.op = WRITE;
        finish_item(pkt);
        
        start_item(pkt);
        pkt.randomize();
        pkt.op = READ;
        finish_item(pkt);
      end
  endtask
  
endclass

///////////////////////////////////////////////////////////

class write_read_random extends uvm_sequence#(packet);
  `uvm_object_utils(write_read_random)

  packet pkt;
  
  function new(input string name = "write_read_random");
    super.new(name);
  endfunction
  
  virtual task body();
    bit [3:0] pattern = 4'b0000;
    while(pattern < 16)
      begin
        pkt = packet::type_id::create("pkt");
        pkt.addr_c.constraint_mode(1);
        pkt.write_by_op_c.constraint_mode(0);
        
        start_item(pkt);
        foreach (pkt.master_in_data[i]) 
        begin
          pkt.master_in_data[i].write = pattern[i];
        end
    	finish_item(pkt);   
        pattern++;;
      end
  endtask
  
endclass

///////////////////////////////////////////////////////////

class reset_dut extends uvm_sequence#(packet);
  `uvm_object_utils(reset_dut)
  
  packet pkt;
  
  function new(input string name = "reset_dut");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        pkt = packet::type_id::create("pkt");
        pkt.addr_c.constraint_mode(1);
        pkt.write_by_op_c.constraint_mode(1);
        
        start_item(pkt);
        pkt.randomize();
        pkt.op = RESET;
        finish_item(pkt);
      end
  endtask
endclass
