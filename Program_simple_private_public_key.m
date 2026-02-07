clc;
clear;
close all;

%% ===================== RECEIVER SIDE =====================
disp('--- RECEIVER SIDE (Key Setup) ---');

public_key  = input('Receiver: Enter PUBLIC key (number): ');
private_key = input('Receiver: Enter PRIVATE key (number): ');

disp('Public key is shared with sender');
disp('Private key is kept secret');

%% ===================== SENDER SIDE =====================
disp(' ');
disp('--- SENDER SIDE ---');

plaintext = input('Sender: Enter plaintext message: ', 's');
disp(['Plaintext: ', plaintext]);

% Convert plaintext to ASCII
pt_ascii = double(plaintext);

% Encrypt using PUBLIC KEY
ciphertext = bitxor(pt_ascii, public_key);

disp('Ciphertext sent (numeric):');
disp(ciphertext);

%% ===================== RECEIVER SIDE =====================
disp(' ');
disp('--- RECEIVER SIDE (Decryption) ---');

% Decrypt using PRIVATE KEY
decrypted_ascii = bitxor(ciphertext, private_key);
decrypted_text = char(decrypted_ascii);

disp(['Decrypted Text: ', decrypted_text]);

%% ===================== VERIFICATION =====================
disp(' ');
if strcmp(plaintext, decrypted_text)
    disp('✔ Decryption Successful');
else
    disp('✘ Decryption Failed (Wrong Key)');
end