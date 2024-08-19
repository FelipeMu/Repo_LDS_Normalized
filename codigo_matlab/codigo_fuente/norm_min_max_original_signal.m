function [min_sig, max_sig, normalized] = norm_min_max_original_signal(signal)
    % Aplicacion de normalizacion min-max
    min_sig = min(signal);
    max_sig = max(signal);
    norm_signal = (signal - min_sig) / (max_sig - min_sig);
    normalized = norm_signal; % senal normalizada [0, 1]
end