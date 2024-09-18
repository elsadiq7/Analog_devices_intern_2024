package alu_env ;    
    import alu_drv ::* ;
    import alu_mnt ::* ;
    import alu_scb ::*; 

    class env;

        // Declare components
        driver d0;
        monitor m0;
        scoreboard s0;
        mailbox scb_mbx;
        virtual intf intf_env;

        // Constructor to instantiate all testbench components
        function new(virtual intf intf_env);
            this.intf_env = intf_env;
            d0 = new();
            m0 = new();
            s0 = new();
            scb_mbx = new();
        endfunction

        // Assign handles and start all components
        virtual task run();
            d0.intf_drv = intf_env;
            m0.intf_mon = intf_env;
            m0.mailbox_scb = scb_mbx;
            s0.scb_mbx = scb_mbx;

            fork
                s0.run();
                d0.run();
                m0.run();
            join_any
        endtask

    endclass
endpackage     