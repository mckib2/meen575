%% Homework 4 - Computing Derivatives
% Nicholas McKibben
% MEEn 575
% 2018-02-21

clear;
close all;

% ------------Starting point and bounds------------
%design variables
% x0 = [ 5 5 5 5 5 5 5 5 5 5 ]; 
x0 = ones(1,10)*5; % starting point (all areas = 5 in^2)
% lb = [ 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 ]; %lower bound
lb = ones(1,10)*.1; % lower bound
% ub = [ 20 20 20 20 20 20 20 20 20 20 ]; %upper bound
ub = ones(1,10)*20; % upper bound

% Keep track of how many function calls we make
global nfun;
nfun = 0;

% ------------Linear constraints------------
A = [];
b = [];
Aeq = [];
beq = [];

% ------------Call fmincon------------
tic;
options = optimoptions(@fmincon, ...
    'display','iter-detailed', ...
    'Diagnostics','on');

[xopt,fopt,exitflag,output] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);  
eltime = toc;
fprintf('Took %f s to run\n',eltime);

% disp(table(xopt,

xopt    %design variables at the minimum
fopt    %objective function value at the minumum
[f,c,ceq] = objcon(xopt);
c
nfun

% ------------Objective and Non-linear Constraints------------
function [ f,c,ceq ] = objcon(x)
    global nfun;

    %get data for truss from Data.m file
    Data;

    % insert areas (design variables) into correct matrix
    for ii = 1:nelem
        Elem(ii,3) = x(ii);
    end

    % call Truss to get weight and stresses
    [weight,stress] = Truss(ndof,nbc,nelem,E,dens,Node,force,bc,Elem);

    % objective function
    f = weight; % minimize weight

    % inequality constraints, c <= 0
    c = zeros(20,1);
    idx = 1;
    for ii = 1:10
        % check stress both pos and neg
        c(idx) = stress(ii) - 25e3;
        c(idx+1) = -25e3 - stress(ii);
        idx = idx + 2;
    end

    % equality constraints, ceq = 0
    ceq = [];
    nfun = nfun + 1;

end

% ------------Separate obj/con (do not change)------------
function [ f ] = obj(x) 
    [ f,~,~ ] = objcon(x);
end
function [ c,ceq ] = con(x) 
    [ ~,c,ceq ] = objcon(x);
end