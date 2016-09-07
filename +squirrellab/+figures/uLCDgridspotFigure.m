classdef uLCDgridspotFigure < symphonyui.core.FigureHandler
    
    properties (SetAccess = private)
        ampDevice
        prepts
        stmpts
        delaypts
        sequenceX
        sequenceY
        spotRadius
        nTrials
        
        coneCenter
        spots
        realCone
    end
    
    properties (Access = private)
        axesHandle
        currTrial
        Charge
        responseX
        responseY
    end
    
    methods
        
        function obj = uLCDgridspotFigure(ampDevice, varargin)
            obj.ampDevice = ampDevice;            
            ip = inputParser();
            ip.addParameter('prepts', [], @(x)isvector(x));
            ip.addParameter('stmpts', [], @(x)isvector(x));
            ip.addParameter('delaypts', [], @(x)isvector(x));
            ip.addParameter('sequenceX', [], @(x)isvector(x));
            ip.addParameter('sequenceY', [], @(x)isvector(x));
            ip.addParameter('currentX', [], @(x)isvector(x));
            ip.addParameter('currentY', [], @(x)isvector(x));
            ip.addParameter('spotRadius', [], @(x)isvector(x));
            ip.addParameter('nTrials', [], @(x)isvector(x));
            ip.parse(varargin{:});

            obj.prepts = ip.Results.prepts;
            obj.stmpts = ip.Results.stmpts;
            obj.delaypts = ip.Results.delaypts;
            obj.sequenceX = ip.Results.sequenceX;
            obj.sequenceY = ip.Results.sequenceY;
            obj.responseX = ip.Results.currentX;
            obj.responseY = ip.Results.currentY;
            obj.spotRadius = ip.Results.spotRadius;
            obj.nTrials = ip.Results.nTrials;

            obj.spots=gobjects(obj.nTrials,1);
            
            obj.currTrial = 0;
            obj.coneCenter = [];
            obj.Charge = zeros(1,obj.nTrials);
            
            obj.createUi();
        end
        
        function createUi(obj)
            import appbox.*;

            obj.axesHandle = axes( ...
                'Parent', obj.figureHandle, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'XTickMode', 'auto');
            xlabel(obj.axesHandle, 'x-direction (pixels)');
            ylabel(obj.axesHandle, 'y-direction (pixels)');
            title(obj.axesHandle,'Receptive Field');
            
            obj.coneCenter = util.drawCircle(114,115,1,obj.axesHandle);
            set(obj.coneCenter,'Color','k','linewidth',2);
            
            obj.realCone = util.drawCircle(114,115,1,obj.axesHandle);
            set(obj.realCone,'Color','r','linewidth',2);
            
            for i=1:obj.nTrials
                obj.spots(i)=util.drawCircle(obj.sequenceX(i),obj.sequenceY(i),obj.spotRadius,obj.axesHandle);
            end
            
        end

        function setTitle(obj, t)
            set(obj.figureHandle, 'Name', t);
            title(obj.axesHandle, t);
        end

        function clear(obj)
            cla(obj.axesHandle);
            obj.spots = [];
        end
        
        function handleEpoch(obj, epoch)
            %load amp data
            response = epoch.getResponse(obj.ampDevice);
            [epochResponse, units] = response.getData();
            sampleRate = response.sampleRate.quantityInBaseUnits;
            if numel(epochResponse) > 0
                tAx = (1:numel(epochResponse)) / sampleRate;
            else
                tAx = [];
            end
            
            epochResponse = epochResponse-mean(epochResponse(1:obj.prepts)); %baseline
            %take (prePts+1:prePts+stimPts+delayPts)
            epochResponseTrace = epochResponse(obj.prepts+1:(obj.prepts + obj.stmpts + obj.delaypts));
            tAxTrace = tAx(obj.prepts+1:(obj.prepts + obj.stmpts + obj.delaypts));
            %charge transfer
            currentCharge = trapz(tAxTrace,epochResponseTrace); %pC
            
            currentX = epoch.parameters('currentX');
            currentY = epoch.parameters('currentY');

            obj.currTrial = mod(obj.currTrial+1,obj.nTrials);
            if obj.currTrial==0
                obj.currTrial=obj.nTrials;
            end
            if obj.currTrial==1
                
            end
            obj.Charge(obj.currTrial) = currentCharge;
            obj.responseX(obj.currTrial) = currentX;
            obj.responseY(obj.currTrial) = currentY;
            
            colors=util.pmkmp(1001);%,'cubiclblack');
            currColor=NaN(obj.nTrials,1);
            for i=1:obj.nTrials
                currColor(i)=round(1000*(((obj.Charge(i)+abs(min(obj.Charge))))/max((obj.Charge+abs(min(obj.Charge))))))+1;
                set(obj.spots(i),'Color',colors(currColor(i),:))
            end
            
            rfx=sum(obj.sequenceX.*obj.Charge)/sum(obj.Charge);
            rfy=sum(obj.sequenceY.*obj.Charge)/sum(obj.Charge);
            
            [realConeX,realConeY]=util.drawCircleXY(rfx,rfy,1);
            set(obj.realCone,'XData',realConeX,'YData',realConeY);
        end
        
    end 
end
