% Parameters
int: gwp_CO2 = 4;
int: gwp_CH4 = 3;
int: gwp_N2O = 5;
int: gwp_CFC = 7;

int: rhs1 = 1000;
int: rhs2 = 800;
int: rhs3 = 200;
int: rhs4 = 1500;

% Variables
var 0..rhs4: CO2;
var 0..rhs4: CH4;
var 0..rhs4: N2O;
var 0..rhs4: CFC;

var 0..(gwp_CO2*rhs4 + gwp_CH4*rhs4 + gwp_N2O*rhs4 + gwp_CFC*rhs4): total_gwp;

% Constraints
constraint CO2 + CH4 - 2*N2O - 2*CFC <= rhs1;
constraint 3*CO2 - CH4 + N2O <= rhs2;
constraint CO2 - CH4 - N2O >= rhs3;
constraint CO2 + CH4 + N2O + CFC <= rhs4;

constraint total_gwp = gwp_CO2*CO2 + gwp_CH4*CH4 + gwp_N2O*N2O + gwp_CFC*CFC;

% Objective
solve minimize total_gwp;