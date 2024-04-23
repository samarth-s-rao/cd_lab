#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "abstract_syntax_tree.h"

expression_node* init_exp_node(char* val, expression_node* left, expression_node* right)
{
	// function to allocate memory for an AST node and set the left and right children of the nodes
	expression_node* new_node = (expression_node*)malloc(sizeof(expression_node));
    if (new_node == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    new_node->value = strdup(val); // strdup to duplicate the string
    if (new_node->value == NULL) {
        fprintf(stderr, "String duplication failed\n");
        free(new_node);
        exit(EXIT_FAILURE);
    }

    new_node->left = left;
    new_node->right = right;

    return new_node;
}

void display_exp_tree(expression_node* exp_node)
{
	// traversing the AST in preorder and displaying the nodes
	if (exp_node == NULL)
        return;

    // Display the current node
    printf("%s ", exp_node->value);

    // Traverse left subtree
    display_exp_tree(exp_node->left);

    // Traverse right subtree
    display_exp_tree(exp_node->right);
}