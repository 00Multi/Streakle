clc;clear;close all
% Wordle game in MATLAB
% Final Project for Carlton Passley

% Load the current win streak
if exist('win_streak.mat', 'file') == 0
   win_streak = 0;
   save('win_streak.mat','win_streak')
else
   load('win_streak.mat','win_streak')
end

% Load/Create Level function
if exist('level.mat', 'file') == 0
   level = 1;
   save('level.mat','level')
else
   load('level.mat','level')
end

% Load/Create Level function
if exist('cheat.mat', 'file') == 0
   cheat = 0;
   save('cheat.mat','cheat')
else
   load('cheat.mat','cheat')
end

% Set Difficulty Level
if level == 1 && win_streak == 0
    cprintf('*Yellow','Please select your difficulty level')
    fprintf('\n(Type r for rules)\n\n')
    fprintf('Easy -------------- 7 tries per turn, 2 in a row to win level\nMedium ---------- 6 tries per turn, 3 in a row to win level\nHard -------------- 5 tries per turn, 4 in a row to win level\nImpossible -------- 4 tries per turn, 5 in a row to win level\n\n')
    difficulty = input('Type e, m, h, or i: ','s');
    clc;
    if strcmp(difficulty,'e') || strcmp(difficulty,'easy')
        attempts = 7;
        streak_req = 2;
        save('attempts.mat','attempts')
        save('streak_req.mat','streak_req')
    elseif strcmp(difficulty,'m') || strcmp(difficulty,'medium')
        attempts = 6;
        streak_req = 3;
        save('attempts.mat','attempts')
        save('streak_req.mat','streak_req')
    elseif strcmp(difficulty,'h') || strcmp(difficulty,'hard')
        attempts = 5;
        streak_req = 4;
        save('attempts.mat','attempts')
        save('streak_req.mat','streak_req')
    elseif strcmp(difficulty,'i') || strcmp(difficulty,'impossible')
        attempts = 4;
        streak_req = 5;
        save('attempts.mat','attempts')
        save('streak_req.mat','streak_req')
    elseif strcmpi(difficulty,'r')
     clc;
     fprintf('%%%%%%%%%%%%RULES%%%%%%%%%%%% (1 of 2)\n\n')
     fprintf("- You're guesses should be %d letters long", 5)
     fprintf("\n- If you don't guess the word in %d tries you lose\n", 6)
     fprintf("- You can type 'I quit' if you want to end the game\n")
     fprintf("- You can type 'ans' if you want to cheat XD\n\n")
     fprintf('Hints:')
     fprintf("\n\n1. # ============ Not in the secret word\n")
     fprintf("2. lower case ====== Wrong spot, but in the secret word\n")
     fprintf('3. UPPER CASE ===== Correct Spot, & in the secret word\n\n')
     fprintf('Example:')
     fprintf('\n\n                              WISHY\n                              w#s#Y\n\n')
     fprintf('- Here w & s are in the wrong spots\n')
     fprintf("- Y is in the correct spot\n- i & h aren't in the word\n")
     fprintf("- I think the answer may be...\n")
     fprintf('\n                              ')
     cprintf([1, 0.84, 0],'SNOWY\n')
     fprintf('                    ')
     cprintf('Cyan','You ');cprintf([1, 0.41, 0.71],'win! ');
     cprintf('Cyan','Slay ');cprintf([1, 0.41, 0.71],'queen!\n\n');
     option = [];
     while ~strcmp(option, 'ok')
         option = input("Type 'ok' for next page: ",'s');
         if strcmp(option, 'ok')
             clc;
             fprintf('%%%%%%%%%%%%RULES%%%%%%%%%%%% (2 of 2)\n\n')
             fprintf('- Streakle is a variation on Wordle.\n\n')
             fprintf("- You will have to win multiple Wordles in a row\n  inorder to complete each level.\n\n")
             fprintf("- The first level is Wordle with 5 letter words, and\n  each following level increases the words by one letter.\n\n")
             fprintf("- The streak size required to clear each level\n  is determined by the difficulty you select.\n\n")
             fprintf("- Quitting the game or seeing the rules will\n  erase your streak!\n\n")
             fprintf("- You may cheat for the answer once per level.\n\n- The game ends after level 6\n  (10 letter words)\n\n- Good luck!!\n\n\n")
             option2 = [];
             while ~strcmp(option2, 'ok')
                 option2 = input("Type 'ok' for next page: ",'s');
             end
             streakle
         end
     end
    else
        streakle
    end
else
    load('attempts.mat','attempts')
    load('streak_req.mat','streak_req')
end

% Level Selection
if level == 1
    words = five_letter_words();
elseif level == 2
    words = six_letter_words();
elseif level == 3
    words = seven_letter_words();
elseif level == 4
    words = eight_letter_words();
elseif level == 5
    words = nine_letter_words();
elseif level == 6
    words = ten_letter_words();
end

% Random Word Selection
rand_index = randi(length(words));
sec_word = words{rand_index};
% sec_word

% Preallocated Variables
num_letters = level + 4;
num_next    = level + 5;
L_word = length(sec_word);
correct_guesses = zeros(L_word,1);
letters = 0;
basically_forever = 9000000000000000000;

% Load Highest Level
if exist('high_level.mat','file') == 0
   high_level = 0;
   save('high_level.mat','high_level')
else
   load('high_level.mat','high_level')
end

% Set New High Level
if high_level < level
   high_level = level;
   save('high_level.mat','high_level')
end

% Welcome Message
if streak_req == 2
    difficulty = 'Easy :    ^    )';
elseif streak_req == 3
    difficulty = 'Medium (^.^)';
elseif streak_req == 4
    difficulty = 'Hard B^)';
elseif streak_req == 5
    difficulty = 'Impossible >:^)))';
end
 fprintf('Welcome to Streakle!                  Streak = %d/%d\nType r for the rules :^)       Current level =  %d\n                                        Highest level =  %d\nDifficulty: %s\n\n', win_streak, streak_req, level, high_level, difficulty);
 fprintf("Guess the secret %d letter word in %d tries or less!\n\n",num_letters, attempts);

% Game loop, goes on for forever... basically
for i = 1:basically_forever

 % Number of tries, important for determening when you lose
 num_tries = letters/L_word + 1;
 
 % Guess Input
 fprintf("Enter guess %d:", num_tries); guess = input(' ', 's');
 guess = upper(guess);

 % Rules
 if strcmpi(guess,'r')
     clc;
     fprintf('%%%%%%%%%%%%RULES%%%%%%%%%%%% (1 of 2)\n\n')
     fprintf("- You're guesses should be %d letters long", L_word)
     fprintf("\n- If you don't guess the word in %d tries you lose\n", attempts)
     fprintf("- You can type 'I quit' if you want to end the game\n")
     fprintf("- You can type 'ans' if you want to cheat XD\n\n")
     cprintf(-[1 1 1],'Hints:')
     fprintf("\n\n1. # ============ Not in the secret word\n")
     fprintf("2. lower case ====== Wrong spot, but in the secret word\n")
     fprintf('3. UPPER CASE ===== Correct Spot, & in the secret word\n\n')
     cprintf(-[1 1 1],'Example:')
     fprintf('\n\n                              WISHY\n                              w#s#Y\n\n')
     fprintf('- Here w & s are in the wrong spots\n')
     fprintf("- Y is in the correct spot\n- i & h aren't in the word\n")
     fprintf("- I think the answer may be...\n")
     fprintf('\n                              ')
     cprintf([1, 0.84, 0],'SNOWY\n')
     fprintf('                    ')
     cprintf('Cyan','You ');cprintf([1, 0.41, 0.71],'win! ');
     cprintf('Cyan','Slay ');cprintf([1, 0.41, 0.71],'queen!\n\n');
     option = [];
     while ~strcmp(option, 'ok')
         option = input("Type 'ok' for next page: ",'s');
         if strcmp(option, 'ok')
             clc;
             fprintf('%%%%%%%%%%%%RULES%%%%%%%%%%%% (2 of 2)\n\n')
             fprintf('- Streakle is a variation on Wordle.\n\n')
             fprintf("- You will have to win multiple Wordles in a row\n  inorder to complete each level.\n\n")
             fprintf("- The first level is Wordle with 5 letter words, and\n  each following level increases the words by one letter.\n\n")
             fprintf("- The streak size required to clear each level\n  is determined by the difficulty you select.\n\n")
             fprintf("- Quitting the game or seeing the rules will\n  erase your streak!\n\n")
             fprintf("- You may cheat for the answer only once\n  per level.\n\n- Good luck!!\n\n\n")
             option2 = [];
             while ~strcmp(option2, 'ok')
                 option2 = input("Type 'ok' for next page: ",'s');
             end
             clc;
             win_streak  = 0;
             cheat = 0;
             high_level = 0;
             save('cheat.mat','cheat')
             save('win_streak.mat','win_streak')
             save('high_level.mat','high_level')
             streakle;
         end
     end

 % Reset High Streak
 elseif strcmpi(guess,'reset hl')
    win_streak  = 0;
    cheat = 0;
    high_level = 0;
    save('cheat.mat','cheat')
    save('win_streak.mat','win_streak')
    save('high_level.mat','high_level')
    streakle;
 break;
 % Quit the game
 elseif strcmpi(guess,'I quit')
     win_streak = 0;
     cheat = 0;
     level = 1;
     save('cheat.mat','cheat')
     save('win_streak.mat','win_streak')
     save('level.mat','level')
     clc;
     disp(['The answer was: ', sec_word])
     error('YOU HAVE QUIT - THANKS FOR PLAYING!!!!!')
 % You've run out of cheats message
 elseif strcmpi(guess,'ans') && cheat == 1
 q = annotation('textbox', [0.05, 0.7, 0.2, 0.2], 'String', ...
     'No more cheats for this level', ...
     'FontSize', 14, 'Color', 'white', 'BackgroundColor', 'red', ...
     'FitBoxToText', 'on');
     textbox_position = get(q, 'Position');
     figure_handle = gcf;
     new_position = [figure_handle.Position(1:2) + [-200 100], textbox_position(3:4) + [285 50]];
     figure_handle.Position = new_position;
 continue;
 % Cheats
 elseif strcmpi(guess,'ans') && cheat == 0
     cheat = cheat + 1;
     save('cheat.mat',"cheat")
     fprintf('\n')
     disp('Hacks activated B^)')
     disp(['*******',sec_word,'*******'])
     fprintf('\n')
 % Invalid word length
 elseif length(guess) ~= L_word   
 g = annotation('textbox', [0.05, 0.7, 0.2, 0.2], 'String', ...
     'Invalid Word Length', ...
     'FontSize', 14, 'Color', 'white', 'BackgroundColor', 'red', ...
     'FitBoxToText', 'on');
     textbox_position = get(g, 'Position');
     figure_handle = gcf;
     new_position = [figure_handle.Position(1:2) + [-200 100], textbox_position(3:4) + [215 50]];
     figure_handle.Position = new_position;
 continue;
 % Invalid word in general
 elseif ~ismember(guess, words)
 h = annotation('textbox', [0.1, 0.7, 0.2, 0.2], 'String', ...
     'Not a word from the list', ...
     'FontSize', 14, 'Color', 'white', 'BackgroundColor', 'red', ...
     'FitBoxToText', 'on');
     textbox_position = get(h, 'Position');
     figure_handle = gcf;
     new_position = [figure_handle.Position(1:2) + [-300 100], textbox_position(3:4) + [275 50]];
     figure_handle.Position = new_position;
 continue;
 % Win the game
 elseif strcmp(guess, sec_word)
     win_streak = win_streak + 1;
     save('win_streak.mat','win_streak')
     fprintf('\n                              ')
     cprintf([1, 0.84, 0],'%s\n', sec_word)
     fprintf('                    ')
     cprintf('Cyan','You ');cprintf([1, 0.41, 0.71],'win! ');
     cprintf('Cyan','Slay ');cprintf([1, 0.41, 0.71],'queen!\n');
     fprintf('\nYou guessed the secret word in %d tries!\n', num_tries)
     if win_streak == streak_req
        cheat = 0;
        level = level + 1;
        win_streak = 0;
        save('cheat.mat','cheat')
        save('win_streak.mat',"win_streak")
        save('level.mat','level')
        choice2 = [];
        while ~strcmp(choice2,'ok')
            choice2 = input("\nType 'ok' to move on: ",'s');
        end
            if level == 7
                level = 1;
                save('level.mat','level')
                clc;
                cprintf('*Green','Congratulations!!!'); fprintf('\n\n')
                cprintf('Yellow','You won streakle on the ');
                if streak_req == 2
                    cprintf('*Cyan','Easy')
                elseif streak_req == 3
                    cprintf('*Cyan','Medium')
                elseif streak_req == 4
                    cprintf('*Cyan','Hard')
                elseif streak_req == 5
                    cprintf('*Cyan','Impossible')
                end
                cprintf('Yellow',' difficulty level'); fprintf('\n\n')
                cprintf([255,218,185]/255,'Thank you for playing'); cprintf([221, 160, 221]/255,' <3'); fprintf('\n\n')
                endgame_choice = [];
                while ~strcmp(endgame_choice,'done')
                    endgame_choice = input("Type 'done' to finish the game: ", 's');
                end
                error('YOU HAVE QUIT - THANKS FOR PLAYING!!!!!')
            end
            clc;
            fprintf("Level Up!")
            if level == 6
                fprintf(' The final level has come')
            end
            fprintf("\n\nPrepare for %d letter words...\n\n", num_next)
            choice3 = [];
            while ~strcmp(choice3,'ok')
                choice3 = input("Type 'ok' to move on: ",'s');
            end
            streakle
     end
     choice = [];
     while ~strcmp(choice,'ok')
         choice = input("\nType 'ok' to move on: ",'s');
     end
     clc;
     streakle
 % Lose the game
 elseif num_tries == attempts
     win_streak = 0;
     level = 1;
     cheat = 0;
     save('cheat.mat','cheat')
     save('win_streak.mat','win_streak')
     save('level.mat','level')
     fprintf("\n\nSTREAK OVER\nThe answer was:")
     fprintf('\n                              ')
     cprintf('*Red','%s\n', sec_word)
     fprintf('                     ')
     cprintf('Yellow','Loss, ');cprintf([1 0.5 0],'inevitable ');
     cprintf('Yellow','yet ');cprintf([1 0.5 0],'unexpected\n');
     fprintf("\nYou couldn't guess the secret word in %d tries!\n", num_tries)
     decision = [];
     while ~strcmp(decision, 'c') || ~strcmp(decision,'q')
         decision = input("\nType 'q' to quit or 'c' to play again: ",'s');
         if strcmp(decision, 'c')
         streakle
         else
         clc;
         disp("Thanks for playing!")
         error('YOU HAVE QUIT - THANKS FOR PLAYING!!!!!')
         end
     end
 % Print Word
 else
     fprintf('\n                              ')
     disp(guess)
     fprintf('                              ')
 % Print hints
     for j = 1:length(sec_word)
         letters = letters + 1;
         if guess(j) == sec_word(j)
             correct_guesses(j) = 1;
             fprintf('%c', guess(j));
         elseif any(guess(j) == sec_word) && correct_guesses(j) == 0
             fprintf('%s',lower(guess(j)));
         else
             fprintf('#');
         end
     end
     fprintf('\n\n');
 end
end