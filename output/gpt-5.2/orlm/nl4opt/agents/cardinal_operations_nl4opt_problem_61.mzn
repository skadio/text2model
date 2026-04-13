% Parameters
% Printing rates (pages per minute per printer)
int: pages_premium = 30;
int: pages_regular = 20;

% Ink usage rates (ink units per minute per printer)
int: ink_premium = 4;
int: ink_regular = 3;

% Requirements
int: min_pages = 200;     % at least this many pages/min total
int: max_ink = 35;        % at most this many ink units/min total

% Derived safe upper bounds for decision variables
% (Using ink constraint: 4*p + 3*r <= 35 implies p <= floor(35/4)=8, r <= floor(35/3)=11)
int: max_premium = max_ink div ink_premium;
int: max_regular = max_ink div ink_regular;

% Variables
var 0..max_premium: num_premium;   % number of premium printers to buy
var 0..max_regular: num_regular;   % number of regular printers to buy

var 0..(max_premium + max_regular): total_printers; % total number of printers

% Constraints
% Total printers definition
constraint total_printers = num_premium + num_regular;

% Minimum total printing capacity (pages per minute)
constraint
  pages_premium * num_premium + pages_regular * num_regular >= min_pages;

% Maximum total ink usage (ink units per minute)
constraint
  ink_premium * num_premium + ink_regular * num_regular <= max_ink;

% User-friendliness requirement: regular printers fewer than premium printers
constraint
  num_regular < num_premium;

% Objective
solve minimize total_printers;