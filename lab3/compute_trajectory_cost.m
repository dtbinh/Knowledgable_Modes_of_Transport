% Evaluate a candidate trajectory by comparing each timestep
function [total_cost, costs_per_timestep] = compute_trajectory_cost(obstacle_states, states, lat_offset)

    % number of timesteps
    nsteps = min(numel(states), numel(obstacle_states));

    costs_per_timestep = NaN(1, nsteps);

    % compute cost for each time step
    for step = 1:nsteps
        % Here we can compute costs_per_timestep(step), e.g. based on the
        % distance between our vehicle state, states(step),
        % and the obstacle state, obstacle_states(step).
        % What do you think would be a good cost function?
        
        % ----------------------
        %  YOUR CODE GOES HERE! 
        % ----------------------
        % Combine both threshold and exponential cost in one
        veh_state = states(step);
        obs_state = obstacle_states(step);
        distance_threshold = 10;
        distance = sqrt((veh_state.x - obs_state.x)^2 + (veh_state.y - obs_state.y)^2);
        if distance <= distance_threshold
            costs_per_timestep(step) = 1/distance^2;% + exp(-distance);
        else
            costs_per_timestep(step) = 0;
        end
    end

    % Finally, we compute a single cost from the cost per timestep,
    %  and also a cost for the lateral offset.
    % Note that you might need to do some weighting of the different
    % cost terms to get the desired results, depending on how you define
    % the terms.
    
    % ----------------------
    %  YOUR CODE GOES HERE! 
    % ----------------------
    alpha = 750.0;
    distance_cost = mean(costs_per_timestep);
    lateral_cost = abs(lat_offset);
    total_cost = alpha*distance_cost + lateral_cost;
    
    assert(numel(costs_per_timestep) == nsteps)
    assert(numel(total_cost) == 1)
end



