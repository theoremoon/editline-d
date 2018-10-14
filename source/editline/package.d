module editline;
/*	$NetBSD: readline.h,v 1.42 2017/09/01 10:19:10 christos Exp $	*/

/*-
 * Copyright (c) 1997 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * This code is derived from software contributed to The NetBSD Foundation
 * by Jaromir Dolecek.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import core.stdc.stdio;

extern (C):

/* list of readline stuff supported by editline library's readline wrapper */

/* typedefs */
alias Function = int function (const(char)*, int);
alias VFunction = void function ();
alias rl_vcpfunc_t = void function (char*);
alias rl_completion_func_t = char** function (const(char)*, int, int);
alias rl_compentry_func_t = char* function (const(char)*, int);
alias rl_command_func_t = int function (int, int);

/* only supports length */
struct HISTORY_STATE
{
    int length;
}

alias histdata_t = void*;

struct _hist_entry
{
    const(char)* line;
    histdata_t data;
}

alias HIST_ENTRY = _hist_entry;

struct _keymap_entry
{
    char type;

    int function () function_;
}

enum ISFUNC = 0;
enum ISKMAP = 1;
enum ISMACR = 2;
alias KEYMAP_ENTRY = _keymap_entry;

enum KEYMAP_SIZE = 256;

alias KEYMAP_ENTRY_ARRAY = _keymap_entry[KEYMAP_SIZE];
alias Keymap = _keymap_entry*;

enum control_character_threshold = 0x20;
enum control_character_bit = 0x40;

auto CTRL(T)(T c) {return (c) & 31; }

extern (D) auto UNCTRL(T)(auto ref T c)
{
    return (c - 'a' + 'A') | control_character_bit;
}

enum RUBOUT = 0x7f;
enum ABORT_CHAR = CTRL('G');
enum RL_READLINE_VERSION = 0x0402;
enum RL_PROMPT_START_IGNORE = '\1';
enum RL_PROMPT_END_IGNORE = '\2';

/* global variables used by readline enabled applications */

extern __gshared const(char)* rl_library_version;
extern __gshared int rl_readline_version;
extern __gshared char* rl_readline_name;
extern __gshared FILE* rl_instream;
extern __gshared FILE* rl_outstream;
extern __gshared char* rl_line_buffer;
extern __gshared int rl_point;
extern __gshared int rl_end;
extern __gshared int history_base;
extern __gshared int history_length;
extern __gshared int max_input_history;
extern __gshared char* rl_basic_word_break_characters;
extern __gshared char* rl_completer_word_break_characters;
extern __gshared char* rl_completer_quote_characters;
extern __gshared char* function () rl_completion_entry_function;
extern __gshared char* function () rl_completion_word_break_hook;
extern __gshared char** function () rl_attempted_completion_function;
extern __gshared int rl_attempted_completion_over;
extern __gshared int rl_completion_type;
extern __gshared int rl_completion_query_items;
extern __gshared char* rl_special_prefixes;
extern __gshared int rl_completion_append_character;
extern __gshared int rl_inhibit_completion;
extern __gshared int function () rl_pre_input_hook;
extern __gshared int function () rl_startup_hook;
extern __gshared char* rl_terminal_name;
extern __gshared int rl_already_prompted;
extern __gshared char* rl_prompt;
extern __gshared int rl_done;
/*
 * The following is not implemented
 */
extern __gshared int rl_catch_signals;
extern __gshared int rl_catch_sigwinch;
extern __gshared KEYMAP_ENTRY_ARRAY emacs_standard_keymap;
extern __gshared KEYMAP_ENTRY_ARRAY emacs_meta_keymap;
extern __gshared KEYMAP_ENTRY_ARRAY emacs_ctlx_keymap;
extern __gshared int rl_filename_completion_desired;
extern __gshared int rl_ignore_completion_duplicates;
extern __gshared int function (FILE*) rl_getc_function;
extern __gshared void function () rl_redisplay_function;
extern __gshared void function () rl_completion_display_matches_hook;
extern __gshared void function () rl_prep_term_function;
extern __gshared void function () rl_deprep_term_function;
extern __gshared int readline_echoing_p;
extern __gshared int _rl_print_completions_horizontally;

/* supported functions */
char* readline (const(char)*);
int rl_initialize ();

void using_history ();
int add_history (const(char)*);
void clear_history ();
int append_history (int, const(char)*);
void stifle_history (int);
int unstifle_history ();
int history_is_stifled ();
int where_history ();
HIST_ENTRY* current_history ();
HIST_ENTRY* history_get (int);
HIST_ENTRY* remove_history (int);
HIST_ENTRY* replace_history_entry (int, const(char)*, histdata_t);
int history_total_bytes ();
int history_set_pos (int);
HIST_ENTRY* previous_history ();
HIST_ENTRY* next_history ();
HIST_ENTRY** history_list ();
int history_search (const(char)*, int);
int history_search_prefix (const(char)*, int);
int history_search_pos (const(char)*, int, int);
int read_history (const(char)*);
int write_history (const(char)*);
int history_truncate_file (const(char)*, int);
int history_expand (char*, char**);
char** history_tokenize (const(char)*);
const(char)* get_history_event (const(char)*, int*, int);
char* history_arg_extract (int, int, const(char)*);

char* tilde_expand (char*);
char* filename_completion_function (const(char)*, int);
char* username_completion_function (const(char)*, int);
int rl_complete (int, int);
int rl_read_key ();
char** completion_matches (const(char)*, char* function ());
void rl_display_match_list (char**, int, int);

int rl_insert (int, int);
int rl_insert_text (const(char)*);
void rl_reset_terminal (const(char)*);
void rl_resize_terminal ();
int rl_bind_key (int, int function ());
int rl_newline (int, int);
void rl_callback_read_char ();
void rl_callback_handler_install (const(char)*, void function ());
void rl_callback_handler_remove ();
void rl_redisplay ();
int rl_get_previous_history (int, int);
void rl_prep_terminal (int);
void rl_deprep_terminal ();
int rl_read_init_file (const(char)*);
int rl_parse_and_bind (const(char)*);
int rl_variable_bind (const(char)*, const(char)*);
void rl_stuff_char (int);
int rl_add_defun (const(char)*, int function (), int);
HISTORY_STATE* history_get_history_state ();
void rl_get_screen_size (int*, int*);
void rl_set_screen_size (int, int);
char* rl_filename_completion_function (const(char)*, int);
int _rl_abort_internal ();
int _rl_qsort_string_compare (char**, char**);
char** rl_completion_matches (const(char)*, char* function ());
void rl_forced_update_display ();
int rl_set_prompt (const(char)*);
int rl_on_new_line ();

/*
 * The following are not implemented
 */
int rl_kill_text (int, int);
Keymap rl_get_keymap ();
void rl_set_keymap (Keymap);
Keymap rl_make_bare_keymap ();
int rl_generic_bind (int, const(char)*, const(char)*, Keymap);
int rl_bind_key_in_map (int, int function (), Keymap);
void rl_cleanup_after_signal ();
void rl_free_line_state ();
int rl_set_keyboard_input_timeout (int);

/* _READLINE_H_ */
