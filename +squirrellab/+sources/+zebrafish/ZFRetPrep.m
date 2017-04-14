classdef ZFRetPrep < symphonyui.core.persistent.descriptions.SourceDescription
    
    methods
        
        function obj = ZFRetPrep()
            import symphonyui.core.*;
            
            obj.addProperty('time', datestr(now), ...
                'type', PropertyType('char', 'row', 'datestr'), ...
                'description', 'Time the tissue was mounted');
            obj.addProperty('enucleatedBy', '', ...
                'type', PropertyType('char', 'row', {'', 'Angueyra', 'Chen', 'Kunze', 'Zhao', 'Ball', 'Li', 'Ou', 'Qiao'}), ...
                'description', 'LiLab member who performed enucleation of tissue');
            obj.addProperty('dissectedBy', '', ...
                'type', PropertyType('char', 'row', {'', 'Angueyra', 'Chen', 'Kunze', 'Zhao', 'Ball', 'Li', 'Ou', 'Qiao'}), ...
                'description', 'LiLab member who performed dissection of tissue');
            obj.addProperty('dissectionDate', datestr(now), ...
                'type', PropertyType('char', 'row', 'datestr'), ...
                'description', 'Time the tissue was dissected from subject');
            obj.addProperty('tissue', 'larvae (whole)', ...
                'type', PropertyType('char', 'row', {'larvae (whole)', 'eye (whole)', 'retina'}),...
                'description', 'experimental tissue');
            obj.addProperty('prep', '', ...
                'type', PropertyType('char', 'row', {'larvae', 'eye', 'whole mount cones', 'whole mount RGCs', 'slice', 'chop', 'dissociation', 'culture', ''}), ...
                'description', 'type of preparation');
            obj.addProperty('bathSolution', 'E3', ...
                'type', PropertyType('char', 'row', {'', 'E3', 'DMEM', 'Ringer', 'AmesBicarb', 'AmesHEPES', 'HibA'}), ...
                'description', 'The solution the tissue is bathed in during experiments');   
            obj.addProperty('storageSolution', 'E3', ...
                'type', PropertyType('char', 'row', {'', 'E3', 'DMEM', 'Ringer', 'AmesBicarb', 'AmesHEPES', 'HibA'}), ...
                'description', 'The solution the tissue is stored in');
            obj.addProperty('storageTemp', 'room temp', ...
                'type', PropertyType('char', 'row', {'', 'fridge', 'room temp', 'incubator', 'warm', 'body temp'}), ...
                'description', 'The temperature of the solution the tissue is stored in');
            obj.addProperty('eye', '', ...
    			'type', PropertyType('char', 'row', {'', 'left', 'right'}));
            obj.addProperty('region', {}, ...
    			'type', PropertyType('cellstr', 'row', {'superior', 'inferior', 'nasal', 'temporal'}));
            
            obj.addAllowableParentType('squirrellab.sources.zebrafish.Zebrafish');
        end
        
    end
    
end

