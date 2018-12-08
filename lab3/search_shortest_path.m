% Compute shortest path from start to goal in a graph
%
% Input:
% - V         : number of vertices
% - start     : vertex idx of start position
% - goal      : vertex idx of goal position
% - cost_func : cost function g, computes cost of edges between vertices
% - reachable : A cell array that lists per vertex all neighboring other vertices
%               i.e. reachable{i} is vector with vertex indices that can be reached from vertex i
%
% Output:
% - path      : list of vertices that defines the shortest path from start to
%               goal
% - info      : a struct with some information
%
function [path, info] = search_shortest_path(V, start, goal, reachable, cost_func)
    
    % initialize
    backpoint = nan(1, V);
    backpoint(start) = 0;

    costs = inf(1, V);
    costs(start) = 0;

    queued_idxs = [start]; % the "frontier"
    start_time = tic;

    % explore the graph until goal has been reached ...
    for iter = 1:(V*2)
        if isempty(queued_idxs)
            error('goal could not be reached');
        end
        
        % get next vertex to explore from frontier,
        % i.e. the vertex with lowest COST
        [~, j] = min(costs(queued_idxs)); % which of the available vertices has lowest score
        v = queued_idxs(j); % get its vertex idx
        queued_idxs(j) = []; % remove it from the list of available vertices
        
        % test: did we reach the goal?
        if v == goal
            % done
            break;
        end

        % find 'neighbors' of current vertex, i.e. those connected with an edge
        nidxs = reachable{v};
        nidxs = nidxs(:); % (ensure list of neighbor vertices is a column vector)
        
        % compute the distances and scores for the neighbors
        cost = costs(v); % distance of current vertices
        ncosts = cost + cost_func(v, nidxs); % distances for each neighbor

        % only keep neighbors for which we can improve their distance
        mask = ncosts' < costs(nidxs);
        nidxs = nidxs(mask);
        ncosts = ncosts(mask);
        
        % append neighbors to frontier
        queued_idxs = [queued_idxs; nidxs];

        % update values of neighbors in backpoint log
        backpoint(nidxs) = v; % update back pointing log
        costs(nidxs) = ncosts;
        
        % debug info
        if mod(iter, 10000) == 0
            % show some debug information
            show iter v cost
        end
    end

    % ------------------------------
    % Exercise 1.1
    % ------------------------------
    % Backtracking
    %   Now that the goal has been found, we can reconstruct the shortest
    %   path by backtracking from goal to start following the `backpoint'
    %   links.
    % 
    %  It performs the following steps:
    %   1. Initialize empty list, and set idx at goal vertex
    %   2. While idx not is 0 (the backpoint value for start) ...
    %       3. add idx to path
    %       4. update idx to backpoint(idx)
    %   5. If in step 3 each idx was appended to path, then the recovered 
    %      path currently moves from [goal, ..., start]. In that case
    %      reverse it such that it goes from [start, ..., goal].

    % Initialize
    v = goal;
    path = [];
    
    % Recursively follow the pointer to the shortest path
    % ----------------------
    %  YOUR CODE GOES HERE! 
    % ----------------------
    while v ~= 0
        v = backpoint(v);
        if v ~= 0   % Dont add 0 as the start, returns error in subscript
            path = [ v path ];
        end
    end

    % ok, done
    % optional: return info
    if nargout > 1
        duration = toc(start_time);
    
        info = struct;
        info.start = start;
        info.goal = goal;
        info.path_length = costs(goal);
        info.costs = costs;
        info.backpoint = backpoint;
        info.iterations = iter;
        info.duration = duration;
    end
end
