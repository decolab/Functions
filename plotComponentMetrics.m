function [F] = plotComponentMetrics(N, met, metName, comps, groups, sig, cind, amp, fDims, plotstyle)
%	PLOTCOMPONENTMETRICS adds metric comparisons in the same format as the 
% 
% Note: groups MUST be in row (1xN) format.  If the groups are in column
% format, the boxplot will mislabel the data.


%% Plot boxplots of metric for each component & each group

% Set default plot style
if isempty(plotstyle)
    plotstyle = 'traditional';
end

% Display boxplots: one per component
F(1) = figure('Position', fDims);
yl = nan(N,2);
for c = 1:N
	ax(c) = subplot(1, N, c); hold on;
    
    % Group variables
    a = squeeze(met(c,:,:));
    l = reshape(repmat(string(groups), [size(a,1) 1]), [numel(a) 1]);
    a = reshape(a, [numel(a) 1]);
    i = isfinite(a);
    a = a(i); l = l(i);
    
    % Display boxplot(s)
    boxplot(ax(c), a, l, 'Colors',cind.hist, 'Notch','on', 'PlotStyle',plotstyle); hold on
    title(num2str(c));
    
    % Get y-limits
    yl(c,:) = ylim(ax(c));
end
ylabel(ax(1), strjoin(["Subject",metName]));

% Add significance markers to relevant plots
a = nan(N, size(amp,2));
for c = 1:N
    if nnz(sig{c,:})
        xt = get(ax(c), 'XTick');
        yt = max(met(c,:,:),[],'all','omitnan');
        
        i = find(sig{c,:});
        a(c,:) = amp;
        for g = 1:numel(i)
            plot(ax(c), xt(comps(i(g),:)), [1 1]*yt*a(c,1), '-r',  mean(xt(comps(i(g),:))), yt*a(c,2), '*r');
            a(c,:) = a(c,:)+0.07;
        end
        a(c,3) = yt*a(c,3);
    end
end

% Set universal y-limits
yl = [min(yl(:,1)) max(yl(:,2))];
if yl(2) < max(a(:,3))
    yl(2) = max(a(:,3));
end
for c = 1:N
    ylim(ax(c), yl);
end


end

