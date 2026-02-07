clc;
clear;
close all;

%% ===================== SENDER SIDE =====================

disp('--- SENDER SIDE ---');

% Sender inputs plaintext
plaintext = input('Sender: Enter the plaintext message: ', 's');

% Validate plaintext
if isempty(plaintext)
    error('Plaintext cannot be empty.');
end

disp(['Plaintext        : ', plaintext]);

% Sender inputs secret key
key_sender = input('Sender: Enter the secret key (positive integer): ');

% Validate key
if ~isscalar(key_sender) || key_sender < 0 || floor(key_sender) ~= key_sender
    error('Secret key must be a positive integer.');
end

% Limit key range
key_sender = mod(key_sender, 26);
disp(['Secret Key (used): ', num2str(key_sender)]);

%% Encryption
pt_ascii = double(plaintext);
ct_ascii = pt_ascii + key_sender;
ciphertext = char(ct_ascii);

disp(['Ciphertext Sent  : ', ciphertext]);

%% ===================== RECEIVER SIDE =====================

disp(' ');
disp('--- RECEIVER SIDE ---');

% Receiver inputs key
key_receiver = input('Receiver: Enter the secret key to decrypt: ');

% Validate key
if ~isscalar(key_receiver) || key_receiver < 0 || floor(key_receiver) ~= key_receiver
    error('Secret key must be a positive integer.');
end

key_receiver = mod(key_receiver, 26);

%% Decryption
decrypted_ascii = double(ciphertext) - key_receiver;
decrypted_text = char(decrypted_ascii);

disp(['Decrypted Text   : ', decrypted_text]);

%% ===================== VERIFICATION =====================

if strcmp(plaintext, decrypted_text)
    disp('Decryption Successful: Correct Key Used');
else
    disp('Decryption Failed: Incorrect Key');
end