% Parameters
int: shaping_time_thin = 50;          % minutes of shaping per thin jar
int: baking_time_thin  = 90;          % minutes of baking per thin jar
int: shaping_time_stubby = 30;        % minutes of shaping per stubby jar
int: baking_time_stubby  = 150;       % minutes of baking per stubby jar

int: shaping_minutes_available = 3000; % total shaping minutes available per week
int: baking_minutes_available  = 4000; % total baking minutes available per week

int: profit_thin = 5;                % profit per thin jar ($)
int: profit_stubby = 9;              % profit per stubby jar ($)

% Variables
var 0..(shaping_minutes_available div shaping_time_thin): thin_jars;       % number of thin jars to make
var 0..(shaping_minutes_available div shaping_time_stubby): stubby_jars;   % number of stubby jars to make

var int: total_profit;  % total weekly profit ($)

% Constraints
% Link total profit to decision variables
constraint
  total_profit = profit_thin * thin_jars + profit_stubby * stubby_jars;

% Shaping time capacity constraint (weekly limit)
constraint
  shaping_time_thin * thin_jars + shaping_time_stubby * stubby_jars
  <= shaping_minutes_available;

% Baking time capacity constraint (weekly limit)
constraint
  baking_time_thin * thin_jars + baking_time_stubby * stubby_jars
  <= baking_minutes_available;

% Objective
solve maximize total_profit;