function [observer] = create_observer(ss,pars)
%% CREATES SS MODEL FOR OBSERVER
    % Determine observer gain
    B_in = ss.B*ss.B';
    pars.des.L  = (lqr(ss.A', ss.C', B_in, pars.des.q))';

    % Build observer system
        % Convert matrices to transfer functions
        A = tf(ss.A);
        B = tf(ss.B);
        C = tf(ss.C);
        L = tf(pars.des.L);
        s = tf('s'); 

        % Create signals for iconnect
        y_nl_in = icsignal(1); % normalized output signal from nonlinear plant
        u_nl_in = icsignal(2); % normalized input signal for nonlinear plant
        x_hat = icsignal(11); % states as predicted by the observer
        y_hat = icsignal(1); % output as predicted by the observer
        x_hat_dot = icsignal(11); % intermediate signal; time-derivative of x_hat
    
        % Connect observer blocks and signals
        M  = iconnect; 
        M.Input = [u_nl_in; y_nl_in]; 
        M.Output = [x_hat; y_hat]; 
        % Equation 1: everything before integrator
        M.Equation{1} = equate(x_hat_dot, u_nl_in*B + x_hat*A + (y_nl_in - y_hat)*L);
        % Equation 2: integrate time derivatives of states
        M.Equation{2} = equate(x_hat, s*x_hat_dot);
        % Equation 3: multiply with C to get output from the states
        M.Equation{3} = equate(y_hat, C*x_hat);
    
        % Create state-space representation for the observer system
        observer = ss(M.System);