function [K] = plotSigComponent(entro, comps, z, memberships, groups, ROI, cortex, origin, cind, sn)
%	COMPONENTPLOT
% 


% Get bin sizes
d = squeeze(entro(:,comps));
sz = binWidth(d, 2);

% Scale memberships (optional)
if z.scale == true || sum(z.thresh ~= 0, 'all') > 0
    mships = squeeze(zscore(memberships));
else
    mships = squeeze(memberships);
end

% Enforce consensus: smaller community should be "positive"
if sum(sign(mships)) > 0
    mships = -mships;
end

% Plot component
if sum(z.thresh ~= 0, 'all') > 0
    for i = 1:numel(z.thresh)
        K = figure('Position', [0 0 1280 1024]);

        % Connectivity
        kax = subplot(2, 5, [9 10]); hold on;   % subplot(numel(h{e,s,t,c})*2, 5, [9 10]); hold on;
        sgtitle(['Component ', num2str(sn), ' ', groups{comps(1)}, ' vs. ', groups{comps(2)}], 'FontSize',18);
        a = squeeze(memberships)*squeeze(memberships)';
        imagesc(a); colorbar; hold on;
        set(kax, {'XLim','XTick','XTickLabel','FontSize','XTickLabelRotation'}, {[0.5 size(a,2)+0.5], 5:5:size(ROI,1), ROI{5:5:size(ROI,1),"Label"}, 6, -45});
        set(kax, {'YLim','YTick','YTickLabel','FontSize'}, {[0.6 size(a,2)+0.5], 5:5:size(ROI,1), ROI{5:5:size(ROI,1),"Label"}, 6});
%         xlim([1 size(a,2)]); xticks(5:5:size(ROI,1)); set(kax, 'XTickLabel',ROI{:,"Label"}, 6, 'XTickLabelRotation',-45);
%         ylim([1 size(a,1)]); yticks(5:5:size(ROI,1)); set(kax, 'YTickLabel',ROI{:,"Label"}, 'FontSize',6);
        title("Connectivity", 'FontSize',16); pbaspect([1 1 1]);

        % Histogram of component entropies
        kax = subplot(2, 5, [4 5]); hold on;	% subplot(numel(h{e,s,t,c})*2, 5, [4 5]); hold on;
        for f = 1:length(comps)
            d = entro(:, comps(:,f));
            d = d(isfinite(d));
            histogram(d, 'BinWidth',sz, 'Normalization','probability');
        end
        legend(groups(comps));
        title("Entropy", 'FontSize',16);
        ylabel('Probability'); xlabel('Mean Entropy');

        % Bar Plots
        kax = subplot(2, 5, [1 6]); hold on;    % subplot(numel(h{e,s,t,c})*2, 5, [1 6]); hold on;
        ind(:,1) = mships < -z.thresh(i);	% select node weights which surpass threshold
        ind(:,2) = mships > z.thresh(i); 	% select node weights which surpass threshold
        ind(:,3) = mships > -z.thresh(i) & mships < 0;
        ind(:,4) = mships < z.thresh(i) & mships > 0;
        a = mships; a(~ind(:,1)) = 0; barh(1:size(ROI,1), a, 'b');
        a = mships; a(~ind(:,2)) = 0; barh(1:size(ROI,1), a, 'r');
        a = mships; a(~ind(:,3)) = 0; barh(1:size(ROI,1), a, 'b', 'FaceAlpha',0.3);
        a = mships; a(~ind(:,4)) = 0; barh(1:size(ROI,1), a, 'r', 'FaceAlpha',0.3);
        yticks(1:size(ROI,1)); set(kax, 'YTickLabel',ROI{:,"Label"}, 'FontSize', 6);
        title("Component Membership", 'FontSize',16);                           % , 'Position',[0 93]);
        subtitle(['z-score threshold: ' num2str(z.thresh(i))], 'FontSize',12);   % , 'Position',[0 91]);
        xlabel('z-score', 'FontSize',12);

        % Brain Renderings
        kax = subplot(2, 5, [2 3 7 8]); hold on;  % subplot(numel(h{e,s,t,c})*2, 5, [2 3 7 8]); hold on;
        plot_nodes_in_cortex(cortex, mships, ROI{:,{'x','y','z'}}, origin, z.thresh(i), [], cind, [], []);
        % Note: if want to weight node color by strength of association, must encode weighting in cind.node
    end
else
    K = figure('Position', [0 0 1280 1024]);

    % Connectivity
    kax = subplot(2, 5, [9 10]); hold on;	% subplot(numel(h{e,s,t,c})*2, 5, [9 10]); hold on;
    sgtitle(['Component ', num2str(sn)], 'FontSize',18);
    a = squeeze(memberships)*squeeze(memberships)';
    imagesc(a); colorbar; hold on;
    xlim([1 size(a,2)]); ylim([1 size(a,1)]);
    yticks(5:5:size(ROI,1)); xticks(5:5:size(ROI,1));
    title("Connectivity", 'FontSize',16); pbaspect([1 1 1]);

    % Histogram of component entropies
    kax = subplot(2, 5, [4 5]); hold on;	% subplot(numel(h{e,s,t,c})*2, 5, [4 5]); hold on;
    histogram(entro(:, comps(1)), 'BinWidth',sz, 'Normalization','probability');
    histogram(entro(:, comps(2)), 'BinWidth',sz, 'Normalization','probability');
    legend(groups(comps));
    title("Entropy", 'FontSize',16);
    ylabel('Probability'); xlabel('Mean Entropy');

    % Membership Bar Plots
    kax = subplot(2, 5, [1 6]); hold on;	% subplot(numel(h{e,s,t,c})*2, 5, [1 6]); hold on;
    if sum(sign(squeeze(memberships))) >= 0
        ind(:,1) = (mships < 0);
        ind(:,2) = (mships > 0);
        a = mships; a(ind(:,1)) = 0; barh(1:size(ROI,1), a);
        a = mships; a(ind(:,2)) = 0; barh(1:size(ROI,1), a, 'r');
    elseif sum(squeeze(memberships)) < 0
        ind(:,1) = (mships > 0);
        ind(:,2) = (mships < 0);
        a = mships; a(ind(:,1)) = 0; barh(1:size(ROI,1), a);
        a = mships; a(ind(:,2)) = 0; barh(1:size(ROI,1), a, 'r');
    end
    yticks(1:size(ROI,1)); set(kax, 'YTickLabel',ROI{:,"Labels"}, 'FontSize', 6);
    title("Component Membership", 'FontSize',16, 'Position',[0 93]);
    subtitle(['z-score threshold: ' num2str(z.thresh)], 'FontSize',12, 'Position',[0 91]);
    xlabel('z-score', 'FontSize',12);

    % Brain Renderings
    kax = subplot(2, 5, [2 3 7 8]); hold on;	% subplot(numel(h{e,s,t,c})*2, 5, [2 3 7 8]); hold on;
    plot_nodes_in_cortex(cortex, mships, ROI{:,{'x','y','z'}}, origin, z.thresh, [], cind, [], []);
end

end

