% Parameters
% Revenue per tank (USD)
int: revenue_light = 550;
int: revenue_nonsticky = 750;
int: revenue_heavy = 950;

% Compound availability (units)
int: avail_A = 250;
int: avail_B = 150;

% Compound requirements per tank (units)
int: reqA_light = 3;
int: reqB_light = 3;

int: reqA_nonsticky = 6;
int: reqB_nonsticky = 2;

int: reqA_heavy = 9;
int: reqB_heavy = 3;


% Variables
% Number of tanks processed (can be partial => continuous, non-negative)
var float: tanks_light;
var float: tanks_nonsticky;
var float: tanks_heavy;

% Total net revenue (objective variable)
var float: total_revenue;


% Constraints
% --- Non-negativity of decision variables (no negative processing) ---
constraint tanks_light >= 0.0;
constraint tanks_nonsticky >= 0.0;
constraint tanks_heavy >= 0.0;

% --- Compound A availability constraint ---
constraint
    float(reqA_light) * tanks_light
  + float(reqA_nonsticky) * tanks_nonsticky
  + float(reqA_heavy) * tanks_heavy
  <= float(avail_A);

% --- Compound B availability constraint ---
constraint
    float(reqB_light) * tanks_light
  + float(reqB_nonsticky) * tanks_nonsticky
  + float(reqB_heavy) * tanks_heavy
  <= float(avail_B);

% --- Define total revenue from processed tanks ---
constraint total_revenue =
    float(revenue_light) * tanks_light
  + float(revenue_nonsticky) * tanks_nonsticky
  + float(revenue_heavy) * tanks_heavy;


% Objective
solve maximize total_revenue;