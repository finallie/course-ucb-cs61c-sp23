#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch);

static bool is_tail(char c);

static bool is_head(char c);

static bool is_snake(char c);

static char body_to_tail(char c);

static char head_to_body(char c);

static unsigned int get_next_row(unsigned int cur_row, char c);

static unsigned int get_next_col(unsigned int cur_col, char c);

static void find_head(game_state_t *state, unsigned int snum);

static char next_square(game_state_t *state, unsigned int snum);

static void update_tail(game_state_t *state, unsigned int snum);

static void update_head(game_state_t *state, unsigned int snum);

static char *alloc_str(char *str) {
    char *new_str = malloc(strlen(str) + 1);
    strcpy(new_str, str);
    return new_str;
}

static const int NUM_ROWS = 18;

/* Task 1 */
game_state_t *create_default_state() {
    // TODO: Implement this function.
    game_state_t *game_state = malloc(sizeof(game_state_t));

    game_state->num_rows = NUM_ROWS;
    game_state->board = malloc(sizeof(char *) * game_state->num_rows);
    game_state->board[0] = alloc_str("####################");
    for (int i = 1; i < game_state->num_rows - 1; ++i) {
        game_state->board[i] = alloc_str("#                  #");
    }
    game_state->board[game_state->num_rows - 1] = alloc_str("####################");

    game_state->num_snakes = 1;
    game_state->snakes = malloc(sizeof(snake_t) * game_state->num_snakes);
    game_state->snakes[0].tail_row = 2;
    game_state->snakes[0].tail_col = 2;
    game_state->snakes[0].head_row = 2;
    game_state->snakes[0].head_col = 4;
    game_state->snakes[0].live = true;
    game_state->board[2][2] = 'd';
    game_state->board[2][3] = '>';
    game_state->board[2][4] = 'D';

    game_state->board[2][9] = '*';

    return game_state;
}

/* Task 2 */
void free_state(game_state_t *state) {
    // TODO: Implement this function.
    for (int i = 0; i < state->num_rows; ++i) {
        free(state->board[i]);
    }
    free(state->board);
    free(state->snakes);
    free(state);
}

/* Task 3 */
void print_board(game_state_t *state, FILE *fp) {
    // TODO: Implement this function.
    for (int i = 0; i < state->num_rows; ++i) {
        fprintf(fp, "%s\n", state->board[i]);
    }
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t *state, char *filename) {
    FILE *f = fopen(filename, "w");
    print_board(state, f);
    fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t *state, unsigned int row, unsigned int col) {
    return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch) {
    state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
    // TODO: Implement this function.
    switch (c) {
        case 'w':
        case 'a':
        case 's':
        case 'd':
            return true;
        default:
            return false;
    }
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
    // TODO: Implement this function.
    switch (c) {
        case 'W':
        case 'A':
        case 'S':
        case 'D':
        case 'x':
            return true;
        default:
            return false;
    }
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
    // TODO: Implement this function.
    if (is_head(c) || is_tail(c)) {
        return true;
    }
    switch (c) {
        case '^':
        case '<':
        case 'v':
        case '>':
            return true;
        default:
            return false;
    }
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
    // TODO: Implement this function.
    switch (c) {
        case '^':
            return 'w';
        case '<':
            return 'a';
        case 'v':
            return 's';
        case '>':
            return 'd';
        default:
            return '?';
    }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
    // TODO: Implement this function.
    switch (c) {
        case 'W':
            return '^';
        case 'A':
            return '<';
        case 'S':
            return 'v';
        case 'D':
            return '>';
        default:
            return '?';
    }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
    // TODO: Implement this function.
    switch (c) {
        case 'v':
        case 's':
        case 'S':
            return cur_row + 1;
        case '^':
        case 'w':
        case 'W':
            return cur_row - 1;
        default:
            return cur_row;
    }
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
    // TODO: Implement this function.
    switch (c) {
        case '>':
        case 'd':
        case 'D':
            return cur_col + 1;
        case '<':
        case 'a':
        case 'A':
            return cur_col - 1;
        default:
            return cur_col;
    }
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t *state, unsigned int snum) {
    // TODO: Implement this function.
    snake_t *snake = &(state->snakes[snum]);
    char cur_head = state->board[snake->head_row][snake->head_col];
    unsigned int next_row = get_next_row(snake->head_row, cur_head);
    unsigned int next_col = get_next_col(snake->head_col, cur_head);
    return state->board[next_row][next_col];
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t *state, unsigned int snum) {
    // TODO: Implement this function.
    snake_t *snake = state->snakes + snum;
    char cur_head = state->board[snake->head_row][snake->head_col];
    unsigned int next_row = get_next_row(snake->head_row, cur_head);
    unsigned int next_col = get_next_col(snake->head_col, cur_head);
    state->board[next_row][next_col] = cur_head;
    state->board[snake->head_row][snake->head_col] = head_to_body(cur_head);
    snake->head_row = next_row;
    snake->head_col = next_col;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t *state, unsigned int snum) {
    // TODO: Implement this function.
    snake_t *snake = state->snakes + snum;
    char cur_tail = state->board[snake->tail_row][snake->tail_col];
    unsigned int next_row = get_next_row(snake->tail_row, cur_tail);
    unsigned int next_col = get_next_col(snake->tail_col, cur_tail);
    state->board[snake->tail_row][snake->tail_col] = ' ';
    state->board[next_row][next_col] = body_to_tail(state->board[next_row][next_col]);
    snake->tail_row = next_row;
    snake->tail_col = next_col;
}

/* Task 4.5 */
void update_state(game_state_t *state, int (*add_food)(game_state_t *state)) {
    for (unsigned int i = 0; i < state->num_snakes; ++i) {
        if (!state->snakes[i].live) {
            continue;
        }
        char next = next_square(state, i);
        if (is_snake(next) || next == '#') {
            state->snakes[i].live = false;
            state->board[state->snakes[i].head_row][state->snakes[i].head_col] = 'x';
            continue;
        }
        if (next == ' ') {
            update_tail(state, i);
        }
        update_head(state, i);
        if (next == '*') {
            add_food(state);
        }
    }
}

/* Task 5 */
game_state_t *load_board(char *filename) {
    // TODO: Implement this function.
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        return NULL;
    }

    game_state_t *game_state = malloc(sizeof(game_state_t));
    game_state->num_rows = 0;
    game_state->board = NULL;
    game_state->num_snakes = 0;
    game_state->snakes = NULL;

    char *line_buffer = NULL;
    size_t line_buffer_cap = 0;
    ssize_t line_len;

    size_t num_rows_cap = 8;
    char **board = malloc(num_rows_cap * sizeof(char *));

    while ((line_len = getline(&line_buffer, &line_buffer_cap, f)) > 0) {
        line_buffer[line_len - 1] = '\0'; // remove newline
        char *row = malloc(sizeof(char) * ((size_t) line_len));
        strcpy(row, line_buffer);
        if (game_state->num_rows >= num_rows_cap) {
            num_rows_cap *= 2;
            char **new_board = realloc(board, num_rows_cap * sizeof(char *));
            if (new_board == NULL) {
                exit(1);
            }
            board = new_board;
        }
        board[game_state->num_rows++] = row;
    }

    game_state->board = realloc(board, game_state->num_rows * sizeof(char *));
    free(line_buffer);
    fclose(f);
    return game_state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t *state, unsigned int snum) {
    // TODO: Implement this function.
    snake_t *snake = state->snakes + snum;
    unsigned int row = snake->tail_row, col = snake->tail_col;
    char c = state->board[row][col];
    while (!is_head(c)) {
        row = get_next_row(row, c);
        col = get_next_col(col, c);
        c = state->board[row][col];
    }
    snake->head_row = row;
    snake->head_col = col;
    snake->live = c != 'x';
}

/* Task 6.2 */
game_state_t *initialize_snakes(game_state_t *state) {
    // TODO: Implement this function.
    state->snakes = malloc(sizeof(snake_t) * 1);
    size_t buffer_cap = 1;
    unsigned int num_snakes = 0;
    for (unsigned int i = 0; i < state->num_rows; ++i) {
        for (unsigned int j = 0; j < strlen(state->board[i]); ++j) {
            if (is_tail(state->board[i][j])) {
                if (num_snakes >= buffer_cap) {
                    buffer_cap *= 2;
                    snake_t *new_snakes_buffer = realloc(state->snakes, buffer_cap * sizeof(snake_t));
                    if (new_snakes_buffer == NULL) {
                        fprintf(stderr, "realloc failed\n");
                        exit(1);
                    }
                    state->snakes = new_snakes_buffer;
                }
                snake_t *snake = state->snakes + num_snakes;
                snake->tail_row = i;
                snake->tail_col = j;
                find_head(state, num_snakes);
                ++num_snakes;
            }
        }
    }
    state->snakes = realloc(state->snakes, num_snakes * sizeof(snake_t));
    state->num_snakes = num_snakes;
    return state;
}
