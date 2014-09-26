

Rem
bbdoc: quadtree constructor
endrem
Function CreateQuadTree:TQuadTree(itemMax:Int = DEFAULT_MAX_ITEMS, ..
				 x:Int = -10, y:Int = -10, w:Int = 20, h:Int = 20)
	Local q:TQuadTree = New TQuadTree
	q.SetMaxItems(itemMax)
	q.SetArea(x,y, w,h)
	Return q
End Function


Const DEFAULT_MAX_ITEMS:Int = 50



Rem
bbdoc: A Quadtree to divide world space in rectangles.
about: Manages the world size, quadtree nodes and items
endrem
Type TQuadTree

	'head node of this tree
	Field _head:TQuadTreeNode
	
	'the max amount of items in a node before it needs partitioning
	Field _maxItems:Int
	
	'total world size
	Field _area:TRect

		
	Method New()
		_head = New TQuadTreeNode
		_area = New TRect
	End Method
	
	
	Rem
	bbdoc: Set QuadTree world area
	endrem
	Method SetArea( x:Int,y:Int, w:Int, h:Int )
		_area.SetPosition(x, y)
		_area.SetDimension(w, h)
	End Method

		
	Rem
	bbdoc: Sets the maximum amount of items before a node is subdivided.
	endrem
	Method SetMaxItems(m:Int)
		_maxItems = m
	End Method
		
	
	rem
	bbdoc: Inserts an item in the tree.
	about: Resizes the world if necessary.
	endrem
	Method InsertItem( i:TQuadTreeItem)	
		If Not _area.Inside(i.GetBoundingBox())
		
			'resize the world to make item fit
			Resize(i.GetBoundingBox())
		End If
		
		'add item
		_head.InsertItem(i)
	End Method
	
	
	
	Rem
	bbdoc: Resizes the world so passed rect fits inside.
	endrem
	Method Resize(r:TRect)

		'increase world area until rect fits completely
		While Not _area.Inside(r)
			_area.GetPosition().Multiply(2)
			_area.GetDimension().Multiply(2)
		Wend
		
		'done		
		'get all items in the tree
		Local l:TList = New TList
		_head.GetAllItems(l)
		
		'cut down tree
		_head.Free()
		_head = Null
		
		'create a new root.
		_head = New TQuadTreeNode.Create(_area.GetX(), _area.GetY(),  ..
			_area.GetWidth(), _area.GetHeight(), Self, _maxItems, Null)
		
		're-insert all items
		For Local i:TQuadTreeItem = EachIn l
			_head.InsertItem(i)
		Next
	End Method
	
	
	
	Rem
	bbdoc: Returns all items from quadtree overlapping rect
	endrem
	Method GetItems:TList(r:TRect)
		Local l:TList = New TList
		_head.GetItems(l, r)
		Return l
	End Method
	

		
	Rem
	bbdoc: Returns a list of all items in this tree
	endrem	
	Method GetAllItems:TList()
		Local l:TList = New TList
		_head.GetAllItems(l)
		Return l
	End Method

End Type