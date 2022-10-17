M = 128; % Alphabet size of modulation
L = 1; % Length of impulse response of channel
msg = [0:M-1 0]; % M-ary message sequence of length > M^L

modsig = qammod(msg',M); % Modulate data
Nsamp = 16;
modsig = rectpulse(modsig,Nsamp); % Use rectangular pulse shaping.

txsig = modsig; % No filter in this example

rxsig = txsig*exp(1i*pi/180); % Static phase offset of 1 degree


num = ones(Nsamp,1)/Nsamp;
den = 1;
EbNo = 11:20; % Range of Eb/No values under study
ber = semianalytic(txsig,rxsig,'qam',M,Nsamp,num,den,EbNo);

% For comparison, calculate theoretical BER.
bertheory = berawgn(EbNo,'qam',M);

% Plot computed BER and theoretical BER.
figure; semilogy(EbNo,ber,'b-o', ...
    'LineWidth',3,...
    'MarkerSize',5);
hold on; semilogy(EbNo,bertheory,'r-*',...
    'LineWidth',2,...
    'MarkerSize',3);
title('Performance Bound for LSE & MLSE m=2 ');
legend('Upper bound of MLSE',...
    'Upper bound of LSE','Northeast');
xlabel('SNR (dB)')
ylabel('Symbol Error Probability')
grid on
hold off;