function obj = TSCS_DAC(N, Cu, varargin)
    %inputs: N resolution, Cu unit cap, skipbits
    
    if nargin == 3
        skip_bits = varargin{1};
    elseif nargin == 2
        skip_bits = 0;
    end
    switch N
        case 3
            obj = multistep_CS_3bit(N, Cu);
        case 4
            obj = multistep_CS_4bit(N, Cu);
        case 5
            obj = multistep_CS_5bit(N, Cu);
        case 6
            obj = multistep_CS_6bit(N, Cu);
        case 7
            obj = multistep_CS_7bit(N, Cu);
        case 8
            obj = multistep_CS_8bit(N, Cu);
        case 9
            obj = multistep_CS_9bit(N, Cu);
        case 10
            obj = multistep_CS_10bit(N, Cu);
        case 11
            obj = multistep_CS_11bit(N, Cu);
        case 12
            obj = multistep_CS_12bit(N, Cu);
    end
    
    return 
end