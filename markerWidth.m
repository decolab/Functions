function [mw] = markerWidth(ax)
%   MARKERWIDTH computes the appropriate width of the squares in a
% scatter/connectivity plot


currentunits = get(ax,'Units');
set(ax, {'Color', 'Units'}, {'k', 'Points'});
axpos = get(ax,'Position');
set(ax, 'Units', currentunits); hold on;
mw = 1/diff(xlim(ax(1)))*axpos(3);

end

