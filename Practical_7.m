clc;
clear all;
close all;
T = 2*pi;           
% Period of waveform
t = -pi:0.0001:pi;  % Time range vector
N = 20;             
% Number of harmonics
% 1. Square Wave Fourier Series Approximation (Odd Harmonics)
y = zeros(size(t));
for n = 1:2:N
    y = y + (4/pi)*(1/n)*sin(n*t);  % y = (4/pi) * sum( (1/n)*sin(n*w0*t) )
end
figure;
plot(t, y);
title("Fourier Series Approximation Of Square Wave");
xlabel("Time(s)");
ylabel("Amplitude");
grid on;
% 2. Sawtooth Wave Fourier Series Approximation (All Harmonics)
y1 = zeros(size(t));
for n = 1:N
    y1 = y1 + (2/pi)*((-1)^(n+1)/n)*sin(n*t);  % y1 = (2/pi) * sum( ((-1)^(n+1)/n)*sin(n*w0*t) )
end
figure;
plot(t, y1, 'm');
title("Fourier Series Approximation Of Sawtooth Wave");
xlabel("Time(s)");
ylabel("Amplitude");
grid on;
% 3. Triangular Wave Fourier Series Approximation (Odd Harmonics, 1/n^2)
y2 = zeros(size(t));
for n = 1:2:N
    y2 = y2 + (8/pi^2)*(1/n^2)*cos(n*t);  % y2 = (8/pi^2) * sum( (1/n^2)*cos(n*w0*t) )
end
figure;
plot(t, y2, 'r');
title("Fourier Series Approximation Of Triangular Wave");
xlabel("Time(s)");
ylabel("Amplitude");
grid on;