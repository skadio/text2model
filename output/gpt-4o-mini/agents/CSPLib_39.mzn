include "globals.mzn";

int: num_pieces;                          % Number of pieces of music
int: num_players;                          % Number of players in the orchestra
array[1..num_pieces] of int: duration;    % Duration of each piece
array[1..num_players, 1..num_pieces] of int: rehearsal; % Players' availability for each piece

% Variables
array[1..num_pieces] of var 0..sum(duration): start; % Start times of each piece
array[1..num_pieces] of var 0..sum(duration): end;   % End times of each piece
array[1..num_players] of var 0..sum(duration): player_waiting; % Waiting time for each player

% Constraints
% Calculate end times based on start times and durations
constraint forall(i in 1..num_pieces)(
    end[i] = start[i] + duration[i]
);

% Calculate waiting time for each player
constraint forall(p in 1..num_players)(
    player_waiting[p] = sum(i in 1..num_pieces where rehearsal[p, i] == 1)(
        max(0, start[i] - (if i > 1 then end[i-1] else 0 endif))
    )
);

% Total waiting time
var 0..sum(player_waiting): total_waiting_time;
constraint total_waiting_time = sum(p in 1..num_players)(player_waiting[p]);

% Objective: Minimize total waiting time
solve minimize total_waiting_time;

% Output
output [ "Minimum Waiting Time = ", show(total_waiting_time), "\n" ];