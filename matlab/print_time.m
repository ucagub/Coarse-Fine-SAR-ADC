function print_time(ts)
    %prints time
    buff = ts;
    hrs = floor(buff/3600);
    buff = buff - hrs*3600;
    min = floor(buff/60);
    buff = buff - min*60;
    sec = buff;
    
    fprintf('%d hours %d minutes %d sec remaining\n', hrs, min, sec);
end