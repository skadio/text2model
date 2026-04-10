% Parameters
% Unit costs per resource in each department (USD)
int: cost_X = 30;   % General Medicine
int: cost_Y = 20;   % Surgery
int: cost_Z = 40;   % Pediatrics
int: cost_W = 50;   % Geriatrics

% Constraint thresholds (resource units)
int: min_XY = 100;     % X + Y >= 100
int: max_ZW = 200;     % Z + W <= 200
int: min_XZ = 150;     % X + Z >= 150
int: max_diff_YW = 50; % |Y - W| <= 50

% Simple global bounds for decision variables (non-negative, integral resources)
int: max_units = 10000;

% Variables
var 0..max_units: X; % Resources allocated to General Medicine
var 0..max_units: Y; % Resources allocated to Surgery
var 0..max_units: Z; % Resources allocated to Pediatrics
var 0..max_units: W; % Resources allocated to Geriatrics

% Total cost (USD)
var 0..(max_units * (cost_X + cost_Y + cost_Z + cost_W)): total_cost;

% Constraints
% Service level constraint: General Medicine + Surgery must meet minimum coverage
constraint X + Y >= min_XY;

% Staffing constraint: Pediatrics + Geriatrics must not exceed available specialists
constraint Z + W <= max_ZW;

% Demand constraint: General Medicine + Pediatrics must meet minimum demand
constraint X + Z >= min_XZ;

% Balance constraint: Surgery and Geriatrics resources must be within allowed difference
constraint abs(Y - W) <= max_diff_YW;

% Total cost definition (linking decision variables to cost)
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z + cost_W * W;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "total_cost=", show(total_cost), "\n"
];