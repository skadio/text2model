% Parameters
% Resource requirements and production per reaction (embedded data)
int: gas_available = 1000;              % total units of rare inert gas available
int: water_available = 800;             % total units of treated water available

int: gas_req_A = 5;                     % gas units required per reaction A
int: water_req_A = 6;                   % water units required per reaction A
int: prod_A = 10;                       % compound units produced per reaction A

int: gas_req_B = 7;                     % gas units required per reaction B
int: water_req_B = 3;                   % water units required per reaction B
int: prod_B = 8;                        % compound units produced per reaction B


% Variables
var 0..(gas_available div gas_req_A): reactions_A;  % number of reaction A runs
var 0..(gas_available div gas_req_B): reactions_B;  % number of reaction B runs

var 0..(prod_A*(gas_available div gas_req_A) + prod_B*(gas_available div gas_req_B)): total_compound;
% total rare compound produced (safe upper bound based on gas-only maxima)


% Constraints
% Link total compound production to decision variables
constraint
  total_compound = prod_A * reactions_A + prod_B * reactions_B;

% Rare inert gas availability constraint
constraint
  gas_req_A * reactions_A + gas_req_B * reactions_B <= gas_available;

% Treated water availability constraint
constraint
  water_req_A * reactions_A + water_req_B * reactions_B <= water_available;


% Objective
solve maximize total_compound;