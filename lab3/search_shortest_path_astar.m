% Compute shortest path from start to goal in a graph
%
% Input:
% - V         : number of vertices
% - start     : vertex idx of start position
% - goal      : vertex idx of goal position
% - cost_func : cost function g, computes cost of edges between vertices
% - hear_func : heuristic function h (optional)
% - reachable : A cell array that lists per vertex all neighboring other vertices
%               i.e. reachable{i} is vector with vertex indices that can be reached from vertex i
%
% Output:
% - path      : list of vertices that defines the shortest path from start to
%               goal
% - info      : a struct with some information
%
function [path, info] = search_shortest_path_astar(V, start, goal, reachable, cost_func, heur_func)
    
    % initialize
    backpoint = nan(1, V);
    backpoint(start) = 0;

    costs = inf(1, V);
    costs(start) = 0;
    heurs = zeros(1, V);
    scores = zeros(1, V);

    % Exercise 1.2: initialize heurs here 
    % ----------------------
    %  YOUR CODE GOES HERE! 
    % ----------------------
    heurs(start) = heur_func(start, goal);
    
    scores = costs + heurs;

    queued_idxs = [start]; % the "frontier"
    start_time = tic;

    % explore the graph until goal has been reached ...
    for iter = 1:(V*2)
        if isempty(queued_idxs)
            error('goal could not be reached');
        end
        
        % get next vertex to explore from frontier,
        % i.e. the vertex with lowest SCORE
        [~, j] = min(scores(queued_idxs)); % which of the available vertices has lowest score
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
        nheurs = zeros(size(ncosts)); % <-- DUMMY, should be altered
        nscores = ncosts; % <-- DUMMY, should be altered

        % Exercise 1.2: update the heuristics, scores for the neighbors here
        % ----------------------
        %  YOUR CODE GOES HERE! 
        % ----------------------
        nheurs = heur_func(nidxs, goal);    % Find heuristic from neighbors to goal
        nscores = ncosts + nheurs;          % Record neighbor scores as cost to reach + cost from neighbor to goal
        
        % only keep neighbors for which we can improve their distance
        mask = ncosts' < costs(nidxs);
        nidxs = nidxs(mask);
        ncosts = ncosts(mask);
        nheurs = nheurs(mask);
        nscores = nscores(mask);
        
        % append neighbors to frontier
        queued_idxs = [queued_idxs; nidxs];

        % update values of neighbors in backpoint log
        backpoint(nidxs) = v; % update back pointing log
        costs(nidxs) = ncosts;
        heurs(nidxs) = nheurs;
        scores(nidxs) = nscores;
        
        % debug info
        if mod(iter, 10000) == 0
            % show some debug information
            show iter v cost
        end
    end

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
    
    % Exercise 1.2: implement backtracking, as in exercise 1.1

    % Initialize
    v = goal;
    path = [];
    
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
        info.heurs = heurs;
        info.backpoint = backpoint;
        info.iterations = iter;
        info.duration = duration;
    end
end
