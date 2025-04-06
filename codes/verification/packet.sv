typedef enum bit [1:0] {READ=0,WRITE=1,RESET=2} oper_mode;

//Transaction or Packet or sequence item Class
class packet extends uvm_sequence_item;
  `uvm_object_utils(packet)
  
  rand oper_mode op;
  rand packet_in master_in_data [4];
  rand logic [3:0] REQ;
  
  rand logic [31:0] rdata;
  logic rdata_ack;
  
  //Ouput of Grant
  logic [3:0] GNT;
  
  //Output Signals of Arbiter - Sent to Memory
  packet_out master_out_data;
  
  //Output Signals of Arbiter - Sent to APB Slave
  logic [31:0] slave_rdata;
  logic slave_rdata_ack;
  
  constraint addr_c 
  {
    foreach (master_in_data[i]) 
    {
      master_in_data[i].addr inside {[32'h0000_0000 : 32'h7FFF_FFFF]};
      master_in_data[i].addr % 4 == 0;
    }
  }
      
  constraint write_by_op_c 
    {
      foreach (master_in_data[i]) 
      {
        if (op == WRITE)
          master_in_data[i].write == 1;
        else
          master_in_data[i].write == 0;
      }
   }
  
  function new(input string name = "packet");
    super.new(name);
  endfunction
  
endclass
