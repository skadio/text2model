% Lighting fixture mix optimization (all data embedded)

include "globals.mzn";

% Parameters (from the problem statement)
int: led_elec = 5;          % electricity units per hour
int: flu_elec = 8;

int: led_changes = 3;       % changes per decade (per fixture)
int: flu_changes = 4;

int: min_total = 300;       % at least 300 fixtures
int: max_electricity = 2000;

int: min_flu_percent = 30;  % at least 30% fluorescent

% Decision variables: number of each installed
var 0..min_total: led;
var 0..min_total: flu;

% Total fixtures
var min_total..min_total: total = led + flu; % enforce exactly min_total via domain

% Electricity budget
constraint led_elec * led + flu_elec * flu <= max_electricity;

% At least 30% fluorescent: flu / total >= 0.30  => 100*flu >= 30*total
constraint 100 * flu >= min_flu_percent * total;

% Objective: minimize total number of light changes per decade
var 0..(max(led_changes, flu_changes) * min_total): total_changes =
  led_changes * led + flu_changes * flu;

solve minimize total_changes;

output [
  "LED fixtures = ", show(led), "\n",
  "Fluorescent fixtures = ", show(flu), "\n",
  "Total fixtures = ", show(total), "\n",
  "Electricity used = ", show(led_elec*led + flu_elec*flu), " (<= ", show(max_electricity), ")\n",
  "Fluorescent share = ", show(100*flu div total), "%\n",
  "Total changes/decade = ", show(total_changes), "\n"
];