function y = MSE(u)
    N = 10;
    Vref = 1;
    lsb = Vref/2^N;
    k = 7;
    y = (2^N - 2^k)*F1(u(1)) + (2^(N-1) - 2^k)*F2(u(1)) + (1 - kr(k,N-1))*(2^(N-2) - 2^k)*F3(u(1)) + (2^k - 1)*(F1(u(2)) + F2(u(2)) + F3(u(2)));
end

function y = F1(u)
    N = 10;
    Vref = 1;
    lsb = Vref/2^N;
    y = (1/2^(N-1))*(qfunc(lsb/u) + (u/(lsb*sqrt(2*pi)))*(1 - exp(-lsb^2/(2*u^2))));
end

function y = F2(u)
    N = 10;
    Vref = 1;
    lsb = Vref/2^N;
    y = (4/2^(N-1))*(2*qfunc(2*lsb/u) - qfunc(lsb/u) + (u/(lsb*sqrt(2*pi)))*(exp(-lsb^2/(2*u^2)) - exp(-2*lsb^2/(u^2))));
end

function y = F3(u)
    N = 10;
    Vref = 1;
    lsb = Vref/2^N;
    y = (9/2^(N-1))*(3*qfunc(3*lsb/u) - 2*qfunc(2*lsb/u) + (u/(lsb*sqrt(2*pi)))*(exp(-2*lsb^2/(u^2)) - exp(-9*lsb^2/(2*u^2))));
end

function y = kr(u, v)
    if u == v
        y = 1;
    else
        y = 0;
    end
end