% Parameters
int: gwp_CO2 = 4;
int: gwp_CH4 = 3;
int: gwp_N2O = 5;
int: gwp_CFC = 7;

int: max_c1 = 1000;
int: max_c2 = 800;
int: min_c3 = 200;
int: max_total = 1500;

% Variables
var 0..max_total: CO2;
var 0..max_total: CH4;
var 0..max_total: N2O;
var 0..max_total: CFC;

% Constraints
constraint CO2 + CH4 - 2*N2O - 2*CFC <= max_c1;
constraint 3*CO2 - CH4 + N2O <= max_c2;
constraint CO2 - CH4 - N2O >= min_c3;
constraint CO2 + CH4 + N2O + CFC <= max_total;

% Objective
solve minimize gwp_CO2*CO2 + gwp_CH4*CH4 + gwp_N2O*N2O + gwp_CFC*CFC;