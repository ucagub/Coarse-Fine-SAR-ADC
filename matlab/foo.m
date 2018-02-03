function y = foo(varargin)
    switch nargin
        case 1
            varargin(1)
        case 2
            varargin{1}
            varargin(2)
    end
end