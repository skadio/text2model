% Pharmacy production optimization: minimize digestive medicine usage

% Decision variables
var int: painkillers;   % number of painkiller pills
var int: sleeping;      % number of sleeping pills

% Data (embedded)
int: morphine_available = 3000;  % mg
int: morphine_pain = 10;         % mg per painkiller
int: digest_pain = 3;            % units per painkiller
int: morphine_sleep = 6;         % mg per sleeping pill
int: digest_sleep = 5;           % units per sleeping pill
int: min_painkillers = 50;       % at least 50 painkillers

% Bounds (safe upper bounds from morphine constraint)
constraint painkillers >= 0 /\ sleeping >= 0;
constraint painkillers <= morphine_available div morphine_pain; % 300
constraint sleeping <= morphine_available div morphine_sleep;   % 500

% Morphine capacity
constraint morphine_pain * painkillers + morphine_sleep * sleeping <= morphine_available;

% Minimum painkillers
constraint painkillers >= min_painkillers;

% At least 70% of pills are sleeping:
% sleeping / (painkillers + sleeping) >= 0.7  ->  3*sleeping >= 7*painkillers
constraint 3 * sleeping >= 7 * painkillers;

% Objective: minimize total digestive medicine
var int: total_digestive = digest_pain * painkillers + digest_sleep * sleeping;
solve minimize total_digestive;

output [
  "painkillers = ", show(painkillers), "\n",
  "sleeping = ", show(sleeping), "\n",
  "total_pills = ", show(painkillers + sleeping), "\n",
  "morphine_used = ", show(morphine_pain * painkillers + morphine_sleep * sleeping), " mg\n",
  "digestive_used = ", show(total_digestive), " units\n"
];