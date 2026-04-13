% Farm planning: maximize revenue from turnips and pumpkins

% Data (embedded from problem statement)
int: land = 500;                 % acres
int: water_avail = 40000;        % minutes
int: pesticide_avail = 34000;    % dollars

int: water_turnip = 50;          % minutes per acre
int: pest_turnip = 80;           % dollars per acre
int: rev_turnip = 300;           % dollars per acre

int: water_pumpkin = 90;         % minutes per acre
int: pest_pumpkin = 50;          % dollars per acre
int: rev_pumpkin = 450;          % dollars per acre

% Decision variables: acres to plant
var 0..land: turnips;
var 0..land: pumpkins;

% Resource constraints
constraint turnips + pumpkins <= land;
constraint water_turnip * turnips + water_pumpkin * pumpkins <= water_avail;
constraint pest_turnip * turnips + pest_pumpkin * pumpkins <= pesticide_avail;

% Objective: maximize total revenue
var int: revenue = rev_turnip * turnips + rev_pumpkin * pumpkins;
solve maximize revenue;

output [
  "Turnips acres = ", show(turnips), "\n",
  "Pumpkins acres = ", show(pumpkins), "\n",
  "Total revenue = $", show(revenue), "\n",
  "Water used = ", show(water_turnip * turnips + water_pumpkin * pumpkins), " / ", show(water_avail), " minutes\n",
  "Pesticide used = $", show(pest_turnip * turnips + pest_pumpkin * pumpkins), " / $", show(pesticide_avail), "\n",
  "Land used = ", show(turnips + pumpkins), " / ", show(land), " acres\n"
];