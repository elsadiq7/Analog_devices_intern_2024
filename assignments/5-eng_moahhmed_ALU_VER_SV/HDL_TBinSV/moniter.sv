package alu_mnt ;    
    import trans  ::* ;
    class monitor;
        virtual intf intf_mon;
        event driver_done;
        mailbox mailbox_scb;

        task run();
            $display("T=%0t [monitor] starting ...", $time);

            forever begin

                
                Transaction_object packet = new() ;

                @(posedge   intf_mon.clk);
                #1
                // Declare and initialize the packet

                packet.reset_n = intf_mon.reset_n;
                packet.op_code = intf_mon.op_code;
                packet.A = intf_mon.A;
                packet.B = intf_mon.B;
                packet.C = intf_mon.C;
                packet.overflow = intf_mon.overflow;

                packet.print("monitor");
                mailbox_scb.put(packet);
            end
        endtask : run
    endclass : monitor
endpackage     