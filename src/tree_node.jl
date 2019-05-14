"""
A TreeNode represents a single element of an evaluable expression.
It can represent either a value, or an operation such as addition.

For example, a node with the '+' operator and three children with the values 1, 5, and 10
will return the value 16 when evaluated.

Of course, any child may also be an operator; in this way, complex expressions can be built.
Values are of type Float64, and randomly generated values are between 0.0 and 1.0
"""
module TreeNode
	"A node can function as either a value, or an operator on its children (e.g. `+`)."
	Function = Union{Float64, Char}

	operators = ['+', '-', '*']

	mutable struct Node
		valOp::Function # The value or operator that the node functionally represents
		children::Vector{Node}
	end

	Node()                = Node(0.0,   Vector{Node}())
	Node(valOp::Function) = Node(valOp, Vector{Node}())

	function generateRandom()::Node
		if rand(Bool)
			# Generate a Value node
			value = rand()
			return Node(value)

		else
			# Generate an Operator node
			index = rand(1:length(operators))
			return Node(operators[index])
		end
	end

	function setValue(node::Node, value::Float64)
		@assert isLeaf(node) # Only a leaf can be a value; a parent must be an operator
		node.valOp = value
	end

	function setOperator(node::Node, operator::Char)
		@assert operator in operators
		node.valOp = operator
	end

	function addChild(parent::Node, child::Node)
		@assert isOperator(parent) # A node must be an operator before it can accept children
		push!(parent.children, child)
	end

	function isLeaf(node::Node)::Bool
		return length(node.children) == 0
	end

	function isOperator(node::Node)::Bool
		return typeof(node.valOp) == Char
	end
end
