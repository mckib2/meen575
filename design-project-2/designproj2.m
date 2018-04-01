%% Design Project
% Nicholas McKibben
% Laurel Hales
% MEEN 575
% 2018-03-26

clear;
close all;

%% Params
rng('default');
num_babies = 10;
mutrate = .3;
crossrate = .7;

%% Maken' babies
for ii = 1:num_babies
    babies(ii) = test_model( ...
        randi([ 1 3 ],1), ...
        randi([ 4 6 ],1), ...
        randi([ 7 9 ],1), ...
        randi([ 10 12 ],1), ...
        randi([ 13 15 ],1), ...
        randi([ 16 18 ],1));
end

[ next_gen ] = genalg(babies,mutrate,crossrate);