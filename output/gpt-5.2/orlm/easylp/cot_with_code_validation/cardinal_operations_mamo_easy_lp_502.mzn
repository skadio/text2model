% Parameters
int: max_props = 100;
int: min_res = 10;
int: min_com = 5;

int: cost_res = 50000;
int: cost_com = 70000;

int: roi_min = 30;          % 0.3*X + 0.4*Y >= 30
int: risk_max = 40;         % |0.5*X - 0.2*Y| <= 40

% Variables
var min_res..max_props: X;  % residential properties (integer)
var min_com..max_props: Y;  % commercial properties (integer)

var 0..(max_props*max(cost_res,cost_com)): total_cost;

% Constraints
constraint X + Y <= max_props;

% ROI constraint: 0.3X + 0.4Y >= 30  =>  3X + 4Y >= 300
constraint 3*X + 4*Y >= 10*roi_min;

% Risk diversification: |0.5X - 0.2Y| <= 40  =>  |5X - 2Y| <= 400
constraint abs(5*X - 2*Y) <= 10*risk_max;

constraint total_cost = cost_res*X + cost_com*Y;

% Objective
solve minimize total_cost;