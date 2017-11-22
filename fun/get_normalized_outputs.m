function [w_e_nom, delay1, delay2] = get_normalized_outputs(pars)
%% RUN STEADY STATE SIMULATION TO GET NORMALIZED REFERENCES
    u_alpha_input = pars.nom.u_alpha;
    du_ign_step_input = pars.nom.du_ign;
    model_name = 'full_model_steady_state.slx';
    
    % generate step signal
    [~, ~, w_e] = sim(model_name, pars.sim_opt);
    
    w_e_nom = mean(w_e((end-100):end));
    
    delay1 = mean(delay1_values((end-100):end));
    delay2 = mean(delay2_values((end-100):end));

end
