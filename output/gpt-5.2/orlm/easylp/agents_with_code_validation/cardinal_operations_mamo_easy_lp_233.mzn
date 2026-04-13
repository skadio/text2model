% Parameters
int: cost_wheat   = 10;   % cost per acre for wheat
int: cost_corn    = 15;   % cost per acre for corn
int: cost_soybean = 20;   % cost per acre for soybean

int: max_wheat   = 400;   % upper bound (acres) for wheat
int: max_corn    = 200;   % upper bound (acres) for corn
int: max_soybean = 300;   % upper bound (acres) for soybean

int: rhs_2w_plus_c_max = 500;  % constraint: 2*wheat + corn <= 500
int: rhs_w_plus_s_min  = 300;  % constraint: wheat + soybean >= 300
int: max_diff_c_s      = 100;  % constraint: |corn - soybean| <= 100


% Variables
var 0..max_wheat: wheat_acres;       % acres planted with wheat (integer)
var 0..max_corn: corn_acres;         % acres planted with corn (integer)
var 0..max_soybean: soybean_acres;   % acres planted with soybean (integer)

var 0..(cost_wheat*max_wheat + cost_corn*max_corn + cost_soybean*max_soybean): total_cost;
% total planting cost (bounded from above by planting all crops at their max)


% Constraints
% Link total_cost to chosen acre allocations
constraint total_cost
  = cost_wheat * wheat_acres
  + cost_corn * corn_acres
  + cost_soybean * soybean_acres;

% Land-use constraint: twice wheat plus corn cannot exceed limit
constraint 2 * wheat_acres + corn_acres <= rhs_2w_plus_c_max;

% Minimum combined area for wheat and soybean
constraint wheat_acres + soybean_acres >= rhs_w_plus_s_min;

% Balance constraint: corn and soybean acreage difference capped
constraint abs(corn_acres - soybean_acres) <= max_diff_c_s;


% Objective
solve minimize total_cost;