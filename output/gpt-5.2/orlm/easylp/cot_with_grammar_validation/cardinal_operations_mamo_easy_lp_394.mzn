% Parameters
int: gwp_CO2 = 4;
int: gwp_CH4 = 3;
int: gwp_N2O = 5;
int: gwp_CFC = 7;

int: limit1 = 1000;
int: limit2 = 800;
int: limit3 = 200;
int: limit_total = 1500;

% Variables
var 0..limit_total: CO2;
var 0..limit_total: CH4;
var 0..limit_total: N2O;
var 0..limit_total: CFC;

var 0..(gwp_CO2*limit_total + gwp_CH4*limit_total + gwp_N2O*limit_total + gwp_CFC*limit_total): total_gwp;

% Constraints
constraint CO2 + CH4 - 2*N2O - 2*CFC <= limit1;
constraint 3*CO2 - CH4 + N2O <= limit2;
constraint CO2 - CH4 - N2O >= limit3;
constraint CO2 + CH4 + N2O + CFC <= limit_total;

constraint total_gwp = gwp_CO2*CO2 + gwp_CH4*CH4 + gwp_N2O*N2O + gwp_CFC*CFC;

% Objective
solve minimize total_gwp;