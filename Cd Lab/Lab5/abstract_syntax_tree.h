typedef struct expression_node
{
	char* value; // To store the value of the node
    struct expression_node* left; // Pointer to the left child
    struct expression_node* right; // Pointer to the right child
}expression_node;

expression_node* init_exp_node(char* val, expression_node* left, expression_node* right);
void display_exp_tree(expression_node* exp_node);
