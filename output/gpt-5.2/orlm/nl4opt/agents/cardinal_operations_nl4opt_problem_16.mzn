% Parameters
% Time (in minutes) per unit of each chemical
int: time_per_unit_chlorine = 1;
int: time_per_unit_softener = 2;

% Policy/requirement parameters
int: min_chlorine_units = 200;      % at least this many units of chlorine
int: min_total_units = 500;         % at least this many total chemical units

% Derived safe bounds for decision variables
% From chlorine <= 0.5 * softener and chlorine >= 200 => softener >= 400
int: lb_chlorine = min_chlorine_units;
int: lb_softener = 2 * min_chlorine_units;

% Upper bounds: choose safe finite bounds based on feasibility and minimization.
% Since objective minimizes time with positive coefficients, optimal solutions won't exceed the minimum-feasible region.
int: ub_chlorine = min_total_units;        % safe cap
int: ub_softener = 2 * min_total_units;    % safe cap

% Variables
var lb_chlorine..ub_chlorine: chlorine_units;  % units of chlorine to add
var lb_softener..ub_softener: softener_units;  % units of water softener to add

% Indicates which chemical is added first (order note in problem statement)
% 1 = chlorine first, 2 = softener first (does not affect total time here)
var 1..2: add_order;

% Constraints
% Chemical safety ratio: chlorine must be at most half as much as softener
% Use integer-safe form to avoid fractional coefficients
constraint 2 * chlorine_units <= softener_units;

% Minimum required chlorine
constraint chlorine_units >= min_chlorine_units;

% Minimum total chemicals in the pool
constraint chlorine_units + softener_units >= min_total_units;

% Order requirement (either chlorine first or softener first)
% add_order domain already enforces this; included for clarity
constraint add_order = 1 \/ add_order = 2;

% Objective
solve minimize time_per_unit_chlorine * chlorine_units
            + time_per_unit_softener * softener_units;