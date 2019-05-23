function[data, time, lat, lon, lev] = read_data(ti, tf, l1, l2, nameflag, dataflag, fpath, nlevels)
%
switch dataflag
    case 1                      % one data file (ncep)
        if (nameflag)
            name = 'hgt';
        end
        fname = fpath;
        [lat,lon,lev, time] = read_par_one(fname);
        level = findbin(l1,lev,0);
        [d] = get_one_file(ti, tf, level, name, fpath);
        if (nlevels)
            level = findbin(l2,lev,0);
            [d2] = get_one_file(ti, tf, level, name, fpath);
            d = d-d2;
        end
        data = d;
    case 2                      % monthly data files (waccm)
        if (nameflag)
            name = 'Z3';
        end
        fname = strcat(fpath,int2str(ti),'-', sprintf('%2.2i', 01), '.nc');
        [lat,lon,lev] = read_par_multi(fname);
        level = findbin(l1,lev,0);
        [d] = get_multi_file(ti, tf, level, name, fpath);
        if (nlevels)
            level = findbin(l2,lev,0);
            [d2] = get_multi_file(ti, tf, level, name, fpath);
            d = d-d2;
        end
        data = d;
        time = (ti+(1/24)):1/12:((tf+1)-(1/24));
end