clc;clear;close all
% Wordle game in MATLAB
% Final Project for Carlton Passley

% Word List & Secret word selection
words = wordle_words();
rand_index = randi(length(words));
sec_word = words{rand_index};
% sec_word

% Preallocated Variables
attempts = 6;
L_word = length(sec_word);
correct_guesses = zeros(L_word,1);
letters = 0;
basically_forever = 9000000000000000000;

% Load the current win streak
if exist('win_streak.mat', 'file') == 0
   win_streak = 0;
   save('win_streak.mat','win_streak')
else
   load('win_streak.mat','win_streak')
end

% Load Highest Streak
if exist('high_streak.mat','file') == 0
   high_streak = 0;
   save('high_streak.mat','high_streak')
else
   load('high_streak.mat','high_streak')
end

% Set new high streak
if high_streak < win_streak
   high_streak = win_streak;
   save('high_streak.mat','high_streak')
end

% Welcome Message
 fprintf('Welcome to Wordle!                  Streak = %d\nType r for the rules :^)    Highest streak = %d\n\n', win_streak, high_streak);
 fprintf("Guess the secret word in %d tries or less!\n\n", attempts);

% Game loop, goes on for forever... basically
for i = 1:basically_forever

 % Number of tries, important for determening when you lose
 num_tries = letters/L_word + 1;
 
 % Guess Input
 fprintf("Enter guess %d:", num_tries)
 guess = input(' ', 's');
 guess = upper(guess);

 % Rules
 if strcmpi(guess,'r')
     clc;
     fprintf('%%%%%%%%%%%%RULES%%%%%%%%%%%%\n\n')
     fprintf("- You're guesses should be %d letters long",L_word)
     fprintf("\n- If you don't guess the word in %d tries you lose\n",attempts)
     fprintf("- You can type 'I quit' if you want to end the game\n")
     fprintf("- You can type 'answer' if you want to cheat XD\n\n")
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
     option = input("Type 'start' when you're ready: ",'s');
     if strcmp(option, 'start')
             run("Final_Wordle.m")
     end
     if ~strcmp(option, 'start')
             clc;
             disp('Ok then buddy <3')
             win_streak = 0;
             save('win_streak.mat','win_streak');
     break;
     end
 % Reset High Streak
 elseif strcmpi(guess,'reset hs')
    win_streak  = 0;
    high_streak = 0;
    save('win_streak.mat','win_streak')
    save('high_streak.mat','high_streak')
    wordlepls;
 break;
 % Quit the game
 elseif strcmpi(guess,'I quit')
     clc;
     disp('Taking the easy way out smh...')
     disp(['The answer was: ', sec_word])
     win_streak = 0;
     save('win_streak.mat','win_streak');
 break;
 % Cheats
 elseif strcmpi(guess,'answer')              
     fprintf('\n')
     disp('Hacks activated B^)')
     disp(['*******',sec_word,'*******'])
     fprintf('\n')
 % Invalid word length
 elseif length(guess) ~= L_word   
 g = annotation('textbox', [0.05, 0.7, 0.2, 0.2], 'String', ...
     'Your word needs to be 5 letters long', ...
     'FontSize', 14, 'Color', 'white', 'BackgroundColor', 'red', ...
     'FitBoxToText', 'on');
     textbox_position = get(g, 'Position');
     figure_handle = gcf;
     new_position = [figure_handle.Position(1:2) + [-200 100], textbox_position(3:4) + [365 50]];
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
     fprintf('\n                              ')
     cprintf([1, 0.84, 0],'%s\n', sec_word)
     fprintf('                    ')
     cprintf('Cyan','You ');cprintf([1, 0.41, 0.71],'win! ');
     cprintf('Cyan','Slay ');cprintf([1, 0.41, 0.71],'queen!\n');
     fprintf('\nYou guessed the secret word in %d tries!\n', num_tries)
     choice = input("\nType 'q' to quit or 'c' to play again: ",'s');
     if strcmp(choice, 'c')
         win_streak = win_streak + 1;
         save('win_streak.mat','win_streak');
         wordlepls
         break;
     end
     if strcmp(choice,'q')
         win_streak = win_streak + 1;
         save('win_streak.mat','win_streak');
         clc;
         disp("Thanks for playing!")
         break;
     end
     if ~strcmp(choice, 'c') && ~strcmp(choice,'q')
         win_streak = win_streak + 1;
         save('win_streak.mat','win_streak');
         clc;
         disp("Play time's over lil' bro.")
         break;
     end
 % Lose the game
 elseif num_tries == attempts
     win_streak = 0;
     save('win_streak.mat','win_streak');
     fprintf("\n\nGAME OVER\nThe answer was:")
     fprintf('\n                              ')
     cprintf('*Red','%s\n', sec_word)
     fprintf('                     ')
     cprintf('Yellow','Wow ');cprintf([1 0.5 0],'you ');
     cprintf('Yellow','are ');cprintf([1 0.5 0],'bad!\n');
     fprintf("\nYou didn't guessed the secret word in %d tries!\n", num_tries)
     decision = input("\nType 'q' to quit or 'c' to play again: ",'s');
     if strcmp(decision, 'c')
         wordlepls
         break;
     end
     if strcmp(decision,'q')
         clc;
         disp("Thanks for playing!")
         break;
     end
     if ~strcmp(decision, 'c') && ~strcmp(decision,'q')
         clc;
         disp("Play time's over lil' bro.")
         break;
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