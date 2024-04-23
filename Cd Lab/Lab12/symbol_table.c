#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define the symbol structure
typedef struct Symbol {
    char name[50]; // Symbol name
    int line_number; // Line number where symbol is defined
    char token_name[50]; // Token name (e.g., identifier, keyword)
    char type[50]; // Type of the symbol
    char value[50]; // Value of the symbol
    char storage_required[50]; // Storage required by the symbol
    char scope[50]; // Scope information
    struct Symbol* next; // Pointer to the next symbol in the table
} Symbol;

// Global symbol table pointer
Symbol* symbol_table = NULL;

// Function to insert a symbol into the symbol table
void insert_symbol(const char* name, int line_number, const char* token_name,
                   const char* type, const char* value, const char* storage_required,
                   const char* scope) {
    Symbol* new_symbol = (Symbol*)malloc(sizeof(Symbol));
    if (new_symbol == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    strcpy(new_symbol->name, name);
    new_symbol->line_number = line_number;
    strcpy(new_symbol->token_name, token_name);
    strcpy(new_symbol->type, type);
    strcpy(new_symbol->value, value);
    strcpy(new_symbol->storage_required, storage_required);
    strcpy(new_symbol->scope, scope);
    new_symbol->next = symbol_table;
    symbol_table = new_symbol;
}

// Function to display the symbol table
void display_symbol_table() {
    printf("Symbol Table:\n");
    printf("%-20s %-10s %-10s %-10s %-10s %-10s %-10s\n", "Name", "Line", "Token", "Type", "Value", "Storage", "Scope");
    Symbol* current = symbol_table;
    while (current != NULL) {
        printf("%-20s %-10d %-10s %-10s %-10s %-10s %-10s\n", current->name, current->line_number,
               current->token_name, current->type, current->value, current->storage_required, current->scope);
        current = current->next;
    }
}

int main() {
    // Example: Inserting symbols into the table
    insert_symbol("a", 10, "identifier", "int", "10", "4 bytes", "global");
    insert_symbol("b", 12, "identifier", "float", "20.5", "4 bytes", "local");
    insert_symbol("c", 15, "identifier", "char", "'A'", "1 byte", "global");

    // Display the symbol table
    display_symbol_table();

    return 0;
}
