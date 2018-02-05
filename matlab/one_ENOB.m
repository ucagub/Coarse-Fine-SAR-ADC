function output = one_ENOB(varargin)
    %inputs: iter number of simulations
    %      : res bit resolution, dac_type, mismatch in dac for adc to be characterized    
    %return: the mostlikely ENOB


    num_arg = nargin;
    if nargin == 3
        inputs.res = varargin{1};
        inputs.dac_type = varargin{2};
        inputs.mismatch = varargin{3};
    elseif nargin == 6
        inputs.res = varargin{1};
        inputs.k = varargin{2};
        inputs.coarse_dac_type = varargin{3};
        inputs.coarse_mismatch = varargin{4};
        inputs.fine_dac_type = varargin{5};
        inputs.fine_mismatch = varargin{6};
    end
    


    if num_arg == 3
        adc = ADC(inputs.res, inputs.dac_type, inputs.mismatch);
        %adc
    elseif num_arg == 6
        adc = ADC(inputs.res, inputs.k, inputs.coarse_dac_type, inputs.coarse_mismatch, inputs.fine_dac_type, inputs.fine_mismatch);
    end
        
        fs = 3.15e4;
        f0 = 5e2;
        N = 1024*2;
        t = (0:N-1)/fs;

        y = 0.5*sin(2*pi*f0*t) + 0.5;
        z = zeros(1, length(y));
        for i = 1:length(y)
            z(i) = adc.quantizer(y(i));
        end
        %figure;
        %sinad(z,fs)
        b = sinad(z,fs);
        ENOB = (b-1.76)/6.02; 


%     if num_arg == 4
%         figure('Name', [int2str(inputs.res) '_' inputs.dac_type '_' num2str(inputs.mismatch)]);
%     elseif num_arg == 7
%         figure('Name', [int2str(inputs.k) '_' inputs.coarse_dac_type '_' num2str(inputs.coarse_mismatch)]);
%     end
    
    %h = histogram(buff, 'Normalization', 'pdf');
    %xlabel('ENOB');
    %ylabel('pdf');
    %savefig(['ENOB_hist/8bit_multistep_CS/' int2str(res) '_' dac_type '_' num2str(mismatch) '.fig']);
    %left_edge = find(h.Values == max(h.Values));
    %buff2 = mean(h.BinEdges(left_edge:left_edge+1));
    %close
    output = ENOB;
end