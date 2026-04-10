% Parameters (with values embedded)
int: profit_bagels = 20;
int: profit_croissants = 40;

int: oven_hours_available = 70;
int: chef_hours_available = 32;

int: oven_per_bagels = 2;
int: oven_per_croissants = 1;

float: chef_per_bagels = 0.25;
int: chef_per_croissants = 2;

% Scale to avoid fractions (multiply chef-time constraints by 4)
int: scale = 4;
int: chef_avail_scaled = chef_hours_available * scale;          % 128
int: chef_bagels_scaled = round(chef_per_bagels * scale);       % 1
int: chef_croissants_scaled = chef_per_croissants * scale;      % 8

% Variables
var 0..(oven_hours_available div oven_per_bagels): bagels;
var 0..(oven_hours_available div oven_per_croissants): croissants;

% Constraints
constraint oven_per_bagels * bagels + oven_per_croissants * croissants = oven_hours_available;
constraint chef_bagels_scaled * bagels + chef_croissants_scaled * croissants = chef_avail_scaled;

% Objective
var int: total_profit = profit_bagels * bagels + profit_croissants * croissants;
solve maximize total_profit;