% Parameters
% Global warming potential per tonne for each gas (embedded data)
int: gwp_CO2 = 4;
int: gwp_CH4 = 3;
int: gwp_N2O = 5;
int: gwp_CFC = 7;

% Constraint bounds (embedded data)
int: bound1 = 1000;  % CO2 + CH4 - 2*N2O - 2*CFC <= 1000
int: bound2 = 800;   % 3*CO2 - CH4 + N2O <= 800
int: bound3 = 200;   % CO2 - CH4 - N2O >= 200
int: bound4 = 1500;  % CO2 + CH4 + N2O + CFC <= 1500

% Simple upper bound for each emission variable (from total cap)
int: max_emission = bound4;

% Variables
% Emissions in tonnes (whole numbers, non-negative, bounded by total cap)
var 0..max_emission: CO2; % tonnes of Carbon Dioxide emitted
var 0..max_emission: CH4; % tonnes of Methane emitted
var 0..max_emission: N2O; % tonnes of Nitrous Oxide emitted
var 0..max_emission: CFC; % tonnes of Chlorofluorocarbons emitted

% Total global warming potential to minimize
var 0..(max_emission * (gwp_CO2 + gwp_CH4 + gwp_N2O + gwp_CFC)): total_gwp;

% Constraints
% Link total global warming potential to emissions and per-tonne GWP factors
constraint total_gwp =
  gwp_CO2 * CO2 + gwp_CH4 * CH4 + gwp_N2O * N2O + gwp_CFC * CFC;

% Constraint 1: CO2 + CH4 - 2*N2O - 2*CFC <= bound1
constraint CO2 + CH4 - 2 * N2O - 2 * CFC <= bound1;

% Constraint 2: 3*CO2 - CH4 + N2O <= bound2
constraint 3 * CO2 - CH4 + N2O <= bound2;

% Constraint 3: CO2 - CH4 - N2O >= bound3
constraint CO2 - CH4 - N2O >= bound3;

% Constraint 4: Total emissions cap CO2 + CH4 + N2O + CFC <= bound4
constraint CO2 + CH4 + N2O + CFC <= bound4;

% Objective
solve minimize total_gwp;