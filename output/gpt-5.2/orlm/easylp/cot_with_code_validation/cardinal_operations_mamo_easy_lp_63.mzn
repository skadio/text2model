% Parameters
int: MAX_BW = 10000;
int: MIN_EFF = 5000;
int: effX = 2;
int: effY = 3;

% Scale costs to avoid floats: dollars = cost_cents / 100
int: costX_cents_per_Mbps = 20;  % $0.2
int: costY_cents_per_Mbps = 30;  % $0.3

% Variables
var 0..MAX_BW: x;  % Mbps allocated to service X (integer)
var 0..MAX_BW: y;  % Mbps allocated to service Y (integer)

var 0..(costY_cents_per_Mbps * MAX_BW): total_cost_cents;

% Constraints
constraint x + y <= MAX_BW;
constraint effX * x + effY * y >= MIN_EFF;

constraint total_cost_cents = costX_cents_per_Mbps * x + costY_cents_per_Mbps * y;

% Objective
solve minimize total_cost_cents;