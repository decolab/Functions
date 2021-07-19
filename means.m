function [] = means(C, h, sig)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



if sig(1) || sig(2)
    mc = nan(length(C), 1);
    i = nan(length(C), 1);
    for f = 1:length(C)
        [mc(f),i(f)] = max(h{C(f)}.BinCounts);
        mc(f) = mc(f)/sum(h{C(f)}.BinCounts);
    end

    mp{1} = mean([h{C(1)}.BinEdges(i(1):i(1)+1), h{C(2)}.BinEdges(i(2):i(2)+1)]);
    mp{2} = [mean(h{C(1)}.BinEdges(i(1):i(1)+1)), mean(h{C(2)}.BinEdges(i(2):i(2)+1))];

    if sig(1) && sig(2)
        for f = 1:length(C)
            mp{1} = mean([h{C(1)}.BinEdges(i(1):i(1)+1), h{C(2)}.BinEdges(i(2):i(2)+1)]);
            mp{2} = [mean(h{C(1)}.BinEdges(i(1):i(1)+1)), mean(h{C(2)}.BinEdges(i(2):i(2)+1))];
        end

        plot(mp{1}, 1.05*max(mc), '*g');
        plot(mp{2}, 1.02*[max(mc),max(mc)], '-g');
        plot(mp{2}(1), 1.02*[max(mc),max(mc)], '+g');
        plot(mp{2}(2), 1.02*[max(mc),max(mc)], '+g');
    elseif sig(2)
        plot(mp{1}, 1.05*max(mc), '*b');
        plot(mp{2}, 1.02*[max(mc),max(mc)], '-b');
        plot(mp{2}(1), 1.02*[max(mc),max(mc)], '+b');
        plot(mp{2}(2), 1.02*[max(mc),max(mc)], '+b');
    else
        plot(mp{1}, 1.05*max(mc), '*r');
        plot(mp{2}, 1.02*[max(mc),max(mc)], '-r');
        plot(mp{2}(1), 1.02*[max(mc),max(mc)], '+r');
        plot(mp{2}(2), 1.02*[max(mc),max(mc)], '+r');
    end
end


end

