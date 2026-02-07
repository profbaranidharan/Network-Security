clc; clear; close all;

%% Create Figure
f = figure('Name','Symmetric Encryption Demo', ...
           'Position',[400 200 500 350], ...
           'NumberTitle','off');

%% Sender Inputs
uicontrol(f,'Style','text','Position',[40 300 120 20], ...
          'String','Sender Plaintext');

handles.ptBox = uicontrol(f,'Style','edit','Position',[170 300 250 25]);

uicontrol(f,'Style','text','Position',[40 260 120 20], ...
          'String','Sender Key');

handles.keyBox = uicontrol(f,'Style','edit','Position',[170 260 100 25]);

%% Ciphertext Display
uicontrol(f,'Style','text','Position',[40 210 120 20], ...
          'String','Ciphertext');

handles.ctBox = uicontrol(f,'Style','edit','Position',[170 210 250 25], ...
                          'Enable','inactive');

%% Receiver Input
uicontrol(f,'Style','text','Position',[40 170 120 20], ...
          'String','Receiver Key');

handles.recvKeyBox = uicontrol(f,'Style','edit','Position',[170 170 100 25]);

%% Decrypted Text
uicontrol(f,'Style','text','Position',[40 130 120 20], ...
          'String','Decrypted Text');

handles.dtBox = uicontrol(f,'Style','edit','Position',[170 130 250 25], ...
                          'Enable','inactive');

%% Buttons
uicontrol(f,'Style','pushbutton','String','Encrypt', ...
          'Position',[100 70 100 35], ...
          'Callback',@encryptCallback);

uicontrol(f,'Style','pushbutton','String','Decrypt', ...
          'Position',[260 70 100 35], ...
          'Callback',@decryptCallback);

%% Store handles
guidata(f,handles);

%% ================= Callback Functions =================

function encryptCallback(src,~)
    handles = guidata(src);

    plaintext = get(handles.ptBox,'String');
    key = str2double(get(handles.keyBox,'String'));
    key = mod(key,26);

    ciphertext = char(double(plaintext) + key);
    set(handles.ctBox,'String',ciphertext);
end

function decryptCallback(src,~)
    handles = guidata(src);

    ciphertext = get(handles.ctBox,'String');
    key = str2double(get(handles.recvKeyBox,'String'));
    key = mod(key,26);

    decrypted = char(double(ciphertext) - key);
    set(handles.dtBox,'String',decrypted);
end