classdef (Abstract) iSquirrelLabProtocol < symphonyui.core.Protocol
    % Protocol for integration of two-photon imaging with Symphony2
    % Will create frame monitor, trigger to start imaging and record temperature 
    methods
        
        function prepareEpoch(obj, epoch)
            prepareEpoch@symphonyui.core.Protocol(obj, epoch);

            % add remperature controller monitor
            T5Controller = obj.rig.getDevices('T5Controller');
            if ~isempty(T5Controller)
                epoch.addResponse(T5Controller{1});
            end
        end
        
        function completeEpoch(obj, epoch)
            completeEpoch@symphonyui.core.Protocol(obj, epoch);
            keyboard
%             % remove trigger stimulus
%             trigger=obj.rig.getDevices('Trigger');
%             epoch.removeStimulus(trigger);
            
            %condense temperature measurement into single value
            T5Controller = obj.rig.getDevices('T5Controller');
            if ~isempty(T5Controller) && epoch.hasResponse(T5Controller{1})
                response = epoch.getResponse(T5Controller{1});
                [quantities, units] = response.getData();
                if ~strcmp(units, 'V')
                    error('T5 Temperature Controller must be in volts');
                end
                
                % Temperature readout from Bioptechs Delta T4/T5 Culture dish controllers is 100 mV/degree C.
                temperature = mean(quantities) * 1000 * (1/100);
                temperature = round(temperature * 10) / 10;
                epoch.addParameter('dishTemperature', temperature);
                fprintf('Temp = %2.2g C\n', temperature)
                epoch.removeResponse(T5Controller{1});
            end
        end
        
    end
    
end

