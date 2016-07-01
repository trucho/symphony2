classdef RigA_uLCDOneAmp < squirrellab.rigs.RigA_OneAmp
       
    methods
        
        function obj = RigA_uLCDOneAmp()
            import symphonyui.builtin.devices.*;
            
            uLCD = squirrellab.devices.uLCDDevice('serialPort', 'COM4');
            uLCD.connect;
            
            % Binding the uLCD to an unused stream only so its configuration settings are written to each epoch.
            daq = obj.daqController;
            uLCD.bindStream(daq.getStream('DIGITAL_OUT.3'));
            daq.getStream('DIGITAL_OUT.3').setBitPosition(uLCD, 15);
            
            obj.addDevice(uLCD);
        end
        
    end
end
    