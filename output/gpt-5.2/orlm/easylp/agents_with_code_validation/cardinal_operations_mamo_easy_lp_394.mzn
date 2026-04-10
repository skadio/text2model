% Parameters
set of int: G = 1..4;                      % Gases: 1=CO2, 2=CH4, 3=N2O, 4=CFC
array[G] of int: gwp = [4, 3, 5, 7];       % Global warming potential per tonne

int: rhs1 = 1000;                          % CO2 + CH4 - 2*N2O - 2*CFC <= 1000
int: rhs2 = 800;                           % 3*CO2 - CH4 + N2O <= 800
int: rhs3 = 200;                           % CO2 - CH4 - N2O >= 200
int: rhs4 = 1500;                          % CO2 + CH4 + N2O + CFC <= 1500

int: max_total_emissions = rhs4;           % Used to bound variables


% Variables
array[G] of var 0..max_total_emissions: e; % Emissions in tonnes (integers) for each gas
var 0..(max_total_emissions * max(gwp)): total_gwp; % Total global warming potential

% Named accessors for readability
var 0..max_total_emissions: co2 = e[1];
var 0..max_total_emissions: ch4 = e[2];
var 0..max_total_emissions: n2o = e[3];
var 0..max_total_emissions: cfc = e[4];


% Constraints
% Define total global warming potential
constraint total_gwp = sum(g in G)(gwp[g] * e[g]);

% Linear emission-balance constraints (given scenario requirements)
constraint co2 + ch4 - 2*n2o - 2*cfc <= rhs1;
constraint 3*co2 - ch4 + n2o <= rhs2;
constraint co2 - ch4 - n2o >= rhs3;

% Total emissions cap across all gases
constraint co2 + ch4 + n2o + cfc <= rhs4;


% Objective
solve minimize total_gwp;