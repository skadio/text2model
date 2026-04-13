% Parameters
int: nAreas = 4;                                  % number of training areas
set of int: Areas = 1..nAreas;                    % index set for areas (1=x1,...,4=x4)

array[Areas] of int: cost_per_hour = [20, 30, 50, 60];  % costs for x1..x4

array[Areas] of int: lb = [0, 0, 0, 0];           % lower bounds for x1..x4
array[Areas] of int: ub = [15, 12, 10, 8];        % upper bounds for x1..x4


% Variables
array[Areas] of var int: x;                       % hours allocated to each area (integer hours)
var int: total_cost;                              % total cost (integer dollars)


% Constraints
% ---- Domain / bounds constraints ----
constraint
  forall(a in Areas) (
    lb[a] <= x[a] /\ x[a] <= ub[a]
  );

% ---- Training plan requirements ----
constraint x[1] + x[2] >= 5;                      % x1 + x2 at least 5 hours
constraint abs(x[3] - x[4]) <= 10;                % |x3 - x4| <= 10
constraint 2 * x[1] + 3 * x[2] - x[4] >= 8;       % 2*x1 + 3*x2 - x4 >= 8
constraint abs(x[1] - x[3]) <= 6;                 % |x1 - x3| <= 6

% ---- Cost definition ----
constraint
  total_cost = sum(a in Areas) (cost_per_hour[a] * x[a]);


% Objective
solve minimize total_cost;