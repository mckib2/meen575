classdef sequence < handle
    properties
        rf;
        xgrad;
        ygrad;
        zgrad;
        adc;
    end
    methods
        function [ obj ] = sequence(rf,xgrad,ygrad,zgrad,adc)
            obj.rf = rf;
            obj.xgrad = xgrad;
            obj.ygrad = ygrad;
            obj.zgrad = zgrad;
            obj.adc = adc;
        end
        
        function [ im ] = run(obj,mrobj)
            fprintf('Running...\n');
            
            % While there's more to do...
            more = 1; idx = 2;
            while more
                
                % ADC here
                
                try
                    % Get to the correct time
                    mrobj.precess(obj.rf(idx,1));
                    
                    % Fire the RF
                    mrobj.excite(obj.rf(idx,2))
                    idx = idx + 1;
                catch
                    more = 0;
                end
            end
            im = [];
        end
    end
end