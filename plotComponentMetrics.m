function [F] = plotComponentMetrics(N, met, metName, comps, groups, sig, cind, amp, fDims, plotstyle)
%	PLOTCOMPONENTMETRICS adds metric comparisons in the same format as the 
% 


%% Plot boxplots of metric for each component & each group

% Set default plot style
if isempty(plotstyle)
    plotstyle = 'traditional';
end

% Display boxplots: one per component
F(1) = figure('Position', fDims);
for c = 1:N.IC
	ax(c) = subplot(1, N.IC, c); hold on;
    
    % Group variables
    a = squeeze(met(c,:,:));
    l = reshape(repmat(string(groups), [size(a,1) 1]), [numel(a) 1]);
    a = reshape(a, [numel(a) 1]);
    i = isfinite(a);
    a = a(i); l = l(i);
    
    % Display boxplot(s)
    boxplot(ax(c), a, l, 'Colors',cind.hist, 'Notch','on', 'PlotStyle',plotstyle); hold on
    title(num2str(c));
end
ylabel(ax(1), strjoin(["Subject",metName]));

% Add significance markers to relevant plots
for c = 1:N.IC
    if sig(c,:)
        xt = get(ax(c), 'XTick');
        yt = max(met(c,:,:),[],'all','omitnan');
        yl = ylim(ax(c));
        
        i = find(sig(c,:));
        for g = 1:numel(i)
            plot(ax(c), xt(comps(i(g),:)), [1 1]*yt*amp(1), '-r',  mean(xt(comps(i(g),:))), yt*amp(2), '*r');
            l = [yl(1) yl(2)*amp(3)];
            ylim(ax(c), l);
            amp = amp+0.03;
        end
    end
end


end

