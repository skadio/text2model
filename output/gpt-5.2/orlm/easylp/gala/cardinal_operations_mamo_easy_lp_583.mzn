include "globals.mzn";

% Budget allocations (whole-number units)
var 0..3000: Online_Ad;
var 0..2000: Offline_Ad;
var 0..1500: Social_Media_Ad;
var 0..1500: Email_Marketing;

% Budget (unit) constraints
constraint Online_Ad + Offline_Ad <= 5000;
constraint Social_Media_Ad + Email_Marketing <= 3000;

% Strategy requirements
constraint Online_Ad >= Offline_Ad + 1000;
constraint Social_Media_Ad >= Email_Marketing + 500;

% Total dollar cost
var int: total_cost =
  20 * Online_Ad +
  30 * Offline_Ad +
  10 * Social_Media_Ad +
  15 * Email_Marketing;

solve minimize total_cost;

output [
  "Online_Ad = ", show(Online_Ad), "\n",
  "Offline_Ad = ", show(Offline_Ad), "\n",
  "Social_Media_Ad = ", show(Social_Media_Ad), "\n",
  "Email_Marketing = ", show(Email_Marketing), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];