% Parameters
int: cost_solar = 7;            % Cost per solar project
int: cost_wind  = 5;            % Cost per wind project

int: a1_solar = 2;              % Coefficient of solar in constraint 1
int: a1_wind  = 3;              % Coefficient of wind in constraint 1
int: rhs1_min = 10;             % Minimum required combined capacity in constraint 1

int: a2_solar = 4;              % Coefficient of solar in constraint 2
int: a2_wind  = 1;              % Coefficient of wind in constraint 2
int: rhs2_max = 15;             % Maximum allowed combined capacity in constraint 2


% Variables
% Upper bounds derived from the grid constraint 4*solar + wind <= 15:
% solar <= floor(15/4)=3, wind <= 15
var 0..(rhs2_max div a2_solar): solar_projects;   % # solar projects (nonnegative integer)
var 0..rhs2_max: wind_projects;                   % # wind projects (nonnegative integer)
var int: total_cost;                              % Total investment cost (objective helper)


% Constraints
% Link total_cost to the chosen numbers of projects
constraint
  total_cost = cost_solar * solar_projects + cost_wind * wind_projects;

% Regulatory/technical minimum mix requirement: 2*solar + 3*wind >= 10
constraint
  a1_solar * solar_projects + a1_wind * wind_projects >= rhs1_min;

% Infrastructure/grid capacity upper bound: 4*solar + 1*wind <= 15
constraint
  a2_solar * solar_projects + a2_wind * wind_projects <= rhs2_max;


% Objective
solve minimize total_cost;

% Optional output (includes the optimal total cost, which is already integral)
output [
  "solar_projects = ", show(solar_projects), "\n",
  "wind_projects  = ", show(wind_projects), "\n",
  "total_cost     = ", show(total_cost), "\n"
];