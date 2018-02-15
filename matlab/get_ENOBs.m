function [mismatch, ENOBs] = get_ENOBs(iter,varargin)
    %inputs: iter number of simulations
    %      : res bit resolution, dac_type, mismatch in dac for adc to be characterized    
    %return: mismatch and ENOB counterpart

    buffy = zeros([1 iter]);
    buffx = rand([1 iter])*0.195 + 0.005;
    num_arg = nargin;
    if nargin == 4
        inputs.res = varargin{1};
        inputs.dac_type = varargin{2};
        inputs.mismatch = varargin{3};
    elseif nargin == 7
        inputs.res = varargin{1};
        inputs.k = varargin{2};
        inputs.coarse_dac_type = varargin{3};
        inputs.coarse_mismatch = varargin{4};
        inputs.fine_dac_type = varargin{5};
        inputs.fine_mismatch = varargin{6};
    end
    
    parfor j = 1:iter
    %for j = 1:iter
        %dac = DAC(8);
        %inputs.coarse_mismatch = buffx(j);
        %j
        if num_arg == 4
            adc = ADC(inputs.res, inputs.dac_type,  buffx(j));
        elseif num_arg == 7
            adc = ADC(inputs.res, inputs.k, inputs.coarse_dac_type, buffx(j), inputs.fine_dac_type, inputs.fine_mismatch);
        end
 
        buffy(j) = adc.ENOB;
        
    end
    mismatch = adc.coar;
    ENOBs = buffy;
end

