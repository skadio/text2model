% Parameters
int: cool_low = 12;             % housing units cooled by one low-power AC
int: elec_low = 150;            % daily electricity used by one low-power AC
int: cool_high = 17;            % housing units cooled by one high-power AC
int: elec_high = 250;           % daily electricity used by one high-power AC

int: min_units = 250;           % minimum housing units to be cooled
int: elec_available = 3400;     % available daily electricity

float: max_low_fraction = 0.30; % at most 30% of all ACs can be low-power (embedded, not used directly)
int: min_high = 7;              % at least 7 high-power ACs must be used

% Variable bounds (safe upper bounds from electricity limit)
int: max_low = elec_available div elec_low;    % maximum possible low-power units
int: max_high = elec_available div elec_high;  % maximum possible high-power units

% Variables
var 0..max_low: n_low;                      % number of low-power air conditioners to buy
var 0..max_high: n_high;                    % number of high-power air conditioners to buy
var 0..(max_low + max_high): n_total;       % total number of air conditioners

% Constraints

% Link total number of ACs to decision variables
constraint
  n_total = n_low + n_high;

% Cooling capacity requirement (must cool at least the minimum housing units)
constraint
  cool_low * n_low + cool_high * n_high >= min_units;

% Electricity availability constraint (daily electricity used cannot exceed available)
constraint
  elec_low * n_low + elec_high * n_high <= elec_available;

% Minimum number of high-power units required
constraint
  n_high >= min_high;

% Aesthetic constraint: low-power units are at most 30% of total units
% Integer-safe form: n_low <= 0.30 * n_total  <=>  10*n_low <= 3*n_total
constraint
  10 * n_low <= 3 * n_total;

% Objective
solve minimize n_total;