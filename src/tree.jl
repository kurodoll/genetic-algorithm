"""
The Tree module contains methods dealing with Trees as a whole.
This includes printing, generation, and evaluation.
"""
module Tree
	include("tree_node.jl")

	"Given a root node (or any node in fact), will print the tree as a nested expression."
	function printAsExpr(node::TreeNode.Node)
		if typeof(node.valOp) == Float64
			print(' ', node.valOp)
		
		else
			print(" (", node.valOp)

			for child in node.children
				printAsExpr(child)
			end

			print(')')
		end
	end

	"Returns the number of nodes in a given tree."
	function getSize(node::TreeNode.Node)::Int
		size = 1

		for child in node.children
			size += getSize(child)
		end

		return size
	end

	"Returns a tree as a list of its nodes."
	function toVector(node::TreeNode.Node)::Vector{TreeNode.Node}
		nodes = [node]

		for child in node.children
			nodes = vcat(nodes, toVector(child))
		end

		return nodes
	end

	"Returns a random node from a given tree."
	function getRandomNode(node::TreeNode.Node)::TreeNode.Node
		nodeVector = toVector(node)
		nNodes = length(nodeVector)

		index = rand(1:nNodes)
		return nodeVector[index]
	end

	"Generates a completely random tree with the given number of nodes."
	function generateRandom(nNodes::Int)::TreeNode.Node
		root = TreeNode.generateRandom()

		# Continously find random nodes to make into parents
		for i in 2:nNodes # Start at 2, since we begin with a root node
			target = getRandomNode(root)

			if typeof(target.valOp) == Float64
				index = rand(1:length(TreeNode.operators))
				TreeNode.setOperator(target, TreeNode.operators[index])
			end

			TreeNode.addChild(target, TreeNode.generateRandom())
		end

		return fix(root)
	end

	"Finds Operator nodes with no children and turns them into Value nodes."
	function fix(node::TreeNode.Node)::TreeNode.Node
		if length(node.children) == 0 && typeof(node.valOp) == Char
			node.valOp = rand()
		
		else
			for child in node.children
				child = fix(child)
			end
		end

		return node
	end

	"Evaluates a tree as an expression, resulting in a single output."
	function evaluate(node::TreeNode.Node)::Float64
		if typeof(node.valOp) == Char
			if node.valOp == '+'
				return reduce(+, map(evaluate, node.children))

			elseif node.valOp == '-'
				return reduce(-, map(evaluate, node.children))

			else # multiplication
				return reduce(*, map(evaluate, node.children))
			end

		else
			return node.valOp
		end
	end
end
