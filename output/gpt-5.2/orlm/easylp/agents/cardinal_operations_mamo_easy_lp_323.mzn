% Parameters
int: max_total_properties = 50;                 % Overall budget limit in number of properties

int: cost_residential = 10000;                  % Cost per residential property (X)
int: cost_commercial  = 15000;                  % Cost per commercial property (Y)
int: cost_industrial  = 20000;                  % Cost per industrial property (Z)

int: max_residential = 20;                      % Upper bound for residential properties
int: max_commercial  = 15;                      % Upper bound for commercial properties
int: max_industrial  = 25;                      % Upper bound for industrial properties

int: min_res_plus_com = 30;                     % Minimum total of residential + commercial
int: max_com_plus_ind = 40;                     % Maximum total of commercial + industrial


% Variables
var 0..max_residential: x_residential;          % Number of residential properties (X)
var 0..max_commercial:  y_commercial;           % Number of commercial properties (Y)
var 0..max_industrial:  z_industrial;           % Number of industrial properties (Z)

var 0..(cost_residential*max_residential
      + cost_commercial*max_commercial
      + cost_industrial*max_industrial): total_cost;  % Total investment cost (bounded)


% Constraints
%--- Total number of properties limited by overall budget (count-based) ---
constraint
  x_residential + y_commercial + z_industrial <= max_total_properties;

%--- Portfolio balance: residential at least twice commercial ---
constraint
  x_residential >= 2 * y_commercial;

%--- Minimum allocation to (residential + commercial) segment ---
constraint
  x_residential + y_commercial >= min_res_plus_com;

%--- Risk cap: (commercial + industrial) not exceeding limit ---
constraint
  y_commercial + z_industrial <= max_com_plus_ind;

%--- Define total investment cost from unit costs and quantities ---
constraint
  total_cost =
      cost_residential * x_residential
    + cost_commercial  * y_commercial
    + cost_industrial  * z_industrial;


% Objective
solve minimize total_cost;