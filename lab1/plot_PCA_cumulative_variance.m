% Create a plot of cumulative variance in the PCA space
%  This plot will express the percentage of explained variance (y-axis)
%  as a function of the number of PCA components (x-axis)
function plot_PCA_cumulative_variance(pca_struct)

    % Use the 'variance' field of pca_struct to compute the cumulative
    % variance for each dimension, and plot it.
    % HINTS: look at the CUMSUM and PLOT functions
    % ----------------------
    Sum=max(cumsum(pca_struct.variance(1,:)));
    plot(1:length(pca_struct.variance(1,:)),100*(cumsum(pca_struct.variance(1,:)))/Sum)
    % ----------------------

    
    xlabel('# of PCA components');
    ylabel('Percentage of Explained Variance');
    grid on
    axis tight    
end