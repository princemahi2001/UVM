// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"

import uvm_pkg::*;

module top();
  
  our_interface intf();  //instantiated interface
  
  our_design uut();  //instantiated our design
  
  initial begin
    uvm_config_db #virtual(our_interface)::set(null,"*", "intf",intf);
  end
  
  initial begin
    run_test("our_test");
  end
  
endmodule


//class 

class our_test extends uvm_test;
  
  `uvm_component_utils(our_test);
  
  //instantiate classes
  our_env env;
  
  //constructor
  function new(string name = "our_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    
    //build other components
    //build env class here
    env = our_env::type_id::create("env",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
    //neccesary connections
  endfunction
  
  task run_phase(uvm_phase phase);
    
    //main logic
  endtask
  
  //main logic
  //methods
  //properties
  
endclass





class our_env extends uvm_env;
  `uvm_component_utils(our_env);
  
  our_agent agnt;
  
  function new(string name = "our_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    `uvm_info("ENV","In the build phase",UVM_MEDIUM);
    //build agent class
    agnt = our_agent::type_id::create("agnt",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
    //main logic 
    
  endtask
  
endclass: our_env






class our_agent extends uvm_agent;
  `uvm_component_utils(our_agent);
  
  our_sequencer seqr;
  our_driver driv;
  our_monitor mon;
  
  function new(string name = "our_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    
     //build sequencer,monitor,driver
     seqr=our_sequencer::type_id::create("seqr",this);
     driv = our_driver::type_id::create("driv",this);
     mon = our_monitor::type_id::create("mon",this);
     
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
    driv.seq_item_port.connect(seqr.seq_item_export);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
  endtask
  
endclass: our_agent






class our_sequencer extends uvm_sequencer #(our_packet);
  `uvm_component_utils(our_sequencer);
  
  function new(string name = "our_sequencer",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  
   function void build_phase(uvm_phase phase);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
  endtask
  
endclass: our_sequencer




class our_driver extends uvm_driver #(our_packet);
  `uvm_component_utils(our_driver)
  
  our_interface intf();
  our_packet pkt;
  
  function new(string name = "our_driver",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     
     pkt = our_packet::type_id::create("our_packet");
      uvm_config_db #virtual(our_interface)::get(null,"*", "intf",intf);
     
     
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
  endfunction
  
  task run_phase(uvm_phase phase);
     
    forever begin
      @(posedge intf.clk)
      
        seq_item_port.get_next_item(pkt);
      
        intf.input_1 <= pkt.input_1;
        intf.input_2 <= pkt.input_2;
        
      seq_item_port.item_done();  
      
    end
    
  endtask
  
endclass: our_driver





class our_monitor extends uvm_monitor;
  `uvm_component_utils(our_monitor);
  
  our_interface intf();
  our_packet pkt;
  
  uvm_analysis_port #(our_sequence_item) mon_port;
  
  function new(string name = "our_monitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    
     pkt = our_packet::type_id::create("our_packet");
     uvm_config_db #virtual(our_interface)::get(null,"*", "intf",intf);
     mon_port = new("Monitor Port",this);
     
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
    forever begin
      @(posedge intf.clk);
      pkt.input_1 <= intf.input_1;
      pkt.input_2 <= intf.input_2;
    end
    
  endtask
  
endclass: our_monitor



///objects classes 



class our_packet extends uvm_sequence_item;
  `uvm_object_utils(our_packet)
  
  
  //request
  rand bit[7:0] input_1;
  rand bit[7:0] input_2;
  
  //respond
  bit[15:0] output_3;
  
  
  function new(string name = "our_packet");
    super.new(name);
    
  endfunction
  
endclass




class our_sequence extends uvm_sequence;
  `uvm_object_utils(our_sequence)
  our_packet pkt;
  
  
  function new(string name = "our_sequence")
    super.new(name);
  endfunction
  
  task body();
    pkt = our_packet::type_id::create("our packet");
    
    repeat(10)
      begin
        start_item(pkt);
        pkt.randomize();
        finish_item(pkt);
      end
  endtask
  
endclass



interface our_interface(input logic clk);
  
  logic[7:0] input_1
  logic[7:0] input_2
  
  logic[15:0] output_3
  
endinterface
