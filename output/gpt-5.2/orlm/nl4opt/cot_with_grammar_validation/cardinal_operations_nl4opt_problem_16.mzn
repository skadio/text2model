% Parameters
int: min_chlorine = 200;
int: total_chemicals = 500;

int: time_chlorine = 1;      % minutes per unit
int: time_softener = 2;      % minutes per unit

% at most half as much chlorine as water softener: C <= 0.5 * S  <=>  2C <= S
int: ratio_num = 2;          % 2 * C
int: ratio_den = 1;          % <= 1 * S

% Variables
var 0..total_chemicals: C;   % units of chlorine
var 0..total_chemicals: S;   % units of water softener
var 0..(time_chlorine*total_chemicals + time_softener*total_chemicals): total_time;

% Constraints
constraint C + S = total_chemicals;
constraint C >= min_chlorine;

constraint ratio_num * C <= ratio_den * S;

constraint total_time = time_chlorine * C + time_softener * S;

% Objective
solve minimize total_time;