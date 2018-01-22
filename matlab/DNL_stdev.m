%DNL = zeros(1,1000*255);
max = 0;
for i = 1:1000
    a = DAC(1);
    %DNL((i-1)*255+1:i*255) = a.DNL;
    if a.DNL_stdev > max
        max = a.DNL_stdev;
    end
end

max