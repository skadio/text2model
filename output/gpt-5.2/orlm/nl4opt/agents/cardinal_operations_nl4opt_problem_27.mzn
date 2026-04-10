% Parameters
int: cool_low = 12;              % housing units cooled by one low-power AC
int: cool_high = 17;             % housing units cooled by one high-power AC
int: elec_low = 150;             % daily electricity used by one low-power AC
int: elec_high = 250;            % daily electricity used by one high-power AC

int: min_units = 250;            % minimum total housing units to be cooled
int: elec_available = 3400;      % total electricity available per day

float: max_low_fraction = 0.30;  % at most 30% of ACs can be low-power
int: min_high = 7;               % at least this many high-power ACs must be used

% Variables
var int: n_low;                  % number of low-power ACs to buy
var int: n_high;                 % number of high-power ACs to buy
var int: n_total;                % total number of ACs to buy

% Constraints

% --- Non-negativity and total definition ---
constraint n_low >= 0;
constraint n_high >= 0;

% Total number of ACs
constraint n_total = n_low + n_high;

% Ensure the fraction constraint is well-defined (redundant with min_high, but safe)
constraint n_total >= 1;

% --- Cooling capacity requirement ---
constraint cool_low * n_low + cool_high * n_high >= min_units;

% --- Electricity availability constraint ---
constraint elec_low * n_low + elec_high * n_high <= elec_available;

% --- Minimum number of high-power models ---
constraint n_high >= min_high;

% --- Limit fraction of low-power models (at most 30% of total) ---
% n_low / n_total <= 0.30  <=> 100*n_low <= 30*n_total
constraint 100 * n_low <= (round(max_low_fraction * 100.0)) * n_total;

% Objective
solve minimize n_total;