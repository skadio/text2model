% Parameters
int: solar_cost = 7;              % Cost per solar project
int: wind_cost  = 5;              % Cost per wind project

int: a1_solar = 2;                % Coefficient of solar in constraint 1 (>=)
int: a1_wind  = 3;                % Coefficient of wind  in constraint 1 (>=)
int: rhs1     = 10;               % Right-hand side of constraint 1

int: a2_solar = 4;                % Coefficient of solar in constraint 2 (<=)
int: a2_wind  = 1;                % Coefficient of wind  in constraint 2 (<=)
int: rhs2     = 15;               % Right-hand side of constraint 2

% Variables
var 0..rhs2: solar_projects;      % Number of solar projects (nonnegative integer)
var 0..rhs2: wind_projects;       % Number of wind projects (nonnegative integer)

var int: total_cost;              % Total investment cost (to minimize)

% Constraints
% --- Total cost definition (linear expression) ---
constraint
  total_cost = solar_cost * solar_projects + wind_cost * wind_projects;

% --- Regulatory / mix requirement: 2*solar + 3*wind >= 10 ---
constraint
  a1_solar * solar_projects + a1_wind * wind_projects >= rhs1;

% --- Infrastructure / grid limitation: 4*solar + 1*wind <= 15 ---
constraint
  a2_solar * solar_projects + a2_wind * wind_projects <= rhs2;

% Objective
solve minimize total_cost;