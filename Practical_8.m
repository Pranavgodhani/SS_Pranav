clc; 
clear; 
close all; 
t = -10:0.01:10; 
w = -2*pi:0.01:2*pi; 
A = 3; 
x_t1 = A.^t;  
x_k1 = zeros(size(w)); 
for k = 1:length(w) 
    x_k1(k) = trapz(t, x_t1 .* exp(-1j * w(k) * t)); 
end 
figure('Name', 'Signal 1: Exponential'); 
subplot(1,3,1); 
plot(t, x_t1); 
title('Exponential Signal'); xlabel('Time'); ylabel('Amplitude'); grid on; 
subplot(1,3,2); 
plot(w, abs(x_k1)); 
title('Magnitude'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on; 
subplot(1,3,3); 
plot(w, angle(x_k1)); 
title('Phase'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on; 
x_t2 = sin(t); 
x_k2 = zeros(size(w)); 
for k = 1:length(w) 
    x_k2(k) = trapz(t, x_t2 .* exp(-1j * w(k) * t)); 
end 
figure('Name', 'Signal 2: Sinewave'); 
subplot(1,3,1); 
plot(t, x_t2); 
title('Sinewave'); xlabel('Time'); ylabel('Amplitude'); grid on; 
subplot(1,3,2); 
plot(w, abs(x_k2)); 
title('Magnitude'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on; 
subplot(1,3,3); 
plot(w, angle(x_k2)); 
title('Phase'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on; 
x_t3 = t.^2; 
x_k3 = zeros(size(w)); 
for k = 1:length(w) 
    x_k3(k) = trapz(t, x_t3 .* exp(-1j * w(k) * t)); 
end 
figure('Name', 'Signal 3: Parabolic Wave'); 
subplot(1,3,1); 
plot(t, x_t3); 
title('Parabolic Wave'); xlabel('Time'); ylabel('Amplitude'); grid on; 
subplot(1,3,2); 
plot(w, abs(x_k3)); 
title('Magnitude'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on; 
subplot(1,3,3); 
plot(w, angle(x_k3)); 
title('Phase'); xlabel('Frequency (\omega)'); ylabel('Amplitude'); grid on;