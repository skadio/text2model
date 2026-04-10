% Ski lift planning problem (all data embedded)

% Data
int: cap_dense = 45;     % guests per minute
int: cap_loose = 20;

int: elec_dense = 30;    % electricity units
int: elec_loose = 22;

int: min_loose = 5;      % at least five loosely-seated lifts
int: req_capacity = 1000; % guests per minute required
int: elec_budget = 940;   % electricity available

% Decision variables
var 0..1000: dense;                 % number of densely-seated lifts
var min_loose..1000: loose;         % number of loosely-seated lifts

% Constraints
constraint cap_dense * dense + cap_loose * loose >= req_capacity;
constraint elec_dense * dense + elec_loose * loose <= elec_budget;

% Objective: minimize total number of lifts
var 0..2000: total = dense + loose;
solve minimize total;

output [
  "dense = ", show(dense), "\n",
  "loose = ", show(loose), "\n",
  "total = ", show(total), "\n",
  "capacity = ", show(cap_dense*dense + cap_loose*loose), " guests/min\n",
  "electricity = ", show(elec_dense*dense + elec_loose*loose), " units\n"
];