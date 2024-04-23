/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     VOID = 258,
     INT = 259,
     FLOAT = 260,
     DOUBLE = 261,
     CHAR = 262,
     STATIC = 263,
     ID = 264,
     INCLUDE = 265,
     HEADER = 266,
     MAIN = 267,
     DO = 268,
     WHILE = 269,
     IF = 270,
     ELSE = 271,
     FOR = 272,
     BOOL = 273,
     BREAK = 274,
     INC = 275,
     DEC = 276,
     STRLIT = 277,
     VNUM = 278,
     LT = 279,
     GT = 280,
     GTE = 281,
     LTE = 282,
     EQ = 283,
     NE = 284,
     OR = 285,
     AND = 286,
     LNOT = 287,
     SCOMB = 288,
     ECOMB = 289,
     SSQB = 290,
     ESQB = 291,
     SCURB = 292,
     ECURB = 293,
     SWITCH = 294,
     CASE = 295,
     DEFAULT = 296
   };
#endif
/* Tokens.  */
#define VOID 258
#define INT 259
#define FLOAT 260
#define DOUBLE 261
#define CHAR 262
#define STATIC 263
#define ID 264
#define INCLUDE 265
#define HEADER 266
#define MAIN 267
#define DO 268
#define WHILE 269
#define IF 270
#define ELSE 271
#define FOR 272
#define BOOL 273
#define BREAK 274
#define INC 275
#define DEC 276
#define STRLIT 277
#define VNUM 278
#define LT 279
#define GT 280
#define GTE 281
#define LTE 282
#define EQ 283
#define NE 284
#define OR 285
#define AND 286
#define LNOT 287
#define SCOMB 288
#define ECOMB 289
#define SSQB 290
#define ESQB 291
#define SCURB 292
#define ECURB 293
#define SWITCH 294
#define CASE 295
#define DEFAULT 296




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

