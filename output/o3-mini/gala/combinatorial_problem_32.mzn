```mzn
include "globals.mzn";

% Parameters from input data
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of 0..1: participation;

% -------------------------------------------------------------------
% Derived parameters: For each day, count how many people participate.
%
% The following decision variable “participants” is fixed thanks to the
% count constraint below. (It computes the number of ones in each column.)
array[1..num_days] of var 0..num_people: participants;
constraint
  forall(d in 1..num_days) (
    count([ participation[p, d] | p in 1..num_people ], 1, participants[d])
  );

% -------------------------------------------------------------------
% Decision variables:
%
% For each day, choose a driver.
% We allow the value 0 to denote “no driver” on days when no one participates.
array[1..num_days] of var 0..num_people: driver;

% Link driver selection with participation: 
% If there are participants (participants[d] > 0) then the chosen driver must be one of them.
constraint
  forall(d in 1..num_days) (
    if participants[d] > 0 then
      participation[driver[d], d] = 1
    else
      driver[d] = 0
    endif
  );

% For each person, count the number of days on which they drive.
array[1..num_people] of var 0..num_days: drives;
constraint
  forall(p in 1..num_people)(
    drives[p] = sum(d in 1..num_days)( if driver[d] =