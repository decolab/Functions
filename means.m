function [] = means(C, h, sig)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



if sig(1) || sig(2)
    
    % Allocate arrays
    mc = nan(length(C), 1);
    mp = nan(length(C), 1);
    i = nan(length(C), 1);
    
    % Get marker locations
    for f = 1:length(C)
        % Get marker heights
        [mc(f),i(f)] = max(h{C(f)}.BinCounts);
        mc(f) = mc(f)/sum(h{C(f)}.BinCounts);
        
        % Get means
        mp(f) = mean(h{C(f)}.Data);
    end
    
    % Plot markers
    if sig(1) && sig(2)
        plot(mean(mp), 1.05*max(mc), '*g');
        plot(mp, 1.02*max(mc)*ones(1,length(C)), '-g');
        scatter(mp, 1.02*max(mc)*ones(1,length(C)), '+g');
    elseif sig(2)
        plot(mean(mp), 1.05*max(mc), '*b');
        plot(mp, 1.02*max(mc)*ones(1,length(C)), '-b');
        scatter(mp, 1.02*max(mc)*ones(1,length(C)), '+b');
    else
        plot(mean(mp), 1.05*max(mc), '*r');
        plot(mp, 1.02*max(mc)*ones(1,length(C)), '-r');
        scatter(mp, 1.02*max(mc)*ones(1,length(C)), '+r');
    end
end
end

