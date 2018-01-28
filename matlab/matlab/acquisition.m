
function acquisition = acq(R,C,Vmax,threshold)
    
    Vout = threshold ;
    
    acquisition = -1*R*C*log( Vout / Vmax ) ;
end