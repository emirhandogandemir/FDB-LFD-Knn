function [popsize, dim, maxFEs, lb, ub] = problem_terminate()

    % Parameter settings:
    
    % population size
    popsize = 50;

    % problem dimension
    dim = 30;

    % number of maximum function evaluations
    maxFEs = 100 * dim ;

    % problem lowerbound 
    lowerBound = 0;
    lb = ones(1, dim) * lowerBound;

    % problem upperbound 
    upperBound = 1;
    ub = ones(1, dim) * upperBound;

end