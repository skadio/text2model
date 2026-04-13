% Parameters
int: cost_raw = 5;                       % Cost per unit of raw materials
int: cost_labor = 4;                     % Cost per unit of labor
int: cost_transport = 6;                 % Cost per unit of transportation

int: min_raw_minus_2labor = 500;         % raw - 2*labor >= 500
int: max_labor_plus_transport = 1000;    % labor + transport <= 1000
int: raw_minus_transport = 200;          % raw - transport = 200

% Variables
var int: raw;                            % Units of raw materials
var int: labor;                          % Units of labor
var int: transport;                      % Units of transportation
var int: total_cost;                     % Total cost to minimize

% Constraints

%-----------------------------
% Domain / feasibility bounds
%-----------------------------
constraint raw >= 0;
constraint labor >= 0;
constraint transport >= 0;

%-----------------------------------------
% Operational and strategic requirements
%-----------------------------------------
constraint raw - 2 * labor >= min_raw_minus_2labor;
constraint labor + transport <= max_labor_plus_transport;
constraint raw - transport = raw_minus_transport;

%-----------------------------
% Cost aggregation definition
%-----------------------------
constraint total_cost = cost_raw * raw + cost_labor * labor + cost_transport * transport;

% Objective
solve minimize total_cost;