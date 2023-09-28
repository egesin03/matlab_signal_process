%Ersan Gürkan Gültekin 2575355
%Yusuf Berkin Güler 2575330
%Ege Esin 2575249 

load x.mat
load v.mat

fs=44100;
%sound(x,fs);
t = (0:length(x)-1)/fs;
figure
plot(t,x)
xlabel('Time (s)')
ylabel('Amplitude')
title('Noisy Audio Signal')

X = fft(x);
n = length(x);
f = (0:n-1)*(fs/n);
X_mag = abs(X);

%magnitude of the spectrum noisy audio plot
figure
plot(f, X_mag)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Spectrum of Noisy Audio Signal')

%sound(v,fs);
t=(0:length(v)-1)/fs;
% vuvuzela signal plot 
figure
plot(t, v)
xlabel('Time (s)')
ylabel('Amplitude')
title('Vuvuzela Signal graph')

V = fft(v);
n = length(v);
f = (0:n-1)*(fs/n);
Vm = abs(V);
%magnitude of the spectrum vuvuzela plot
figure
plot(f, Vm)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude Spectrum Vuvuzela Signal Graph')

f0 = 235; % fundamental frequency
delta = 10; 
K = 5;  

% Form the spectral mask to be applied to noisy spectrum
spectrum_mask = ones(length(X), 1); % initially set all frequencies to 1
for k = 1:K
    % Form a vector containing the frequencies around k*f0
    masked_freq_low = round((f0*k - delta)/fs*n):round((f0*k + delta)/fs*n);
    % Make sure that the range of frequencies stays in a valid range
    masked_freq_low(masked_freq_low <= 0) = [];
    masked_freq_low(masked_freq_low > n) = [];
    % Take care of the replica at the right as well
    masked_freq_high = n + 2 - masked_freq_low;
    masked_freq_high(masked_freq_high <= 0) = [];
    masked_freq_high(masked_freq_high > n) = [];
    % Set the selected frequencies of the spectral mask to 0
    spectrum_mask(masked_freq_low) = 0;
    spectrum_mask(masked_freq_high) = 0;
end

Xdenoised = X .* spectrum_mask;

xdenoised = ifft(Xdenoised);
mag_denoised = abs(Xdenoised);

%magnitude spectrum denoised signal plot 
f = (0:n-1)*fs/n;
figure
plot(f,mag_denoised);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude spectrum of the denoised signal');
sound(xdenoised, fs);

% spectrum mask plot
figure
plot(f,spectrum_mask);
xlabel("f(Hertz)");
ylabel("Spectral Mask");
title("Spectrum Mask Graph")
