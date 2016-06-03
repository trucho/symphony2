classdef NoAmp_2P < symphonyui.core.descriptions.RigDescription
    
    methods
        
        function obj = NoAmp_2P()
            import symphonyui.builtin.daqs.*;
            import symphonyui.builtin.devices.*;
            import symphonyui.core.*;
            
            daq = HekaDaqController();
            obj.daqController = daq;
            
%             amp1 = AxopatchDevice('Amp1').bindStream(daq.getStream('ANALOG_OUT.0'));
%             amp1.bindStream(daq.getStream('ANALOG_IN.0'), AxopatchDevice.SCALED_OUTPUT_STREAM_NAME);
%             amp1.bindStream(daq.getStream('ANALOG_IN.1'), AxopatchDevice.GAIN_TELEGRAPH_STREAM_NAME);
%             %missing frequency input here (is that the low pass filter?
%             %could be handled like temp (replace by single value)
%             amp1.bindStream(daq.getStream('ANALOG_IN.3'), AxopatchDevice.MODE_TELEGRAPH_STREAM_NAME);
%             obj.addDevice(amp1);
            
%             amp2 = AxopatchDevice('Amp2').bindStream(daq.getStream('ANALOG_OUT.1'));
%             amp2.bindStream(daq.getStream('ANALOG_IN.3'), AxopatchDevice.SCALED_OUTPUT_STREAM_NAME);
%             amp2.bindStream(daq.getStream('ANALOG_IN.4'), AxopatchDevice.GAIN_TELEGRAPH_STREAM_NAME);
%             amp2.bindStream(daq.getStream('ANALOG_IN.5'), AxopatchDevice.MODE_TELEGRAPH_STREAM_NAME);
%             obj.addDevice(amp2);
            

            frames = UnitConvertingDevice('Frames', symphonyui.core.Measurement.UNITLESS).bindStream(daq.getStream('DIGITAL_IN.0'));
            daq.getStream('DIGITAL_IN.0').setBitPosition(frames, 0);
            obj.addDevice(frames);

            mx405LED = UnitConvertingDevice('mx405LED', 'V').bindStream(daq.getStream('ANALOG_OUT.2'));
            mx405LED.addConfigurationSetting('ndfs', {}, ...
                'type', PropertyType('cellstr', 'row', {'0.3', '0.6', '1.2', '3.0', '4.0'}));
            mx405LED.addConfigurationSetting('gain', '', ...
                'type', PropertyType('char', 'row', {'', 'low', 'medium', 'high'}));
            obj.addDevice(mx405LED);
            
            mx590LED = UnitConvertingDevice('mx590LED', 'V').bindStream(daq.getStream('ANALOG_OUT.3'));
            mx590LED.addConfigurationSetting('ndfs', {}, ...
                'type', PropertyType('cellstr', 'row', {'0.3', '0.6', '1.2', '3.0', '4.0'}));
            mx590LED.addConfigurationSetting('gain', '', ...
                'type', PropertyType('char', 'row', {'', 'low', 'medium', 'high'}));
            obj.addDevice(mx590LED);
            
            trigger = UnitConvertingDevice('Trigger', symphonyui.core.Measurement.UNITLESS).bindStream(daq.getStream('DIGITAL_OUT.0'));
            daq.getStream('DIGITAL_OUT.0').setBitPosition(trigger, 0);
            obj.addDevice(trigger);
            
        end
        
    end
    
end