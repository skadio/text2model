% Parameters
int: n_investments = 5;                          % number of investment opportunities
set of int: INVEST = 1..n_investments;           % index set for investments

array[INVEST] of float: outflow_t0 = [11.0, 53.0, 5.0, 5.0, 29.0];  % cash outflow at time 0 (million $)
array[INVEST] of float: outflow_t1 = [3.0, 6.0, 5.0, 1.0, 34.0];    % cash outflow at time 1 (million $)
array[INVEST] of float: npv       = [13.0, 16.0, 16.0, 14.0, 39.0]; % NPV (million $)

float: budget_t0 = 40.0;                         % available funds at time 0 (million $)
float: budget_t1 = 20.0;                         % available funds at time 1 (million $)


% Variables
array[INVEST] of var 0.0..1.0: x;                % fraction purchased of each investment (0..1)

var 0.0..sum(i in INVEST)(npv[i]): total_npv;    % total NPV achieved (million $)


% Constraints
% Link objective variable to decision variables
constraint total_npv = sum(i in INVEST)(npv[i] * x[i]);

% Budget feasibility (unused time-0 funds cannot be carried to time 1 => separate constraints)
constraint sum(i in INVEST)(outflow_t0[i] * x[i]) <= budget_t0;
constraint sum(i in INVEST)(outflow_t1[i] * x[i]) <= budget_t1;


% Objective
solve maximize total_npv;