% --------------------------------------------------------
% Intelligent Vehicles Lab Assignment
% --------------------------------------------------------
% Julian Kooij, Delft University of Technology

% clear the workspace
clear all;
close all;
clc;

% setup paths
startup_iv

%% load and visualize the route planning problem
% load Dutch road network, data obtained from 
%   http://www.cc.gatech.edu/dimacs10/archive/streets.shtml
%
% NOTE: this can take a moment the first time ...
clear data V E XT G
data_path = fullfile(IV_BASE_PATH, 'lab3_data/');
data = load(fullfile(data_path, '/netherlands-osm-road-network.mat'));

V = data.V;   % number of vertices
E = data.E;   % number of edges
XY = data.XY; % V x 2 matrix with the 2D locations of all V vertices
G = data.G;   % V x V sparse matrix defining the network graph structure:
              % G_i,j == 1 if vertices i en j are connected, 0 otherwise
reachable = data.reachable; % alternative network connectivity representation:
                            % reachable{i} contains list of all vertex
                            % indices that can be reached from vertex i          

%% display network graph
sfigure(1);
clf;
plot_network_graph(G, XY, '-', 'Color', [1 1 1] * .6, 'Tag', 'edge', 'DisplayName', 'roads');
axis equal
axis square
grid on
legend_by_displayname

%% Select the path planning problem
planning_problem_idx = 3; % <-- change this

switch planning_problem_idx
    case 1, start = 1; goal = 100400;   % shortest path:  42.912 km
    case 2, start = 1; goal = 1400;     % shortest path: 157.681 km
    case 3, start = 214e4; goal = 1600; % shortest path: 153.287 km
    case 4, start = 32e4; goal = 1600;  % shortest path: 169.112 km
    case 5, start = 205e4; goal = 4e3;  % shortest path: 369.078 km
    case 6, start = 4e3; goal = 205e4;  % shortest path: 369.078 km
end

% plot the goal and target position in the figure
sfigure(1);
hold all;
delete(findobj('Tag', 'path'));
delete(findobj('Tag', 'problem'));
plot(XY(start,1), XY(start,2), 'gd', 'MarkerFaceColor', 'g', 'MarkerSize', 8, 'Tag', 'problem', 'DisplayName', 'start');
plot(XY(goal,1), XY(goal,2), 'bd', 'MarkerFaceColor', 'b', 'MarkerSize', 8, 'Tag', 'problem', 'DisplayName', 'goal');
legend_by_displayname
drawnow

%% Exercise 1.1: graph-based path planning
% You will need to complete the code in
%    search_shortest_path.m

% Euclidean distance function between vertices
node_dist = @(idx1,idx2) ...
    sqrt( sum(bsxfun(@minus, XY(idx1,:), XY(idx2,:)).^2, 2) );

% perform graph search for shortest path
[path, info] = search_shortest_path(V, start, goal, reachable, node_dist);

% done, print some info
fprintf('\n');
fprintf('duration         : %.2f seconds\n', info.duration);
fprintf('iterations       : %d steps\n', info.iterations);
fprintf('length of path   : %.3f km\n', info.path_length/1000.);
fprintf('vertices in path : %d vertices\n', numel(path));

% plot optimal path
visited = ~isnan(info.backpoint);

sfigure(1);
hold all;
delete(findobj('Tag', 'path'));
plot(XY(visited,1), XY(visited,2), 'c.', 'Tag', 'path', 'DisplayName', 'explored vertices');
plot(XY(path,1), XY(path,2), 'r-', 'LineWidth', 2, 'Tag', 'path', 'DisplayName', 'shortest path');
legend_by_displayname

%% Exercise 1.2: graph-based path planning with A-star
% You will need to complete the code in
%    search_shortest_path_astar.m

% Euclidean distance function between vertices
node_dist = @(idx1,idx2) ...
    sqrt( sum(bsxfun(@minus, XY(idx1,:), XY(idx2,:)).^2, 2) );

% Use the Euclidean distance as the hueristic function for A-star
heur_func = node_dist;

% perform graph search for shortest path with A-star
[path, info] = search_shortest_path_astar(V, start, goal, reachable, node_dist, heur_func);

% done, print some info
fprintf('\n');
fprintf('duration         : %.2f seconds\n', info.duration);
fprintf('iterations       : %d steps\n', info.iterations);
fprintf('length of path   : %.3f km\n', info.path_length/1000.);
fprintf('vertices in path : %d vertices\n', numel(path));

% plot optimal path
visited = ~isnan(info.backpoint);

sfigure(1);
hold all;
delete(findobj('Tag', 'path'));
plot(XY(visited,1), XY(visited,2), 'c.', 'Tag', 'path', 'DisplayName', 'explored vertices');
plot(XY(path,1), XY(path,2), 'r-', 'LineWidth', 2, 'Tag', 'path', 'DisplayName', 'shortest path');
legend_by_displayname
