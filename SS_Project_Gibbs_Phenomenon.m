clear;
clc;
close all;

%% 1. PARAMETERS

N = 25;                         % Number of odd harmonics
x = linspace(-pi, pi, 20001);   % One period
k = 0:N-1;
harmonics = 2*k + 1;            % Odd harmonics: 1,3,5,...

% Ideal square wave
ideal = sign(sin(x));

%% 2. DEFINE FIVE WINDOW FUNCTIONS

W = ones(5, N);

% Rectangular window
W(1,:) = ones(1, N);

% Hamming window
W(2,:) = 0.54 + 0.46*cos(pi*k/(N-1));

% Hann (Hanning) window
W(3,:) = 0.5*(1 + cos(pi*k/(N-1)));

% Blackman window
W(4,:) = 0.42 + 0.50*cos(pi*k/(N-1)) ...
               + 0.08*cos(2*pi*k/(N-1));

% Kaiser window, beta = 5
beta = 5;

W(5,:) = besseli(0, beta*sqrt(1-(k/(N-1)).^2)) ...
         / besseli(0, beta);

names = {'Rectangular', 'Hamming', 'Hann', ...
         'Blackman', 'Kaiser (\beta=5)'};

%% 3. SYNTHESIZE THE FIVE WINDOWED WAVEFORMS

Y = zeros(5, length(x));

for i = 1:5
    for j = 1:N

        Y(i,:) = Y(i,:) + ...
            W(i,j)*(4/pi/harmonics(j)) ...
            * sin(harmonics(j)*x);

    end
end

%% 4. FIGURE 1 - ALL FIVE SYNTHESIZED WAVEFORMS

figure('Color','w', ...
       'Name','Five Windowed Square Waves');

tiledlayout(3,2,'TileSpacing','compact');

for i = 1:5

    nexttile;

    plot(x/pi, ideal, 'k--', 'LineWidth', 1.2);
    hold on;

    plot(x/pi, Y(i,:), 'b', 'LineWidth', 1.4);

    grid on;
    xlim([-1 1]);
    ylim([-1.5 1.5]);

    xlabel('Time (t/\pi)');
    ylabel('Amplitude');
    title(names{i});

    legend('Ideal square wave', 'Synthesized', ...
           'Location','best');

    hold off;

end

sgtitle('Gibbs Phenomenon: Five Window Functions');

%% 5. MEASURE OVERSHOOT, TRANSITION WIDTH AND RIPPLE

overshoot = zeros(5,1);
transition = zeros(5,1);
ripple = zeros(5,1);

% Regions on either side of the rising edge at x = 0
left = find(x < 0);
right = find(x > 0);

% Positive plateau region, away from the discontinuities
plateau = (x >= 0.5) & (x <= pi-0.5);

for i = 1:5

    y = Y(i,:);

    % (A) Overshoot as percentage of jump height
    nearRight = (x > 0) & (x < pi/2);
    peak = max(y(nearRight));

    overshoot(i) = max(0, (peak-1)/2*100);

    % (B) Transition width between -0.8 and +0.8
    idx10 = left(y(left) <= -0.8);
    idx90 = right(y(right) >= 0.8);

    if ~isempty(idx10) && ~isempty(idx90)

        transition(i) = ...
            x(idx90(1)) - x(idx10(end));

    else

        transition(i) = NaN;

    end

    % (C) Maximum absolute deviation on positive plateau
    ripple(i) = max(abs(y(plateau)-1));

end

%% 6. DISPLAY NUMERICAL RESULTS

Results = table(overshoot, transition, ripple, ...
    'VariableNames', ...
    {'Overshoot_percent', ...
     'Transition_width_rad', ...
     'Plateau_ripple_amplitude'}, ...
    'RowNames', names);

disp(' ');
disp('==============================================');
disp(' GIBBS PHENOMENON - NUMERICAL RESULTS');
disp('==============================================');

disp(Results);

%% 7. FIGURE 2 - PERFORMANCE COMPARISON BAR CHARTS

figure('Color','w', ...
       'Name','Window Performance Comparison');

tiledlayout(1,3,'TileSpacing','compact');

% Overshoot comparison
nexttile;

bar(overshoot);
grid on;

title('Overshoot');
ylabel('Percent of jump height (%)');

xticks(1:5);
xticklabels(names);
xtickangle(45);

% Transition-width comparison
nexttile;

bar(transition);
grid on;

title('Transition Width');
ylabel('Width (radians)');

xticks(1:5);
xticklabels(names);
xtickangle(45);

% Plateau-ripple comparison
nexttile;

bar(ripple*100);
grid on;

title('Plateau Ripple');
ylabel('Maximum deviation from level (%)');

xticks(1:5);
xticklabels(names);
xtickangle(45);

sgtitle('Gibbs Phenomenon: Window Performance');

%% 8. FEATURE 1 - ANIMATION OF FOURIER SERIES CONVERGENCE

figure('Color','w', ...
       'Name','Fourier Series Animation');

for N_anim = 1:2:41

    y_anim = zeros(size(x));

    for m = 0:N_anim-1

        h = 2*m + 1;

        y_anim = y_anim + ...
            (4/(pi*h))*sin(h*x);

    end

    plot(x/pi, ideal, 'k--', 'LineWidth', 1.5);
    hold on;

    plot(x/pi, y_anim, 'b', 'LineWidth', 1.6);

    hold off;

    grid on;
    xlim([-1 1]);
    ylim([-1.5 1.5]);

    xlabel('Time (t/\pi)');
    ylabel('Amplitude');

    title(sprintf( ...
        'Fourier Approximation: %d Odd Harmonics', N_anim));

    legend('Ideal square wave', ...
           'Fourier approximation', ...
           'Location','southoutside');

    drawnow;
    pause(0.25);

end

%% 9. FEATURE 2 - WINDOW COEFFICIENT COMPARISON

figure('Color','w', ...
       'Name','Window Coefficient Comparison');

hold on;

for i = 1:5

    plot(harmonics, W(i,:), '-o', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 4);

end

grid on;

xlabel('Harmonic Number');
ylabel('Window Weight');

title('Window Functions: Fourier Coefficient Weights');

legend(names, 'Location','best');

ylim([-0.05 1.1]);
xlim([1 max(harmonics)]);

hold off;

%% 10. FEATURE 3 - ZOOM INTO GIBBS PHENOMENON

figure('Color','w', ...
       'Name','Zoomed Gibbs Phenomenon');

zoom_region = (x >= -0.15) & (x <= 0.15);

plot(x(zoom_region)/pi, ideal(zoom_region), ...
    'k--', 'LineWidth', 1.5);

hold on;

for i = 1:5

    plot(x(zoom_region)/pi, Y(i,zoom_region), ...
        'LineWidth', 1.4);

end

grid on;

xlabel('Time (t/\pi)');
ylabel('Amplitude');

title('Zoomed View of Gibbs Phenomenon');

legend(['Ideal square wave', names], ...
       'Location','best');

ylim([-1.35 1.35]);

hold off;


%% 11. APPROXIMATION ERROR - CONSISTENT ZOOM

figure('Color','w', ...
    'Name','Approximation Error Comparison');

tiledlayout(3,2,'TileSpacing','compact');

for i = 1:5

    nexttile;

    error_signal = Y(i,:) - ideal;

    plot(x/pi, error_signal, 'LineWidth', 1.2);

    grid on;

    % Apply the same zoom to every subplot
    xlim([-0.05 0.05]);
    ylim([-1.1 1.1]);

    xlabel('Time (t/\pi)');
    ylabel('Error');

    title(names{i});

end

sgtitle('Approximation Error Near the Discontinuity');


%% 12. FINAL SUMMARY

[min_overshoot, idx_over] = min(overshoot);
[min_ripple, idx_ripple] = min(ripple);
[min_transition, idx_trans] = min(transition);

disp(' ');
disp('==============================================');
disp(' FINAL SUMMARY');
disp('==============================================');

fprintf('Minimum overshoot: %s (%.3f%%)\n', ...
    names{idx_over}, min_overshoot);

fprintf('Minimum plateau ripple: %s (%.5f)\n', ...
    names{idx_ripple}, min_ripple);

fprintf('Narrowest transition: %s (%.5f radians)\n', ...
    names{idx_trans}, min_transition);

disp(' ');
disp('Conclusion: Windowing reduces unwanted oscillations,');
disp('but generally increases transition width.');
disp('==============================================');
