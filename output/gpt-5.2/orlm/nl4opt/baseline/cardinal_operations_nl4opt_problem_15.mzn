% Hospital patient transport scheduling (embedded data)

int: patients_needed = 320;

int: cap_ambulance = 20;
int: cap_van = 15;

int: cost_ambulance = 820;
int: cost_van = 550;

% Decision variables: number of shifts scheduled for each vehicle type
var 0..1000: amb_shifts;
var 0..1000: van_shifts;

% Meet or exceed patient transport requirement
constraint cap_ambulance * amb_shifts + cap_van * van_shifts >= patients_needed;

% At most 60% of shifts can be hospital vans:
% van_shifts <= 0.6 * (amb_shifts + van_shifts)
% Multiply by 10 to avoid fractions: 10*van <= 6*(amb+van) => 4*van <= 6*amb
constraint 4 * van_shifts <= 6 * amb_shifts;

% Objective: minimize total cost
var int: total_cost = cost_ambulance * amb_shifts + cost_van * van_shifts;

solve minimize total_cost;

output [
  "Ambulance shifts = ", show(amb_shifts), "\n",
  "Van shifts       = ", show(van_shifts), "\n",
  "Patients moved   = ", show(cap_ambulance * amb_shifts + cap_van * van_shifts), "\n",
  "Total cost       = $", show(total_cost), "\n"
];