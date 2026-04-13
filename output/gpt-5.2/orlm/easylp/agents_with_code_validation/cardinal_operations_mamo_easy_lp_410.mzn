% Parameters
% Unit costs for each property type (residential, commercial, industrial, recreational)
int: cost_res = 5;
int: cost_com = 7;
int: cost_ind = 3;
int: cost_rec = 4;

% Global limits and RHS values
int: max_total_investment = 100;
int: diversification_min = 50;
int: market_eq = 75;

% Per-property maximum investment limits
int: max_res = 40;
int: max_com = 50;
int: max_ind = 30;
int: max_rec = 20;

% Coefficients for constraints
% Diversification constraint: x1 + 4*x2 + x3 + 2*x4 >= 50
int: div_c_res = 1;
int: div_c_com = 4;
int: div_c_ind = 1;
int: div_c_rec = 2;

% Market equality constraint: 3*x1 + x2 + 2*x3 + x4 = 75
int: eq_c_res = 3;
int: eq_c_com = 1;
int: eq_c_ind = 2;
int: eq_c_rec = 1;


% Variables
% Investments (must be whole numbers) with explicit bounds
var 0..max_res: x1; % residential
var 0..max_com: x2; % commercial
var 0..max_ind: x3; % industrial
var 0..max_rec: x4; % recreational

% Total cost (bounded using maximum possible cost given variable bounds)
var 0..(cost_res*max_res + cost_com*max_com + cost_ind*max_ind + cost_rec*max_rec): total_cost;


% Constraints
% Link total_cost to the weighted sum of investments and unit costs
constraint
  total_cost =
    cost_res * x1 +
    cost_com * x2 +
    cost_ind * x3 +
    cost_rec * x4;

% Budget constraint: total units invested across all property types cannot exceed limit
constraint
  x1 + x2 + x3 + x4 <= max_total_investment;

% Diversification constraint: enforce minimum weighted diversification level
constraint
  div_c_res * x1 +
  div_c_com * x2 +
  div_c_ind * x3 +
  div_c_rec * x4 >= diversification_min;

% Market equality constraint: enforce exact weighted market allocation requirement
constraint
  eq_c_res * x1 +
  eq_c_com * x2 +
  eq_c_ind * x3 +
  eq_c_rec * x4 = market_eq;


% Objective
solve minimize total_cost;