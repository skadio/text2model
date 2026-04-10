% Parameters
int: total_acres = 500;
int: water_available = 40000;        % minutes
int: pesticide_budget = 34000;       % dollars

int: water_turnips = 50;             % minutes per acre
int: water_pumpkins = 90;            % minutes per acre
int: pest_turnips = 80;              % dollars per acre
int: pest_pumpkins = 50;             % dollars per acre

int: rev_turnips = 300;              % dollars per acre
int: rev_pumpkins = 450;             % dollars per acre

% Variables
var 0..total_acres: acres_turnips;
var 0..total_acres: acres_pumpkins;

% Constraints
constraint acres_turnips + acres_pumpkins <= total_acres;

constraint water_turnips * acres_turnips + water_pumpkins * acres_pumpkins <= water_available;

constraint pest_turnips * acres_turnips + pest_pumpkins * acres_pumpkins <= pesticide_budget;

% Objective
solve maximize rev_turnips * acres_turnips + rev_pumpkins * acres_pumpkins;