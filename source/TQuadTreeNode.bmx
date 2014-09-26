

rem
	bbdoc: Node for use in a quad tree.
	
	about:
	leaf node = not subdivided, contains items
	branch node = subdivided, has children nodes, contains no items
	
end rem
Type TQuadTreeNode
	
	'area covered by node
	Field _area:TRect
	
	'node items are listed here
	Field _itemList:TList

	'child nodes will go here
	'0 = topleft, 1 = topright, 2 = bottomleft, 3 = bottomright.
	'if this node contains nodes, then it cannot contain items
	'and is a branch node.
	Field _node:TQuadTreeNode[4]
		
	'bool
	Field _partitioned:Int
	
	'max amount of items in this node before subdivide
	Field _maxItems:Int
	
	'reference to this nodes' parent node
	Field _parentNode:TQuadTreeNode
	
	'reference to tree this node belongs to
	'enables this node to call TQuadTree.Resize() method
	Field _parentTree:TQuadTree
		
		
	Method New()
		_itemList = New TList
		_area = New TRect
		_partitioned = False
	End Method
		
	
	Rem
	bbdoc: Constructor function.
	endrem
	Function Create:TQuadTreeNode(x:Int, y:Int, w:Int, h:Int, tree:TQuadTree, ..
				maxi:Int = DEFAULT_MAX_ITEMS, node:TQuadTreeNode = Null)

		local n:TQuadTreeNode = New TQuadTreeNode
		n.SetParentNode(node)
		n.SetParentTree(tree)
		n.SetMaxItems(maxi)
		n.SetArea(x,y, w,h)
		Return n
	End Function
	
	
	Rem
	bbdoc: Frees node content.
	endrem
	Method Free()
		_itemList.Clear()
		_itemList = Null
		_area = Null
		
		If _partitioned
			For Local n:Int = 0 To 3
				_node[n].Free()
			Next
		End If
	End Method
	
		
	Rem
	bbdoc: Sets this node size.
	endrem	
	Method SetArea(x:Int, y:Int, w:Int, h:Int)
		_area.SetPosition(x, y)
		_area.SetDimension(w, h)
	End Method
	

	Rem
	bbdoc: Sets tree this node belongs to.
	endrem
	Method SetParentTree(t:TQuadTree)
		_parentTree = t
	End Method
	
	
	Rem
	bbdoc: Sets parent of this node.
	endrem
	Method SetParentNode( q:TQuadTreeNode)
		_parentNode = q
	End Method
	
	
	Rem
	bbdoc: sets the maximum amount of items for this node.
	endrem
	Method SetMaxItems(m:Int)
		_maxItems = m
	End Method
	
		
	Rem
	bbdoc: partition this node.
	endrem	
	Method Partition()
		If Not _partitioned
			Local childWidth:Int = _area.GetWidth() / 2
			Local childHeight:Int = _area.GetHeight() / 2
			'topleft
			_node[0] = New TQuadTreeNode.Create(_area.GetX(), _area.GetY(),  ..
						childWidth, childHeight, _parentTree, _maxItems, Self)
			'topright
			_node[1] = New TQuadTreeNode.Create(_area.GetX() + childWidth, _area.GetY(),  ..
						childWidth, childHeight, _parentTree, _maxItems, Self)
			'bottomleft
			_node[2] = New TQuadTreeNode.Create(_area.GetX(), _area.GetY() + childHeight,  ..
						childWidth, childHeight, _parentTree, _maxItems, Self)
			'bottomright
			_node[3] = New TQuadTreeNode.Create(_area.GetX() + childWidth, _area.GetY() + childHeight,  ..
						childWidth, childHeight, _parentTree, _maxItems, Self)

			_partitioned = True
			
			'move items in this node to the new child nodes
			For Local i:TQuadTreeItem = EachIn _itemList
				PushItemDown(i)
			Next
		End If
	End Method
	

	Rem
	bbdoc: Addss all items in this node to passed list.	
	about: recursive called when node is partioned.
	endrem	
	Method GetAllItems(l:TList)

		'add all items in this node to list
		For Local i:TQuadTreeItem = EachIn _itemList
			l.AddLast(i)
		Next
		
		'get items in children
		If _partitioned
			For Local n:Int = 0 To 3
				_node[n].GetAllItems(l)
			Next
		End If		
	End Method
	
	
	Rem
	bbdoc: Adds all items that overlap passed area to passed list.
	endrem
	Method GetItems(l:TList, r:TRect)
	
		'check if passed rect overlaps this node area
		If _area.OverLappedBy(r)
			
			'find all items in this node that overlap passed rect.
			For Local i:TQuadTreeItem = EachIn _itemList
				If r.OverLappedBy(i.GetBoundingBox()) Then l.AddLast(i)
			Next
			
			'check all subnodes
			If _partitioned
				For Local n:Int = 0 To 3
					_node[n].GetItems(l, r)
				Next			
			End If
		End If
	End Method

	
	Rem
	bbdoc: Inserts an item into this node.
	about: Partitions this node when needed.
	endrem
	Method InsertItem(i:TQuadTreeItem)
		If Not InsertInChild(i)
		
			'not added to child node: add to this node.
			'but only once.
			If _itemList.Contains(i) Then Return
			
			_itemList.AddLast(i)
			i.SetParent(Self)
			
			'need to partition this node?
			If Not _partitioned And _itemList.Count() >= _maxItems
				Partition()
			End If
		EndIf
	End Method
	
	
	Rem
	bbdoc: Try to insert item into child node.
	about: Call back to InsertItem() adds recursion.
	endrem
	Method InsertInChild:Int(i:TQuadTreeItem)
	
		'cannot add to this node if not partitioned
		If Not _partitioned Then Return False
		
		'add to one of the child nodes
		For Local n:Int = 0 To 3			
			If _node[n].RectInNode(i.GetBoundingBox())
				_node[n].InsertItem(i)
				Return True
			End If
		Next
		Return False
	End Method
	
	
	Rem
	bbdoc: Moves item to a child node.
	returns: True if move succeeded.
	endrem
	Method PushItemDown:Int(i:TQuadTreeItem)	
		If InsertInChild(i)
			_itemList.Remove(i)
			Return True
		End If
		Return False
	End Method
	
	
	Rem
	bbdoc: Moves item to this node's parent node.
	endrem
	Method PushItemUp:Int(i:TQuadTreeItem)
		_itemList.Remove(i)
		_parentNode.InsertItem(i)
	End Method
	
	
	Rem
	bbdoc: Tries to move item in the tree.
	about: To be called when item moves around in the world.
	End rem
	Method MoveItem(i:TQuadTreeItem)
		If Not PushItemDown(i)
		
			'no child node accepts this item,
			'push to parent instead
			If _parentNode
				PushItemUp(i)
			ElseIf Not _area.Inside(i.GetBoundingBox())
				'we're in root node and items does not fit
				
				'resize world.
				'the item is moved as well during that operation
				_parentTree.Resize(i.GetBoundingBox())
			EndIf
		End If		
	End Method
	
	
	Rem
	bbdoc: returns true if passed rect is inside node area.
	endrem
	Method RectInNode:Int( r:TRect)
		Return _area.Inside(r)
	End Method
	
End Type
