% Parameters
% Unit generation costs ($/unit)
int: cost_coal    = 10;
int: cost_gas     = 15;
int: cost_nuclear = 20;
int: cost_solar   = 25;

% Policy/technical constraints
int: min_coal_plus_gas       = 400; % coal + gas >= 400
int: max_nuclear_solar_diff  = 100; % |nuclear - solar| <= 100
int: min_coal_minus_nuclear  = 200; % coal - nuclear >= 200
int: min_gas_plus_solar      = 500; % gas + solar >= 500


% Variables
% Integer generation units (non-negative)
var 0..100000: coal;     % units generated from coal
var 0..100000: gas;      % units generated from gas
var 0..100000: nuclear;  % units generated from nuclear
var 0..100000: solar;    % units generated from solar

% Total cost in dollars (integer since costs and units are integers)
var 0..1000000000: total_cost;


% Constraints
% --- Total cost definition ---
constraint total_cost =
    cost_coal    * coal
  + cost_gas     * gas
  + cost_nuclear * nuclear
  + cost_solar   * solar;

% --- Base load capacity: coal + gas minimum ---
constraint coal + gas >= min_coal_plus_gas;

% --- Balance policy: nuclear and solar difference bounded ---
constraint abs(nuclear - solar) <= max_nuclear_solar_diff;

% --- Resource availability: coal exceeds nuclear by at least a minimum ---
constraint coal - nuclear >= min_coal_minus_nuclear;

% --- Cleaner sources target: gas + solar minimum ---
constraint gas + solar >= min_gas_plus_solar;


% Objective
solve minimize total_cost;