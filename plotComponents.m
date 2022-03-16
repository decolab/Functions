function [F] = plotComponents(memberships, thresh, ROI, cortex, origin, cind, N, fDims)
%	PLOTCOMPONENTS plots the spatial structure of each component 
% 


F(1) = figure('Position', fDims(1,:));
for k = 1:N.IC
    % Enforce consensus: smaller community should be "positive"
    if sum(sign(memberships)) > 0
        memberships(:,k) = -memberships(:,k);
    end
    
    % Plot component bar charts
    ax(k) = subplot(1, N.IC, k); hold on;
    ind(:,1) = memberships(:,k) < -thresh;	% select node weights which surpass threshold
    ind(:,2) = memberships(:,k) > thresh; 	% select node weights which surpass threshold
    ind(:,3) = memberships(:,k) < 0;
    ind(:,4) = memberships(:,k) > 0;
    a = memberships(:,k); a(~ind(:,1)) = 0; barh(1:N.ROI, a, 'b');
    a = memberships(:,k); a(~ind(:,2)) = 0; barh(1:N.ROI, a, 'r');
    a = memberships(:,k); a(~ind(:,3)) = 0; barh(1:N.ROI, a, 'b', 'FaceAlpha',0.3);
    a = memberships(:,k); a(~ind(:,4)) = 0; barh(1:N.ROI, a, 'r', 'FaceAlpha',0.3);
    set(ax(k), {'YTick'}, {[]});
    title(num2str(k));
end
xlabel(ax(N.IC/2+1), 'z-score', 'FontSize',12, 'HorizontalAlignment','right');
set(ax(1), {'YTick','YTickLabel','FontSize'}, {1:N.ROI, ROI{:,"Label"}, 7});
sgtitle("Component Spatial Maps", 'FontSize',14);


% Plot brain maps and connectivity matrices
for k = 1:N.IC
    F(k+1) = figure('Position', fDims(2,:));
    
    % Brain maps
    ax(1) = subplot(2, 1, 1); hold on;
    plot_nodes_in_cortex(cortex, memberships(:,k), ROI{:,{'x','y','z'}}, origin, thresh, [], cind, [], []);
    title("Cortical Connectivity");
    
    % Connectivity matrices
    ax(2) = subplot(2, 1, 2); hold on;
    a = zscore(squeeze(memberships(:,k))*squeeze(memberships(:,k))', 0, 'all');
    imagesc(a); colormap jet; colorbar; hold on;
    set(ax(2), {'XLim','XTick','XTickLabel','FontSize','XTickLabelRotation'}, {[0.5 N.ROI+0.5], 5:5:N.ROI, ROI{5:5:N.ROI,"Label"}, 7, -45});
    set(ax(2), {'YLim','YTick','YTickLabel','FontSize'}, {[0.6 N.ROI+0.5], 5:5:N.ROI, ROI{5:5:N.ROI,"Label"}, 7});
    title("Outer Product");
    pbaspect([1 1 1]);
    text('Position',N.ROI*[1.11 1.03], 'String',"z-score", 'Rotation',0, 'FontSize',7);
    
    % sgtitle(strjoin("Component", num2str(k)));
end

end

