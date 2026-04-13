% Marketing budget allocation - minimize total cost

int: TV_max = 700;
int: Radio_max = 600;
int: Social_max = 500;
int: Outdoor_max = 400;

% Integer allocations (whole numbers)
var 0..TV_max: TV;
var 0..Radio_max: Radio;
var 0..Social_max: Social;
var 0..Outdoor_max: Outdoor;

% Constraints
constraint TV + Radio >= 500;
constraint abs(Social - Radio) <= 200;
constraint Outdoor >= TV + 100;
constraint Social + Outdoor <= 800;

% Costs per unit effectiveness (in thousands)
% Use integer scaling (x100) to avoid floating inaccuracies.
% TV:0.5 -> 50, Radio:0.6 -> 60, Social:0.8 -> 80, Outdoor:1.2 -> 120
var int: total_cost_x100 =
    50 * TV + 60 * Radio + 80 * Social + 120 * Outdoor;

solve minimize total_cost_x100;

output [
  "TV = ", show(TV), "\n",
  "Radio = ", show(Radio), "\n",
  "Social = ", show(Social), "\n",
  "Outdoor = ", show(Outdoor), "\n",
  "Minimum total cost (thousands) = ",
  show(fix(total_cost_x100) / 100.0), "\n"
];